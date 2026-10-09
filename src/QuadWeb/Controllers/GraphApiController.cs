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

    [HttpGet("relation")]
    public async Task<IActionResult> GetRelationDetail([FromQuery] string? child, [FromQuery] string? parent)
    {
        if (string.IsNullOrWhiteSpace(child) || string.IsNullOrWhiteSpace(parent))
        {
            return BadRequest(new { error = "Tham số 'child' và 'parent' không được để trống." });
        }

        try
        {
            var data = await _shapeService.GetEdgeRelationDetailAsync(
                child.Trim().ToLowerInvariant(),
                parent.Trim().ToLowerInvariant()
            );

            if (data == null)
            {
                return NotFound(new { error = $"Không tìm thấy quan hệ IS_A trực tiếp giữa '{child}' và '{parent}'." });
            }

            return Ok(data);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Lỗi khi truy vấn thông tin quan hệ giữa {Child} và {Parent}", child, parent);
            return StatusCode(500, new { error = "Không tải được thông tin quan hệ này. Vui lòng thử lại sau." });
        }
    }
}
