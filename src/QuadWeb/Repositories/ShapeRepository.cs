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

    public async Task<ShapeDetailViewModel?> GetShapeDetailAsync(string slug)
    {
        var shape = await GetShapeBySlugAsync(slug);
        if (shape == null)
        {
            return null;
        }

        var model = new ShapeDetailViewModel { Shape = shape };
        await using var session = _driverService.CreateSession();

        // 1. Định nghĩa (Definitions)
        var defQuery = @"
            MATCH (s:Shape {slug: $slug})-[:HAS_DEFINITION]->(d:Definition)
            RETURN d.id AS id, d.content AS content, d.note AS note
            ORDER BY d.id
        ";
        var defCursor = await session.RunAsync(defQuery, new { slug });
        while (await defCursor.FetchAsync())
        {
            model.Definitions.Add(new DefinitionItem
            {
                Id = defCursor.Current["id"].As<string>(),
                Content = defCursor.Current["content"].As<string>(),
                Note = defCursor.Current["note"].As<string?>()
            });
        }

        // 2. Tính chất trực tiếp và kế thừa qua IS_A*0.. (Khử trùng, kèm nguồn gốc)
        var propQuery = @"
            MATCH (s:Shape {slug: $slug})-[:IS_A*0..]->(a:Shape)-[:HAS_PROPERTY]->(p:Property)
            WITH p, collect(DISTINCT a.name) AS nguon, any(x IN collect(a.slug) WHERE x = $slug) AS isDirect
            RETURN p.id AS id, p.content AS tinhChat, nguon, isDirect
            ORDER BY isDirect DESC, tinhChat ASC
        ";
        var propCursor = await session.RunAsync(propQuery, new { slug });
        while (await propCursor.FetchAsync())
        {
            var sources = propCursor.Current["nguon"].As<List<object>>()
                .Select(o => o.ToString() ?? string.Empty)
                .Where(s => !string.IsNullOrEmpty(s))
                .ToList();

            var isDirect = propCursor.Current["isDirect"].As<bool>();
            var propItem = new PropertyItem
            {
                Id = propCursor.Current["id"].As<string>(),
                Content = propCursor.Current["tinhChat"].As<string>(),
                Sources = sources,
                IsDirect = isDirect
            };

            if (isDirect)
            {
                model.DirectProperties.Add(propItem);
            }
            else
            {
                model.InheritedProperties.Add(propItem);
            }
        }

        // 3. Định lý (Theorems)
        var theoQuery = @"
            MATCH (s:Shape {slug: $slug})-[:HAS_THEOREM]->(t:Theorem)
            RETURN t.id AS id, t.title AS title, t.content AS content
            ORDER BY t.id
        ";
        var theoCursor = await session.RunAsync(theoQuery, new { slug });
        while (await theoCursor.FetchAsync())
        {
            model.Theorems.Add(new TheoremItem
            {
                Id = theoCursor.Current["id"].As<string>(),
                Title = theoCursor.Current["title"].As<string>(),
                Content = theoCursor.Current["content"].As<string>()
            });
        }

        // 4. Dấu hiệu nhận biết (Recognitions)
        var recogQuery = @"
            MATCH (s:Shape {slug: $slug})-[:HAS_RECOGNITION]->(r:Recognition)
            RETURN r.id AS id, r.content AS content
            ORDER BY r.id
        ";
        var recogCursor = await session.RunAsync(recogQuery, new { slug });
        while (await recogCursor.FetchAsync())
        {
            model.Recognitions.Add(new RecognitionItem
            {
                Id = recogCursor.Current["id"].As<string>(),
                Content = recogCursor.Current["content"].As<string>()
            });
        }

        // 5. Công thức (Formulas)
        var formQuery = @"
            MATCH (s:Shape {slug: $slug})-[:HAS_FORMULA]->(f:Formula)
            RETURN f.id AS id, f.name AS name, f.expression AS expression, f.note AS note
            ORDER BY f.id
        ";
        var formCursor = await session.RunAsync(formQuery, new { slug });
        while (await formCursor.FetchAsync())
        {
            model.Formulas.Add(new FormulaItem
            {
                Id = formCursor.Current["id"].As<string>(),
                Name = formCursor.Current["name"].As<string>(),
                Expression = formCursor.Current["expression"].As<string>(),
                Note = formCursor.Current["note"].As<string?>()
            });
        }

        // 6. Ví dụ (Examples)
        var exQuery = @"
            MATCH (s:Shape {slug: $slug})-[:HAS_EXAMPLE]->(e:Example)
            RETURN e.id AS id, e.title AS title, e.content AS content, e.solution AS solution
            ORDER BY e.id
        ";
        var exCursor = await session.RunAsync(exQuery, new { slug });
        while (await exCursor.FetchAsync())
        {
            model.Examples.Add(new ExampleItem
            {
                Id = exCursor.Current["id"].As<string>(),
                Title = exCursor.Current["title"].As<string>(),
                Content = exCursor.Current["content"].As<string>(),
                Solution = exCursor.Current["solution"].As<string>()
            });
        }

        // 7. Hình tổng quát hơn (Parents qua IS_A*1..)
        var parentsQuery = @"
            MATCH (s:Shape {slug: $slug})-[:IS_A*1..]->(a:Shape)
            RETURN DISTINCT a.slug AS slug, a.name AS name
            ORDER BY a.name
        ";
        var parentsCursor = await session.RunAsync(parentsQuery, new { slug });
        while (await parentsCursor.FetchAsync())
        {
            model.Parents.Add(new ShapeRelationItem
            {
                Slug = parentsCursor.Current["slug"].As<string>(),
                Name = parentsCursor.Current["name"].As<string>()
            });
        }

        // 8. Hình đặc biệt hơn (Children qua <-[:IS_A*1..]-)
        var childrenQuery = @"
            MATCH (child:Shape)-[:IS_A*1..]->(s:Shape {slug: $slug})
            RETURN DISTINCT child.slug AS slug, child.name AS name
            ORDER BY child.name
        ";
        var childrenCursor = await session.RunAsync(childrenQuery, new { slug });
        while (await childrenCursor.FetchAsync())
        {
            model.Children.Add(new ShapeRelationItem
            {
                Slug = childrenCursor.Current["slug"].As<string>(),
                Name = childrenCursor.Current["name"].As<string>()
            });
        }

        return model;
    }
}
