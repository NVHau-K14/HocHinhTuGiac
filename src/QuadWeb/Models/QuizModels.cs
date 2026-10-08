namespace QuadWeb.Models;

public class OptionDto
{
    public string Id { get; set; } = string.Empty;
    public string Content { get; set; } = string.Empty;
}

public class QuestionDto
{
    public string Id { get; set; } = string.Empty;
    public string Content { get; set; } = string.Empty;
    public string Type { get; set; } = "THEORY";
    public int Difficulty { get; set; } = 1;
    public string ShapeSlug { get; set; } = string.Empty;
    public string ShapeName { get; set; } = string.Empty;
    public List<OptionDto> Options { get; set; } = new();
}

public class UserAnswer
{
    public string QuestionId { get; set; } = string.Empty;
    public string? SelectedOptionId { get; set; }
}

public class QuizSubmissionRequest
{
    public string QuizId { get; set; } = string.Empty;
    public List<UserAnswer> Answers { get; set; } = new();
}

public class PracticeCheckRequest
{
    public string QuestionId { get; set; } = string.Empty;
    public string? SelectedOptionId { get; set; }
}

public class PracticeCheckResult
{
    public bool IsCorrect { get; set; }
    public string CorrectOptionId { get; set; } = string.Empty;
    public string CorrectOptionContent { get; set; } = string.Empty;
    public string Explanation { get; set; } = string.Empty;
}

public class QuizQuestionResultItem
{
    public string QuestionId { get; set; } = string.Empty;
    public string Content { get; set; } = string.Empty;
    public string Type { get; set; } = "THEORY";
    public string ShapeName { get; set; } = string.Empty;
    public string? SelectedOptionId { get; set; }
    public string SelectedOptionContent { get; set; } = "(Chưa chọn)";
    public string CorrectOptionId { get; set; } = string.Empty;
    public string CorrectOptionContent { get; set; } = string.Empty;
    public bool IsCorrect { get; set; }
    public string Explanation { get; set; } = string.Empty;
    public List<OptionDto> Options { get; set; } = new();
}

public class QuizResultViewModel
{
    public string QuizId { get; set; } = string.Empty;
    public int Score { get; set; }
    public int CorrectCount { get; set; }
    public int Total { get; set; } = 10;
    public DateTime CompletedAt { get; set; } = DateTime.UtcNow;
    public bool SavedToLeaderboard { get; set; } = true;
    public List<QuizQuestionResultItem> Questions { get; set; } = new();
}
