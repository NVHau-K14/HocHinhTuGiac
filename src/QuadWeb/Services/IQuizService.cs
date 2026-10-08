using QuadWeb.Models;

namespace QuadWeb.Services;

public interface IQuizService
{
    Task<List<QuestionDto>> GetPracticeQuestionsAsync(string slug);
    Task<PracticeCheckResult> CheckPracticeAnswerAsync(string questionId, string? selectedOptionId);
    Task<(string quizId, List<QuestionDto> questions)> CreateQuizSessionAsync();
    Task<QuizResultViewModel> SubmitQuizAsync(string quizId, List<UserAnswer> answers, string? clientId);
}
