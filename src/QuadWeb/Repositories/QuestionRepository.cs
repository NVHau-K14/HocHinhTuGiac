using Neo4j.Driver;
using QuadWeb.Models;
using QuadWeb.Services;

namespace QuadWeb.Repositories;

public class QuestionRepository : IQuestionRepository
{
    private readonly INeo4jDriverService _driverService;
    private readonly ILogger<QuestionRepository> _logger;

    public QuestionRepository(INeo4jDriverService driverService, ILogger<QuestionRepository> logger)
    {
        _driverService = driverService;
        _logger = logger;
    }

    public async Task<List<QuestionDto>> GetQuestionsByShapeAsync(string slug, int limit = 5)
    {
        await using var session = _driverService.CreateSession();
        var query = @"
            MATCH (sh:Shape {slug: $slug})-[:HAS_QUESTION]->(q:Question)
            MATCH (q)-[:HAS_OPTION]->(o:AnswerOption)
            WITH sh, q, collect({id: o.id, content: o.content}) AS options
            RETURN q.id AS id, q.content AS content, q.type AS type, q.difficulty AS difficulty,
                   sh.slug AS shapeSlug, sh.name AS shapeName, options
            ORDER BY q.id
            LIMIT $limit
        ";

        var cursor = await session.RunAsync(query, new { slug, limit });
        var result = new List<QuestionDto>();
        while (await cursor.FetchAsync())
        {
            var optionsRaw = cursor.Current["options"].As<List<Dictionary<string, object>>>();
            var options = optionsRaw.Select(dict => new OptionDto
            {
                Id = dict["id"].ToString() ?? string.Empty,
                Content = dict["content"].ToString() ?? string.Empty
            }).ToList();

            result.Add(new QuestionDto
            {
                Id = cursor.Current["id"].As<string>(),
                Content = cursor.Current["content"].As<string>(),
                Type = cursor.Current["type"].As<string?>() ?? "THEORY",
                Difficulty = cursor.Current["difficulty"].As<int?>() ?? 1,
                ShapeSlug = cursor.Current["shapeSlug"].As<string>(),
                ShapeName = cursor.Current["shapeName"].As<string>(),
                Options = options
            });
        }

        return result;
    }

    public async Task<PracticeCheckResult> CheckPracticeAnswerAsync(string questionId, string? selectedOptionId)
    {
        await using var session = _driverService.CreateSession();
        var query = @"
            MATCH (q:Question {id: $questionId})
            OPTIONAL MATCH (q)-[:HAS_OPTION]->(correctOpt:AnswerOption {isCorrect: true})
            RETURN q.explanation AS explanation, 
                   correctOpt.id AS correctOptionId, 
                   correctOpt.content AS correctOptionContent
        ";

        var cursor = await session.RunAsync(query, new { questionId });
        if (await cursor.FetchAsync())
        {
            var correctId = cursor.Current["correctOptionId"].As<string?>() ?? string.Empty;
            var correctContent = cursor.Current["correctOptionContent"].As<string?>() ?? string.Empty;
            var explanation = cursor.Current["explanation"].As<string?>() ?? string.Empty;

            var isCorrect = !string.IsNullOrEmpty(selectedOptionId) && 
                            string.Equals(selectedOptionId, correctId, StringComparison.OrdinalIgnoreCase);

            return new PracticeCheckResult
            {
                IsCorrect = isCorrect,
                CorrectOptionId = correctId,
                CorrectOptionContent = correctContent,
                Explanation = explanation
            };
        }

        return new PracticeCheckResult
        {
            IsCorrect = false,
            Explanation = "Không tìm thấy dữ liệu câu hỏi trong hệ thống."
        };
    }

    public async Task<List<QuestionDto>> GetQuizQuestionsAsync()
    {
        await using var session = _driverService.CreateSession();
        var query = @"
            MATCH (sh:Shape)-[:HAS_QUESTION]->(q:Question)
            MATCH (q)-[:HAS_OPTION]->(o:AnswerOption)
            WITH sh, q, collect({id: o.id, content: o.content}) AS options
            RETURN q.id AS id, q.content AS content, q.type AS type, q.difficulty AS difficulty,
                   sh.slug AS shapeSlug, sh.name AS shapeName, options
            ORDER BY sh.slug, q.id
        ";

        var cursor = await session.RunAsync(query);
        var allQuestions = new List<QuestionDto>();
        while (await cursor.FetchAsync())
        {
            var optionsRaw = cursor.Current["options"].As<List<Dictionary<string, object>>>();
            var options = optionsRaw.Select(dict => new OptionDto
            {
                Id = dict["id"].ToString() ?? string.Empty,
                Content = dict["content"].ToString() ?? string.Empty
            }).ToList();

            allQuestions.Add(new QuestionDto
            {
                Id = cursor.Current["id"].As<string>(),
                Content = cursor.Current["content"].As<string>(),
                Type = cursor.Current["type"].As<string?>() ?? "THEORY",
                Difficulty = cursor.Current["difficulty"].As<int?>() ?? 1,
                ShapeSlug = cursor.Current["shapeSlug"].As<string>(),
                ShapeName = cursor.Current["shapeName"].As<string>(),
                Options = options
            });
        }

        // Chọn 10 câu: Mỗi hình trong 8 hình ít nhất 1 câu, cộng thêm 2 câu bất kỳ
        var selectedQuestions = new List<QuestionDto>();
        var groupedByShape = allQuestions.GroupBy(q => q.ShapeSlug).ToList();
        var rng = new Random();

        var remainingPool = new List<QuestionDto>();

        foreach (var group in groupedByShape)
        {
            var list = group.ToList();
            int pickIndex = rng.Next(list.Count);
            selectedQuestions.Add(list[pickIndex]);

            for (int i = 0; i < list.Count; i++)
            {
                if (i != pickIndex)
                {
                    remainingPool.Add(list[i]);
                }
            }
        }

        // Thêm 2 câu bất kỳ từ pool còn lại
        remainingPool = remainingPool.OrderBy(_ => rng.Next()).ToList();
        selectedQuestions.AddRange(remainingPool.Take(2));

        // Trộn thứ tự hiển thị 10 câu
        return selectedQuestions.OrderBy(_ => rng.Next()).ToList();
    }

    public async Task<QuizResultViewModel> GradeQuizAsync(string quizId, List<UserAnswer> answers, string? clientId)
    {
        var questionIds = answers.Select(a => a.QuestionId).ToList();
        await using var session = _driverService.CreateSession();

        var query = @"
            UNWIND $questionIds AS qId
            MATCH (sh:Shape)-[:HAS_QUESTION]->(q:Question {id: qId})
            MATCH (q)-[:HAS_OPTION]->(o:AnswerOption)
            WITH sh, q, collect({id: o.id, content: o.content, isCorrect: o.isCorrect}) AS options
            RETURN q.id AS id, q.content AS content, q.type AS type, q.explanation AS explanation,
                   sh.name AS shapeName, options
        ";

        var cursor = await session.RunAsync(query, new { questionIds });
        var dbQuestions = new Dictionary<string, (string content, string type, string exp, string shapeName, List<(string id, string content, bool isCorrect)> opts)>();

        while (await cursor.FetchAsync())
        {
            var qId = cursor.Current["id"].As<string>();
            var content = cursor.Current["content"].As<string>();
            var type = cursor.Current["type"].As<string>();
            var exp = cursor.Current["explanation"].As<string>();
            var shapeName = cursor.Current["shapeName"].As<string>();
            var optsRaw = cursor.Current["options"].As<List<Dictionary<string, object>>>();

            var opts = optsRaw.Select(d => (
                id: d["id"].ToString() ?? string.Empty,
                content: d["content"].ToString() ?? string.Empty,
                isCorrect: Convert.ToBoolean(d["isCorrect"])
            )).ToList();

            dbQuestions[qId] = (content, type, exp, shapeName, opts);
        }

        var result = new QuizResultViewModel
        {
            QuizId = quizId,
            Total = answers.Count
        };

        var answeredData = new List<Dictionary<string, object>>();

        foreach (var userAns in answers)
        {
            if (!dbQuestions.TryGetValue(userAns.QuestionId, out var qData))
            {
                continue;
            }

            var correctOpt = qData.opts.FirstOrDefault(o => o.isCorrect);
            var selectedOpt = qData.opts.FirstOrDefault(o => o.id == userAns.SelectedOptionId);

            bool isCorrect = !string.IsNullOrEmpty(userAns.SelectedOptionId) &&
                             userAns.SelectedOptionId == correctOpt.id;

            if (isCorrect)
            {
                result.CorrectCount++;
            }

            result.Questions.Add(new QuizQuestionResultItem
            {
                QuestionId = userAns.QuestionId,
                Content = qData.content,
                Type = qData.type,
                ShapeName = qData.shapeName,
                SelectedOptionId = userAns.SelectedOptionId,
                SelectedOptionContent = selectedOpt.content ?? "(Chưa chọn đáp án)",
                CorrectOptionId = correctOpt.id,
                CorrectOptionContent = correctOpt.content,
                IsCorrect = isCorrect,
                Explanation = qData.exp,
                Options = qData.opts.Select(o => new OptionDto { Id = o.id, Content = o.content }).ToList()
            });

            answeredData.Add(new Dictionary<string, object>
            {
                { "questionId", userAns.QuestionId },
                { "selectedOptionId", userAns.SelectedOptionId ?? string.Empty },
                { "isCorrect", isCorrect }
            });
        }

        result.Score = result.CorrectCount * 10;

        // Lưu QuizAttempt vào Neo4j (nếu có clientId)
        if (!string.IsNullOrWhiteSpace(clientId))
        {
            try
            {
                var attemptId = Guid.NewGuid().ToString("N");
                var saveQuery = @"
                    MERGE (l:Learner {clientId: $clientId})
                    CREATE (a:QuizAttempt {
                        id: $attemptId,
                        score: $score,
                        correctCount: $correctCount,
                        total: $total,
                        completedAt: datetime()
                    })
                    CREATE (l)-[:MADE_ATTEMPT]->(a)
                    WITH a
                    UNWIND $answeredData AS ans
                    MATCH (q:Question {id: ans.questionId})
                    CREATE (a)-[:ANSWERED {selectedOptionId: ans.selectedOptionId, isCorrect: ans.isCorrect}]->(q)
                ";

                await session.RunAsync(saveQuery, new
                {
                    clientId,
                    attemptId,
                    score = result.Score,
                    correctCount = result.CorrectCount,
                    total = result.Total,
                    answeredData
                });
                result.SavedToLeaderboard = true;
            }
            catch (Exception ex)
            {
                _logger.LogWarning(ex, "Không thể lưu QuizAttempt vào Neo4j. Điểm vẫn được tính hợp lệ.");
                result.SavedToLeaderboard = false;
            }
        }

        return result;
    }
}
