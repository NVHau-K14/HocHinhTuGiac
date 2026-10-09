using Microsoft.AspNetCore.Mvc;
using QuadWeb.Middleware;
using QuadWeb.Services;

namespace QuadWeb.Controllers;

public class LabController : Controller
{
    private readonly IShapeService _shapeService;
    private readonly ILearnerService _learnerService;
    private readonly ILogger<LabController> _logger;

    public LabController(
        IShapeService shapeService,
        ILearnerService learnerService,
        ILogger<LabController> logger)
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

    [HttpGet("/lab")]
    public async Task<IActionResult> Index()
    {
        await PopulateLearnerAsync();
        ViewData["Title"] = "Xưởng vẽ hình học tương tác";
        ViewBag.CurrentNav = "lab";
        return View();
    }

    [HttpGet("api/lab/meta")]
    public async Task<IActionResult> GetMeta()
    {
        try
        {
            var meta = await _shapeService.GetLabMetaAsync();
            return Ok(meta);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Lỗi khi lấy dữ liệu metadata Xưởng vẽ từ Neo4j");
            return StatusCode(500, new
            {
                error = "Không tải được dữ liệu hình mẫu từ máy chủ. Vui lòng kiểm tra kết nối cơ sở dữ liệu và thử lại."
            });
        }
    }
}
