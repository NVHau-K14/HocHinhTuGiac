using Microsoft.AspNetCore.Mvc;
using QuadWeb.Middleware;
using QuadWeb.Services;

namespace QuadWeb.Controllers;

public class CompareController : Controller
{
    private readonly IShapeService _shapeService;
    private readonly ILearnerService _learnerService;
    private readonly ILogger<CompareController> _logger;

    public CompareController(
        IShapeService shapeService,
        ILearnerService learnerService,
        ILogger<CompareController> logger)
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

    [HttpGet("/compare")]
    public async Task<IActionResult> Index([FromQuery] string? shape1, [FromQuery] string? shape2)
    {
        await PopulateLearnerAsync();

        // Mặc định so sánh Hình thoi vs Hình chữ nhật nếu chưa chọn
        var s1 = string.IsNullOrWhiteSpace(shape1) ? "hinh-thoi" : shape1.Trim().ToLowerInvariant();
        var s2 = string.IsNullOrWhiteSpace(shape2) ? "hinh-chu-nhat" : shape2.Trim().ToLowerInvariant();

        var model = await _shapeService.CompareShapesAsync(s1, s2);
        ViewBag.Shape1Slug = s1;
        ViewBag.Shape2Slug = s2;

        return View(model);
    }
}
