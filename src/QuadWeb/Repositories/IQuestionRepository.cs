using QuadWeb.Models;

namespace QuadWeb.Repositories;

public interface IQuestionRepository
{
    Task<List<QuestionDto>> GetQuestionsByShapeAsync(string slug, int limit = 5);
    Task<PracticeCheckResult> CheckPracticeAnswerAsync(string questionId, string? selectedOptionId);
    Task<List<QuestionDto>> GetQuizQuestionsAsync();
    Task<QuizResultViewModel> GradeQuizAsync(string quizId, List<UserAnswer> answers, string? clientId);
}
