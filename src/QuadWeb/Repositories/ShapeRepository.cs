using Neo4j.Driver;
using QuadWeb.Services;

namespace QuadWeb.Repositories;

public class ShapeRepository : IShapeRepository
{
    private readonly INeo4jDriverService _driverService;
    private readonly ILogger<ShapeRepository> _logger;

    public ShapeRepository(INeo4jDriverService driverService, ILogger<ShapeRepository> logger)
    {
        _driverService = driverService;
        _logger = logger;
    }

    public async Task<int> GetShapeCountAsync()
    {
        await using var session = _driverService.CreateSession();
        var cursor = await session.RunAsync("MATCH (s:Shape) RETURN count(s) AS total");
        if (await cursor.FetchAsync())
        {
            return cursor.Current["total"].As<int>();
        }
        return 0;
    }
}
