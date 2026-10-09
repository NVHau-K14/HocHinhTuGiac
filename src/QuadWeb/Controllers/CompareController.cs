using Microsoft.AspNetCore.Mvc;
using QuadWeb.Middleware;
using QuadWeb.Models;
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
    public async Task<IActionResult> Index(
        [FromQuery] string? a,
        [FromQuery] string? b,
        [FromQuery] string? shape1,
        [FromQuery] string? shape2)
    {
        await PopulateLearnerAsync();

        // Hỗ trợ cả param a,b và shape1,shape2
        var slugA = (a ?? shape1)?.Trim().ToLowerInvariant();
        var slugB = (b ?? shape2)?.Trim().ToLowerInvariant();

        // Mặc định chọn Hình chữ nhật vs Hình thoi nếu cả hai đều chưa truyền
        if (string.IsNullOrEmpty(slugA) && string.IsNullOrEmpty(slugB))
        {
            slugA = "hinh-chu-nhat";
            slugB = "hinh-thoi";
        }
        else if (string.IsNullOrEmpty(slugA))
        {
            slugA = "hinh-chu-nhat";
        }
        else if (string.IsNullOrEmpty(slugB))
        {
            slugB = "hinh-thoi";
        }

        ViewBag.SlugA = slugA;
        ViewBag.SlugB = slugB;

        var allShapes = await _shapeService.GetAllShapesAsync();
        var shapeSpecs = await _shapeService.GetShapeSpecsAsync();
        var conditions = await _shapeService.GetShapeConditionsAsync();

        var model = new CompareViewModel
        {
            AllShapes = allShapes,
            ShapeSpecs = shapeSpecs,
            Conditions = conditions
        };

        // Kiểm tra chọn cùng một hình
        if (slugA == slugB)
        {
            model.ErrorMessage = "Vui lòng chọn hai hình khác nhau để so sánh điểm tương đồng và khác biệt.";
            return View(model);
        }

        // Kiểm tra tồn tại
        var shape1Exists = allShapes.Any(s => s.Slug == slugA);
        var shape2Exists = allShapes.Any(s => s.Slug == slugB);

        if (!shape1Exists || !shape2Exists)
        {
            model.ErrorMessage = "Hình được chọn không tồn tại trong hệ thống. Vui lòng chọn lại.";
            return View(model);
        }

        // Thực hiện so sánh
        var compareResult = await _shapeService.CompareShapesAsync(slugA!, slugB!);
        model.Shape1 = compareResult.Shape1;
        model.Shape2 = compareResult.Shape2;
        model.CommonProperties = compareResult.CommonProperties;
        model.UniqueProperties1 = compareResult.UniqueProperties1;
        model.UniqueProperties2 = compareResult.UniqueProperties2;
        model.RelationshipDescription = compareResult.RelationshipDescription;
        model.LowestCommonAncestorName = compareResult.LowestCommonAncestorName;

        return View(model);
    }
}
