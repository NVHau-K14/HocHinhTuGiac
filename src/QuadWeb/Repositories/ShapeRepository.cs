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

        // 7. Hình cha trực tiếp kèm điều kiện (Truy vấn C)
        var parentsQuery = @"
            MATCH (s:Shape {slug: $slug})-[r:IS_A]->(cha:Shape)
            RETURN cha.slug AS slug, cha.name AS name, r.condition AS dieuKien
            ORDER BY cha.sortOrder
        ";
        var parentsCursor = await session.RunAsync(parentsQuery, new { slug });
        while (await parentsCursor.FetchAsync())
        {
            model.Parents.Add(new ShapeRelationItem
            {
                Slug = parentsCursor.Current["slug"].As<string>(),
                Name = parentsCursor.Current["name"].As<string>(),
                Condition = parentsCursor.Current["dieuKien"].As<string?>()
            });
        }

        // 8. Hình con trực tiếp kèm điều kiện (Truy vấn D)
        var childrenQuery = @"
            MATCH (con:Shape)-[r:IS_A]->(s:Shape {slug: $slug})
            RETURN con.slug AS slug, con.name AS name, r.condition AS dieuKien
            ORDER BY con.sortOrder
        ";
        var childrenCursor = await session.RunAsync(childrenQuery, new { slug });
        while (await childrenCursor.FetchAsync())
        {
            model.Children.Add(new ShapeRelationItem
            {
                Slug = childrenCursor.Current["slug"].As<string>(),
                Name = childrenCursor.Current["name"].As<string>(),
                Condition = childrenCursor.Current["dieuKien"].As<string?>()
            });
        }

        return model;
    }

    public async Task<GraphDataDto> GetGraphDataAsync()
    {
        var result = new GraphDataDto();
        await using var session = _driverService.CreateSession();

        // 1. Lấy tất cả nodes Shape
        var nodesQuery = @"
            MATCH (s:Shape)
            RETURN s.slug AS slug, s.name AS name, coalesce(s.family, 'goc') AS family
            ORDER BY s.sortOrder
        ";
        var nodesCursor = await session.RunAsync(nodesQuery);
        while (await nodesCursor.FetchAsync())
        {
            var slug = nodesCursor.Current["slug"].As<string>();
            var name = nodesCursor.Current["name"].As<string>();
            var family = nodesCursor.Current["family"].As<string>();

            int level = slug switch
            {
                "tu-giac" => 0,
                "hinh-thang" => 1,
                "hinh-dieu" => 1,
                "hinh-thang-can" => 2,
                "hinh-binh-hanh" => 2,
                "hinh-chu-nhat" => 3,
                "hinh-thoi" => 3,
                "hinh-vuong" => 4,
                _ => 2
            };

            string color = family switch
            {
                "thang" => "#E6DDF5",
                "binh-hanh" => "#D8F0E4",
                "dieu" => "#FBE0E8",
                _ => "#FAFCFD"
            };

            result.Nodes.Add(new GraphNodeDto
            {
                Id = slug,
                Slug = slug,
                Label = name,
                Family = family,
                Level = level,
                Color = color
            });
        }

        // 2. Lấy 10 cạnh IS_A (Mục 5.1 PROMPT_SUA_SO_DO_v2_3)
        var edgesQuery = @"
            MATCH (a:Shape)-[r:IS_A]->(b:Shape)
            RETURN a.slug AS tu, a.name AS tenTu, b.slug AS den, b.name AS tenDen,
                   r.condition AS dieuKien, r.conditionShort AS dieuKienNgan
            ORDER BY a.sortOrder, b.sortOrder;
        ";
        var edgesCursor = await session.RunAsync(edgesQuery);
        while (await edgesCursor.FetchAsync())
        {
            var cond = edgesCursor.Current["dieuKien"].As<string?>();
            var condShort = edgesCursor.Current["dieuKienNgan"].As<string?>();
            var effectiveCondShort = !string.IsNullOrWhiteSpace(condShort) ? condShort : cond;

            result.Edges.Add(new GraphEdgeDto
            {
                From = edgesCursor.Current["tu"].As<string>(),
                To = edgesCursor.Current["den"].As<string>(),
                FromName = edgesCursor.Current["tenTu"].As<string>(),
                ToName = edgesCursor.Current["tenDen"].As<string>(),
                Condition = cond,
                ConditionShort = condShort,
                Label = !string.IsNullOrWhiteSpace(effectiveCondShort) ? $"+ {effectiveCondShort}" : string.Empty
            });
        }

        return result;
    }

    public async Task<List<SearchResultItem>> SearchAsync(string query)
    {
        var list = new List<SearchResultItem>();
        if (string.IsNullOrWhiteSpace(query))
        {
            return list;
        }

        var q = query.Trim();
        await using var session = _driverService.CreateSession();

        // 1. Tìm trong Shape
        var shapeQuery = @"
            MATCH (s:Shape)
            WHERE toLower(s.name) CONTAINS toLower($q)
               OR toLower(s.searchText) CONTAINS toLower($q)
               OR toLower(s.shortDescription) CONTAINS toLower($q)
            RETURN s.name AS title, s.shortDescription AS snippet, s.name AS shapeName, s.slug AS shapeSlug
            ORDER BY s.sortOrder
        ";
        var shapeCursor = await session.RunAsync(shapeQuery, new { q });
        while (await shapeCursor.FetchAsync())
        {
            list.Add(new SearchResultItem
            {
                Category = "Hình học",
                Title = shapeCursor.Current["title"].As<string>(),
                Snippet = shapeCursor.Current["snippet"].As<string>(),
                ShapeName = shapeCursor.Current["shapeName"].As<string>(),
                ShapeSlug = shapeCursor.Current["shapeSlug"].As<string>()
            });
        }

        // 2. Tìm trong Property
        var propQuery = @"
            MATCH (s:Shape)-[:HAS_PROPERTY]->(p:Property)
            WHERE toLower(p.content) CONTAINS toLower($q)
            RETURN DISTINCT p.content AS title, p.content AS snippet, s.name AS shapeName, s.slug AS shapeSlug
        ";
        var propCursor = await session.RunAsync(propQuery, new { q });
        while (await propCursor.FetchAsync())
        {
            list.Add(new SearchResultItem
            {
                Category = "Tính chất",
                Title = propCursor.Current["title"].As<string>(),
                Snippet = propCursor.Current["snippet"].As<string>(),
                ShapeName = propCursor.Current["shapeName"].As<string>(),
                ShapeSlug = propCursor.Current["shapeSlug"].As<string>()
            });
        }

        // 3. Tìm trong Definition
        var defQuery = @"
            MATCH (s:Shape)-[:DEFINED_AS]->(d:Definition)
            WHERE toLower(d.content) CONTAINS toLower($q)
            RETURN d.content AS title, d.content AS snippet, s.name AS shapeName, s.slug AS shapeSlug
        ";
        var defCursor = await session.RunAsync(defQuery, new { q });
        while (await defCursor.FetchAsync())
        {
            list.Add(new SearchResultItem
            {
                Category = "Định nghĩa",
                Title = defCursor.Current["title"].As<string>(),
                Snippet = defCursor.Current["snippet"].As<string>(),
                ShapeName = defCursor.Current["shapeName"].As<string>(),
                ShapeSlug = defCursor.Current["shapeSlug"].As<string>()
            });
        }

        // 4. Tìm trong Recognition
        var recQuery = @"
            MATCH (s:Shape)-[:RECOGNIZED_BY]->(r:Recognition)
            WHERE toLower(r.content) CONTAINS toLower($q)
            RETURN r.content AS title, r.content AS snippet, s.name AS shapeName, s.slug AS shapeSlug
        ";
        var recCursor = await session.RunAsync(recQuery, new { q });
        while (await recCursor.FetchAsync())
        {
            list.Add(new SearchResultItem
            {
                Category = "Dấu hiệu nhận biết",
                Title = recCursor.Current["title"].As<string>(),
                Snippet = recCursor.Current["snippet"].As<string>(),
                ShapeName = recCursor.Current["shapeName"].As<string>(),
                ShapeSlug = recCursor.Current["shapeSlug"].As<string>()
            });
        }

        // 5. Tìm trong Theorem
        var theoQuery = @"
            MATCH (s:Shape)-[:HAS_THEOREM]->(t:Theorem)
            WHERE toLower(t.title) CONTAINS toLower($q) OR toLower(t.content) CONTAINS toLower($q)
            RETURN t.title AS title, t.content AS snippet, s.name AS shapeName, s.slug AS shapeSlug
        ";
        var theoCursor = await session.RunAsync(theoQuery, new { q });
        while (await theoCursor.FetchAsync())
        {
            list.Add(new SearchResultItem
            {
                Category = "Định lý",
                Title = theoCursor.Current["title"].As<string>(),
                Snippet = theoCursor.Current["snippet"].As<string>(),
                ShapeName = theoCursor.Current["shapeName"].As<string>(),
                ShapeSlug = theoCursor.Current["shapeSlug"].As<string>()
            });
        }

        // 6. Tìm trong Formula
        var formQuery = @"
            MATCH (s:Shape)-[:HAS_FORMULA]->(f:Formula)
            WHERE toLower(f.name) CONTAINS toLower($q) OR toLower(f.expression) CONTAINS toLower($q)
            RETURN f.name AS title, f.expression AS snippet, s.name AS shapeName, s.slug AS shapeSlug
        ";
        var formCursor = await session.RunAsync(formQuery, new { q });
        while (await formCursor.FetchAsync())
        {
            list.Add(new SearchResultItem
            {
                Category = "Công thức",
                Title = formCursor.Current["title"].As<string>(),
                Snippet = formCursor.Current["snippet"].As<string>(),
                ShapeName = formCursor.Current["shapeName"].As<string>(),
                ShapeSlug = formCursor.Current["shapeSlug"].As<string>()
            });
        }

        return list;
    }

    public async Task<CompareViewModel> CompareShapesAsync(string slug1, string slug2)
    {
        var result = new CompareViewModel();
        result.AllShapes = await GetAllShapesAsync();
        result.ShapeSpecs = await GetShapeSpecsAsync();
        result.Conditions = await GetShapeConditionsAsync();

        if (string.IsNullOrWhiteSpace(slug1) || string.IsNullOrWhiteSpace(slug2))
        {
            return result;
        }

        var s1 = slug1.Trim().ToLowerInvariant();
        var s2 = slug2.Trim().ToLowerInvariant();

        result.Shape1 = await GetShapeDetailAsync(s1);
        result.Shape2 = await GetShapeDetailAsync(s2);

        if (result.Shape1 == null || result.Shape2 == null)
        {
            return result;
        }

        // Gộp toàn bộ tính chất của mỗi hình (trực tiếp + kế thừa)
        var allProps1 = result.Shape1.DirectProperties.Concat(result.Shape1.InheritedProperties).ToList();
        var allProps2 = result.Shape2.DirectProperties.Concat(result.Shape2.InheritedProperties).ToList();

        var propIds1 = allProps1.Select(p => p.Id).ToHashSet();
        var propIds2 = allProps2.Select(p => p.Id).ToHashSet();

        // 1. Tính chất chung
        result.CommonProperties = allProps1.Where(p => propIds2.Contains(p.Id))
                                           .GroupBy(p => p.Id)
                                           .Select(g => g.First())
                                           .ToList();

        // 2. Tính chất riêng
        result.UniqueProperties1 = allProps1.Where(p => !propIds2.Contains(p.Id))
                                            .GroupBy(p => p.Id)
                                            .Select(g => g.First())
                                            .ToList();

        result.UniqueProperties2 = allProps2.Where(p => !propIds1.Contains(p.Id))
                                            .GroupBy(p => p.Id)
                                            .Select(g => g.First())
                                            .ToList();

        // 3. Quan hệ phả hệ qua Cypher
        await using var session = _driverService.CreateSession();

        // Kiểm tra s1 kế thừa s2
        var relQuery = @"
            MATCH path1 = (a:Shape {slug: $s1})-[:IS_A*1..5]->(b:Shape {slug: $s2})
            RETURN count(path1) > 0 AS s1IsChildOfS2
        ";
        var relCursor1 = await session.RunAsync(relQuery, new { s1, s2 });
        bool s1IsChildOfS2 = false;
        if (await relCursor1.FetchAsync())
        {
            s1IsChildOfS2 = relCursor1.Current["s1IsChildOfS2"].As<bool>();
        }

        // Kiểm tra s2 kế thừa s1
        var relQuery2 = @"
            MATCH path2 = (b:Shape {slug: $s2})-[:IS_A*1..5]->(a:Shape {slug: $s1})
            RETURN count(path2) > 0 AS s2IsChildOfS1
        ";
        var relCursor2 = await session.RunAsync(relQuery2, new { s1, s2 });
        bool s2IsChildOfS1 = false;
        if (await relCursor2.FetchAsync())
        {
            s2IsChildOfS1 = relCursor2.Current["s2IsChildOfS1"].As<bool>();
        }

        if (s1 == s2)
        {
            result.RelationshipDescription = $"Đây là cùng một hình ({result.Shape1.Shape.Name}).";
            result.LowestCommonAncestorName = result.Shape1.Shape.Name;
        }
        else if (s1IsChildOfS2)
        {
            result.RelationshipDescription = $"{result.Shape1.Shape.Name} là trường hợp đặc biệt của {result.Shape2.Shape.Name}. {result.Shape1.Shape.Name} kế thừa toàn bộ tính chất của {result.Shape2.Shape.Name} và bổ sung thêm các tính chất riêng biệt.";
            result.LowestCommonAncestorName = result.Shape2.Shape.Name;
        }
        else if (s2IsChildOfS1)
        {
            result.RelationshipDescription = $"{result.Shape2.Shape.Name} là trường hợp đặc biệt của {result.Shape1.Shape.Name}. {result.Shape2.Shape.Name} kế thừa toàn bộ tính chất của {result.Shape1.Shape.Name} và bổ sung thêm các tính chất riêng biệt.";
            result.LowestCommonAncestorName = result.Shape1.Shape.Name;
        }
        else
        {
            // Tìm tổ tiên chung gần nhất
            var lcaQuery = @"
                MATCH (a:Shape {slug: $s1})-[:IS_A*0..5]->(common:Shape)<-[:IS_A*0..5]-(b:Shape {slug: $s2})
                RETURN common.name AS commonName, common.sortOrder AS sortOrder
                ORDER BY sortOrder DESC
                LIMIT 1
            ";
            var lcaCursor = await session.RunAsync(lcaQuery, new { s1, s2 });
            string commonName = "Tứ giác";
            if (await lcaCursor.FetchAsync())
            {
                commonName = lcaCursor.Current["commonName"].As<string>();
            }

            result.LowestCommonAncestorName = commonName;
            result.RelationshipDescription = $"{result.Shape1.Shape.Name} và {result.Shape2.Shape.Name} là hai nhánh phân cấp khác nhau, cùng có tổ tiên chung gần nhất là \"{commonName}\". Cả hai hình cùng sở hữu các tính chất nền tảng của {commonName}.";
        }

        return result;
    }

    public async Task<List<ShapeSpecItem>> GetShapeSpecsAsync()
    {
        var list = new List<ShapeSpecItem>();
        await using var session = _driverService.CreateSession();
        var query = @"
            MATCH (s:Shape)
            RETURN s.slug AS slug, s.name AS name, coalesce(s.family, 'goc') AS family,
                   coalesce(s.specParallel, 'Không bắt buộc') AS specParallel,
                   coalesce(s.specSides, 'Không bắt buộc') AS specSides,
                   coalesce(s.specAngles, 'Không bắt buộc') AS specAngles,
                   coalesce(s.specDiagonals, 'Không bắt buộc') AS specDiagonals,
                   coalesce(s.specSymmetry, 'Không bắt buộc') AS specSymmetry
            ORDER BY s.sortOrder;
        ";
        var cursor = await session.RunAsync(query);
        while (await cursor.FetchAsync())
        {
            list.Add(new ShapeSpecItem
            {
                Slug = cursor.Current["slug"].As<string>(),
                Name = cursor.Current["name"].As<string>(),
                Family = cursor.Current["family"].As<string>(),
                SpecParallel = cursor.Current["specParallel"].As<string>(),
                SpecSides = cursor.Current["specSides"].As<string>(),
                SpecAngles = cursor.Current["specAngles"].As<string>(),
                SpecDiagonals = cursor.Current["specDiagonals"].As<string>(),
                SpecSymmetry = cursor.Current["specSymmetry"].As<string>()
            });
        }
        return list;
    }

    public async Task<List<ShapeConditionItem>> GetShapeConditionsAsync()
    {
        var list = new List<ShapeConditionItem>();
        await using var session = _driverService.CreateSession();
        var query = @"
            MATCH (a:Shape)-[r:IS_A]->(b:Shape)
            RETURN a.slug AS tu, a.name AS tenTu, b.slug AS den, b.name AS tenDen, coalesce(r.condition, '') AS dieuKien
            ORDER BY a.sortOrder, b.sortOrder;
        ";
        var cursor = await session.RunAsync(query);
        while (await cursor.FetchAsync())
        {
            list.Add(new ShapeConditionItem
            {
                FromSlug = cursor.Current["tu"].As<string>(),
                FromName = cursor.Current["tenTu"].As<string>(),
                ToSlug = cursor.Current["den"].As<string>(),
                ToName = cursor.Current["tenDen"].As<string>(),
                Condition = cursor.Current["dieuKien"].As<string>()
            });
        }
        return list;
    }

    public async Task<EdgeRelationDetailDto?> GetEdgeRelationDetailAsync(string childSlug, string parentSlug)
    {
        await using var session = _driverService.CreateSession();

        // 1. Truy vấn thông tin cạnh, điều kiện, lý do và định nghĩa 2 hình (Mục 5.2 - Truy vấn 4.1)
        var relQuery = @"
            MATCH (c:Shape {slug: $child})-[r:IS_A]->(p:Shape {slug: $parent})
            OPTIONAL MATCH (c)-[:HAS_DEFINITION]->(dc:Definition)
            OPTIONAL MATCH (p)-[:HAS_DEFINITION]->(dp:Definition)
            RETURN c.name AS hinhCon, p.name AS hinhCha, c.slug AS slugCon, p.slug AS slugCha,
                   r.condition AS dieuKien, r.conditionShort AS dieuKienNgan,
                   r.reason AS lyDo, dc.content AS dinhNghiaCon, dp.content AS dinhNghiaCha;
        ";
        var relCursor = await session.RunAsync(relQuery, new { child = childSlug, parent = parentSlug });
        if (!await relCursor.FetchAsync())
        {
            return null;
        }

        var detail = new EdgeRelationDetailDto
        {
            ChildName = relCursor.Current["hinhCon"].As<string>(),
            ParentName = relCursor.Current["hinhCha"].As<string>(),
            ChildSlug = relCursor.Current["slugCon"].As<string>(),
            ParentSlug = relCursor.Current["slugCha"].As<string>(),
            Condition = relCursor.Current["dieuKien"].As<string?>(),
            ConditionShort = relCursor.Current["dieuKienNgan"].As<string?>(),
            Reason = relCursor.Current["lyDo"].As<string?>(),
            ChildDefinition = relCursor.Current["dinhNghiaCon"].As<string?>(),
            ParentDefinition = relCursor.Current["dinhNghiaCha"].As<string?>()
        };

        // 2. Truy vấn tính chất thừa hưởng qua cạnh này (Mục 5.2 - Truy vấn 4.3)
        var propQuery = @"
            MATCH (:Shape {slug: $child})-[:IS_A]->(p:Shape {slug: $parent})
            MATCH (p)-[:IS_A*0..]->(a:Shape)-[:HAS_PROPERTY]->(x:Property)
            RETURN DISTINCT x.id AS id, x.content AS noiDung, a.name AS nguon
            ORDER BY nguon, noiDung;
        ";
        var propCursor = await session.RunAsync(propQuery, new { child = childSlug, parent = parentSlug });
        while (await propCursor.FetchAsync())
        {
            detail.InheritedProperties.Add(new InheritedPropertyItemDto
            {
                Id = propCursor.Current["id"].As<string>(),
                Content = propCursor.Current["noiDung"].As<string>(),
                Source = propCursor.Current["nguon"].As<string>()
            });
        }

        return detail;
    }
}
