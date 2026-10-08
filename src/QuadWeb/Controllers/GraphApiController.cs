using Microsoft.AspNetCore.Mvc;
using QuadWeb.Services;

namespace QuadWeb.Controllers;

[ApiController]
[Route("api")]
public class GraphApiController : ControllerBase
{
    private readonly IShapeService _shapeService;
    private readonly ILogger<GraphApiController> _logger;

    public GraphApiController(IShapeService shapeService, ILogger<GraphApiController> logger)
    {
        _shapeService = shapeService;
        _logger = logger;
    }

    [HttpGet("graph")]
    public async Task<IActionResult> GetGraph()
    {
        try
        {
            var data = await _shapeService.GetGraphDataAsync();
            return Ok(data);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error fetching graph data from Neo4j");
            return StatusCode(500, new { error = "Không tải được sơ đồ quan hệ. Vui lòng thử lại sau." });
        }
    }
}
