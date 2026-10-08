using Microsoft.AspNetCore.Mvc;
using QuadWeb.Middleware;
using QuadWeb.Models;
using QuadWeb.Services;

namespace QuadWeb.Controllers;

public class UpdateNameRequest
{
    public string DisplayName { get; set; } = string.Empty;
}

public class LeaderboardController : Controller
{
    private readonly ILearnerService _learnerService;
    private readonly ILogger<LeaderboardController> _logger;

    public LeaderboardController(ILearnerService learnerService, ILogger<LeaderboardController> logger)
    {
        _learnerService = learnerService;
        _logger = logger;
    }

    private async Task<Learner> GetCurrentLearnerAsync()
    {
        var clientId = HttpContext.Items[LearnerMiddleware.ItemKey] as string ?? string.Empty;
        var learner = await _learnerService.GetOrCreateLearnerAsync(clientId);
        ViewBag.DisplayName = learner.DisplayName;
        ViewBag.ClientId = learner.ClientId;
        return learner;
    }

    [HttpGet("/leaderboard")]
    public async Task<IActionResult> Index()
    {
        var learner = await GetCurrentLearnerAsync();
        var leaderboard = await _learnerService.GetLeaderboardAsync(10, learner.ClientId);
        return View(leaderboard);
    }

    [HttpPost("/api/learner/name")]
    public async Task<IActionResult> UpdateNameApi([FromBody] UpdateNameRequest request)
    {
        var clientId = HttpContext.Items[LearnerMiddleware.ItemKey] as string;
        if (string.IsNullOrEmpty(clientId))
        {
            return BadRequest(new { error = "Không tìm thấy phiên người học." });
        }

        var newName = (request?.DisplayName ?? string.Empty).Trim();
        if (string.IsNullOrEmpty(newName) || newName.Length > 30)
        {
            return BadRequest(new { error = "Họ tên phải từ 1 đến 30 ký tự." });
        }

        await _learnerService.UpdateDisplayNameAsync(clientId, newName);
        return Ok(new { success = true, displayName = newName });
    }

    [HttpPost("/leaderboard/update-name")]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> UpdateNameForm([FromForm] string displayName)
    {
        var clientId = HttpContext.Items[LearnerMiddleware.ItemKey] as string;
        if (!string.IsNullOrEmpty(clientId) && !string.IsNullOrWhiteSpace(displayName))
        {
            await _learnerService.UpdateDisplayNameAsync(clientId, displayName.Trim());
        }
        return RedirectToAction("Index");
    }
}
