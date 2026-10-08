namespace QuadWeb.Models;

public class Shape
{
    public string Id { get; set; } = string.Empty;
    public string Name { get; set; } = string.Empty;
    public string Slug { get; set; } = string.Empty;
    public string ShortDescription { get; set; } = string.Empty;
    public string SearchText { get; set; } = string.Empty;
    public int SortOrder { get; set; }
    public string Family { get; set; } = "goc";
}
