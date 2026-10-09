namespace QuadWeb.Models;

public class GraphNodeDto
{
    public string Id { get; set; } = string.Empty;
    public string Label { get; set; } = string.Empty;
    public string Slug { get; set; } = string.Empty;
    public string Family { get; set; } = "goc";
    public int Level { get; set; }
    public string Color { get; set; } = "#FAFCFD";
}

public class GraphEdgeDto
{
    public string From { get; set; } = string.Empty;
    public string To { get; set; } = string.Empty;
    public string Label { get; set; } = string.Empty;
    public string? Condition { get; set; }
    public string? ConditionShort { get; set; }
    public string? FromName { get; set; }
    public string? ToName { get; set; }
}

public class GraphDataDto
{
    public List<GraphNodeDto> Nodes { get; set; } = new();
    public List<GraphEdgeDto> Edges { get; set; } = new();
}

public class InheritedPropertyItemDto
{
    public string Id { get; set; } = string.Empty;
    public string Content { get; set; } = string.Empty;
    public string Source { get; set; } = string.Empty;
}

public class EdgeRelationDetailDto
{
    public string ChildName { get; set; } = string.Empty;
    public string ParentName { get; set; } = string.Empty;
    public string ChildSlug { get; set; } = string.Empty;
    public string ParentSlug { get; set; } = string.Empty;
    public string? Condition { get; set; }
    public string? ConditionShort { get; set; }
    public string? Reason { get; set; }
    public string? ChildDefinition { get; set; }
    public string? ParentDefinition { get; set; }
    public List<InheritedPropertyItemDto> InheritedProperties { get; set; } = new();
}
