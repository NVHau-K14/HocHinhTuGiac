namespace QuadWeb.Models;

public class SearchResultItem
{
    public string Category { get; set; } = string.Empty;
    public string Title { get; set; } = string.Empty;
    public string Snippet { get; set; } = string.Empty;
    public string ShapeName { get; set; } = string.Empty;
    public string ShapeSlug { get; set; } = string.Empty;
}

public class SearchViewModel
{
    public string Query { get; set; } = string.Empty;
    public List<SearchResultItem> Results { get; set; } = new();
    public int TotalCount => Results.Count;
}
