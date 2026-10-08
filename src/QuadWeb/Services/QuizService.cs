using Microsoft.Extensions.Caching.Memory;
using QuadWeb.Models;
using QuadWeb.Repositories;

namespace QuadWeb.Services;

public class QuizService : IQuizService
{
    private readonly IQuestionRepository _questionRepository;
    private readonly IMemoryCache _memoryCache;
    private readonly ILogger<QuizService> _logger;

    public QuizService(
        IQuestionRepository questionRepository,
        IMemoryCache memoryCache,
        ILogger<QuizService> logger)
    {
        _questionRepository = questionRepository;
        _memoryCache = memoryCache;
        _logger = logger;
    }

    public Task<List<QuestionDto>> GetPracticeQuestionsAsync(string slug)
    {
        return _questionRepository.GetQuestionsByShapeAsync(slug, 5);
    }

    public Task<PracticeCheckResult> CheckPracticeAnswerAsync(string questionId, string? selectedOptionId)
    {
        return _questionRepository.CheckPracticeAnswerAsync(questionId, selectedOptionId);
    }

    public async Task<(string quizId, List<QuestionDto> questions)> CreateQuizSessionAsync()
    {
        var quizId = Guid.NewGuid().ToString("N");
        var questions = await _questionRepository.GetQuizQuestionsAsync();
        var questionIds = questions.Select(q => q.Id).ToList();

        // Lưu danh sách câu hỏi vào cache (hết hạn sau 60 phút)
        _memoryCache.Set($"quiz_{quizId}", questionIds, TimeSpan.FromMinutes(60));

        return (quizId, questions);
    }

    public async Task<QuizResultViewModel> SubmitQuizAsync(string quizId, List<UserAnswer> answers, string? clientId)
    {
        if (!_memoryCache.TryGetValue<List<string>>($"quiz_{quizId}", out var validQuestionIds) || validQuestionIds == null)
        {
            throw new InvalidOperationException("Phiên làm bài quiz đã hết hạn hoặc không hợp lệ. Vui lòng bắt đầu bài quiz mới.");
        }

        // Đảm bảo đối chiếu đủ bộ 10 câu hỏi đã cấp cho quiz này
        var answerDict = answers.ToDictionary(a => a.QuestionId, a => a.SelectedOptionId);
        var finalAnswers = validQuestionIds.Select(qId => new UserAnswer
        {
            QuestionId = qId,
            SelectedOptionId = answerDict.TryGetValue(qId, out var optId) ? optId : null
        }).ToList();

        // Chấm điểm an toàn tại backend
        var result = await _questionRepository.GradeQuizAsync(quizId, finalAnswers, clientId);

        // Lưu kết quả vào cache để người dùng có thể xem lại ngay sau khi nộp
        _memoryCache.Set($"quiz_result_{quizId}", result, TimeSpan.FromMinutes(60));

        return result;
    }
}
