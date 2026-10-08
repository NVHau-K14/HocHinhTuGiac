using Microsoft.AspNetCore.Mvc;
using QuadWeb.Middleware;
using QuadWeb.Models;
using QuadWeb.Services;

namespace QuadWeb.Controllers;

public class SearchController : Controller
{
    private readonly IShapeService _shapeService;
    private readonly ILearnerService _learnerService;
    private readonly ILogger<SearchController> _logger;

    public SearchController(
        IShapeService shapeService,
        ILearnerService learnerService,
        ILogger<SearchController> logger)
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

    [HttpGet("/search")]
    public async Task<IActionResult> Index([FromQuery] string? q)
    {
        await PopulateLearnerAsync();
        var model = new SearchViewModel
        {
            Query = q?.Trim() ?? string.Empty
        };

        if (!string.IsNullOrWhiteSpace(model.Query))
        {
            model.Results = await _shapeService.SearchAsync(model.Query);
        }

        return View(model);
    }

    [HttpGet("/api/search")]
    public async Task<IActionResult> SearchApi([FromQuery] string? q)
    {
        if (string.IsNullOrWhiteSpace(q))
        {
            return Ok(new List<SearchResultItem>());
        }

        var results = await _shapeService.SearchAsync(q.Trim());
        return Ok(results);
    }
}
