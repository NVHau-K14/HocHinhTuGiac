using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Caching.Memory;
using QuadWeb.Middleware;
using QuadWeb.Models;
using QuadWeb.Services;

namespace QuadWeb.Controllers;

public class QuizController : Controller
{
    private readonly IQuizService _quizService;
    private readonly ILearnerService _learnerService;
    private readonly IMemoryCache _memoryCache;
    private readonly ILogger<QuizController> _logger;

    public QuizController(
        IQuizService quizService,
        ILearnerService learnerService,
        IMemoryCache memoryCache,
        ILogger<QuizController> logger)
    {
        _quizService = quizService;
        _learnerService = learnerService;
        _memoryCache = memoryCache;
        _logger = logger;
    }

    private async Task PopulateLearnerAsync()
    {
        var clientId = HttpContext.Items[LearnerMiddleware.ItemKey] as string ?? string.Empty;
        var learner = await _learnerService.GetOrCreateLearnerAsync(clientId);
        ViewBag.DisplayName = learner.DisplayName;
    }

    [HttpGet("/quiz")]
    public async Task<IActionResult> Index()
    {
        await PopulateLearnerAsync();
        var (quizId, questions) = await _quizService.CreateQuizSessionAsync();
        ViewBag.QuizId = quizId;
        return View(questions);
    }

    [HttpPost("/quiz/submit")]
    public async Task<IActionResult> Submit([FromBody] QuizSubmissionRequest request)
    {
        if (request == null || string.IsNullOrWhiteSpace(request.QuizId) || request.Answers == null)
        {
            return BadRequest(new { error = "Dữ liệu nộp bài không hợp lệ." });
        }

        var clientId = HttpContext.Items[LearnerMiddleware.ItemKey] as string;

        try
        {
            var result = await _quizService.SubmitQuizAsync(request.QuizId, request.Answers, clientId);
            return Ok(new { success = true, quizId = result.QuizId });
        }
        catch (InvalidOperationException ex)
        {
            return BadRequest(new { error = ex.Message });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Lỗi khi chấm điểm quiz");
            return StatusCode(500, new { error = "Đã xảy ra lỗi khi chấm điểm. Vui lòng thử lại." });
        }
    }

    [HttpGet("/quiz/result/{quizId}")]
    public async Task<IActionResult> Result(string quizId)
    {
        await PopulateLearnerAsync();
        if (string.IsNullOrWhiteSpace(quizId))
        {
            return RedirectToAction("Index");
        }

        if (!_memoryCache.TryGetValue<QuizResultViewModel>($"quiz_result_{quizId}", out var result) || result == null)
        {
            ViewBag.Message = "Kết quả bài quiz đã hết hạn lưu trữ hoặc không tồn tại.";
            return View("Expired");
        }

        return View(result);
    }
}
