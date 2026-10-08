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
    public string Label { get; set; } = "IS_A";
}

public class GraphDataDto
{
    public List<GraphNodeDto> Nodes { get; set; } = new();
    public List<GraphEdgeDto> Edges { get; set; } = new();
}
