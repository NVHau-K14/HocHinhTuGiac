using Neo4j.Driver;
using QuadWeb.Models;
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

    public async Task<List<Shape>> GetAllShapesAsync()
    {
        await using var session = _driverService.CreateSession();
        var query = @"
            MATCH (s:Shape)
            RETURN s.id AS id, s.name AS name, s.slug AS slug,
                   s.shortDescription AS shortDescription, s.searchText AS searchText,
                   coalesce(s.sortOrder, 99) AS sortOrder, coalesce(s.family, 'goc') AS family
            ORDER BY sortOrder ASC
        ";
        var cursor = await session.RunAsync(query);
        var list = new List<Shape>();
        while (await cursor.FetchAsync())
        {
            list.Add(new Shape
            {
                Id = cursor.Current["id"].As<string>(),
                Name = cursor.Current["name"].As<string>(),
                Slug = cursor.Current["slug"].As<string>(),
                ShortDescription = cursor.Current["shortDescription"].As<string?>() ?? string.Empty,
                SearchText = cursor.Current["searchText"].As<string?>() ?? string.Empty,
                SortOrder = cursor.Current["sortOrder"].As<int>(),
                Family = cursor.Current["family"].As<string?>() ?? "goc"
            });
        }
        return list;
    }

    public async Task<Shape?> GetShapeBySlugAsync(string slug)
    {
        await using var session = _driverService.CreateSession();
        var query = @"
            MATCH (s:Shape {slug: $slug})
            RETURN s.id AS id, s.name AS name, s.slug AS slug,
                   s.shortDescription AS shortDescription, s.searchText AS searchText,
                   coalesce(s.sortOrder, 99) AS sortOrder, coalesce(s.family, 'goc') AS family
        ";
        var cursor = await session.RunAsync(query, new { slug });
        if (await cursor.FetchAsync())
        {
            return new Shape
            {
                Id = cursor.Current["id"].As<string>(),
                Name = cursor.Current["name"].As<string>(),
                Slug = cursor.Current["slug"].As<string>(),
                ShortDescription = cursor.Current["shortDescription"].As<string?>() ?? string.Empty,
                SearchText = cursor.Current["searchText"].As<string?>() ?? string.Empty,
                SortOrder = cursor.Current["sortOrder"].As<int>(),
                Family = cursor.Current["family"].As<string?>() ?? "goc"
            };
        }
        return null;
    }
}
