using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using QuadWeb.Middleware;
using QuadWeb.Models;
using QuadWeb.Services;

namespace QuadWeb.Controllers;

public class HomeController : Controller
{
    private readonly IShapeService _shapeService;
    private readonly ILearnerService _learnerService;
    private readonly ILogger<HomeController> _logger;

    public HomeController(
        IShapeService shapeService,
        ILearnerService learnerService,
        ILogger<HomeController> logger)
    {
        _shapeService = shapeService;
        _learnerService = learnerService;
        _logger = logger;
    }

    public async Task<IActionResult> Index()
    {
        var clientId = HttpContext.Items[LearnerMiddleware.ItemKey] as string ?? string.Empty;
        var learner = await _learnerService.GetOrCreateLearnerAsync(clientId);
        ViewBag.DisplayName = learner.DisplayName;

        var shapeCount = await _shapeService.GetShapeCountAsync();
        ViewBag.ShapeCount = shapeCount;

        return View();
    }

    [HttpGet]
    public IActionResult DatabaseError(string? retryUrl)
    {
        var model = new ErrorViewModel
        {
            Title = "Không thể kết nối cơ sở dữ liệu Neo4j",
            Message = "Hệ thống tạm thời không thể kết nối tới cơ sở dữ liệu đồ thị Neo4j. Vui lòng đảm bảo DBMS trong Neo4j Desktop đang ở trạng thái 'Started' và thử lại.",
            RetryUrl = string.IsNullOrWhiteSpace(retryUrl) ? "/" : retryUrl
        };
        return View("Error", model);
    }

    [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
    public IActionResult Error()
    {
        return View(new ErrorViewModel
        {
            RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier,
            Title = "Đã có sự cố xảy ra",
            Message = "Có lỗi ngoài dự kiến trong quá trình xử lý yêu cầu. Vui lòng thử lại sau.",
            RetryUrl = "/"
        });
    }
}
