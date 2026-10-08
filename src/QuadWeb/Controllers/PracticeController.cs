using Microsoft.AspNetCore.Mvc;
using QuadWeb.Middleware;
using QuadWeb.Models;
using QuadWeb.Services;

namespace QuadWeb.Controllers;

public class PracticeController : Controller
{
    private readonly IShapeService _shapeService;
    private readonly IQuizService _quizService;
    private readonly ILearnerService _learnerService;
    private readonly ILogger<PracticeController> _logger;

    public PracticeController(
        IShapeService shapeService,
        IQuizService quizService,
        ILearnerService learnerService,
        ILogger<PracticeController> logger)
    {
        _shapeService = shapeService;
        _quizService = quizService;
        _learnerService = learnerService;
        _logger = logger;
    }

    private async Task PopulateLearnerAsync()
    {
        var clientId = HttpContext.Items[LearnerMiddleware.ItemKey] as string ?? string.Empty;
        var learner = await _learnerService.GetOrCreateLearnerAsync(clientId);
        ViewBag.DisplayName = learner.DisplayName;
    }

    [HttpGet("/practice")]
    public async Task<IActionResult> Index()
    {
        await PopulateLearnerAsync();
        var shapes = await _shapeService.GetAllShapesAsync();
        return View(shapes);
    }

    [HttpGet("/practice/{slug}")]
    public async Task<IActionResult> Detail(string slug)
    {
        await PopulateLearnerAsync();
        if (string.IsNullOrWhiteSpace(slug))
        {
            return RedirectToAction("Index");
        }

        var shape = await _shapeService.GetShapeBySlugAsync(slug.Trim().ToLowerInvariant());
        if (shape == null)
        {
            return NotFound();
        }

        var questions = await _quizService.GetPracticeQuestionsAsync(slug.Trim().ToLowerInvariant());
        ViewBag.Shape = shape;
        return View(questions);
    }

    [HttpPost("/api/practice/check")]
    public async Task<IActionResult> CheckAnswer([FromBody] PracticeCheckRequest request)
    {
        if (string.IsNullOrWhiteSpace(request?.QuestionId))
        {
            return BadRequest(new { error = "Mã câu hỏi không hợp lệ." });
        }

        var result = await _quizService.CheckPracticeAnswerAsync(request.QuestionId, request.SelectedOptionId);
        return Ok(result);
    }
}
