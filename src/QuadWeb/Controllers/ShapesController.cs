using Microsoft.AspNetCore.Mvc;
using QuadWeb.Middleware;
using QuadWeb.Models;
using QuadWeb.Services;

namespace QuadWeb.Controllers;

public class ShapesController : Controller
{
    private readonly IShapeService _shapeService;
    private readonly ILearnerService _learnerService;
    private readonly ILogger<ShapesController> _logger;

    public ShapesController(
        IShapeService shapeService,
        ILearnerService learnerService,
        ILogger<ShapesController> logger)
    {
        _shapeService = shapeService;
        _learnerService = learnerService;
        _logger = logger;
    }

    private async Task PopulateLearnerAsync()
    {
        var clientId = HttpContext.Items[LearnerMiddleware.ItemKey] as string ?? string.Empty;
        var learner = await _learnerService.GetOrCreateLearnerAsync(clientId);
        ViewBag.DisplayName = learner.DisplayName;
    }

    [HttpGet("/shapes")]
    public async Task<IActionResult> Index()
    {
        await PopulateLearnerAsync();
        var shapes = await _shapeService.GetAllShapesAsync();
        return View(shapes);
    }

    [HttpGet("/shape/{slug}")]
    [HttpGet("/shapes/{slug}")]
    public async Task<IActionResult> Detail(string slug)
    {
        await PopulateLearnerAsync();
        if (string.IsNullOrWhiteSpace(slug))
        {
            return NotFoundView("Tên đường dẫn hình không hợp lệ.");
        }

        var model = await _shapeService.GetShapeDetailAsync(slug.Trim().ToLowerInvariant());
        if (model == null)
        {
            return NotFoundView($"Không tìm thấy loại hình tứ giác có định danh '{slug}'.");
        }

        return View(model);
    }

    private IActionResult NotFoundView(string message)
    {
        Response.StatusCode = 404;
        var errorModel = new ErrorViewModel
        {
            Title = "404 - Không tìm thấy nội dung bài học",
            Message = message,
            RetryUrl = "/shapes"
        };
        return View("NotFound", errorModel);
    }
}
