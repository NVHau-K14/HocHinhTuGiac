namespace QuadWeb.Models;

public class CompareViewModel
{
    public ShapeDetailViewModel? Shape1 { get; set; }
    public ShapeDetailViewModel? Shape2 { get; set; }
    public List<PropertyItem> CommonProperties { get; set; } = new();
    public List<PropertyItem> UniqueProperties1 { get; set; } = new();
    public List<PropertyItem> UniqueProperties2 { get; set; } = new();
    public string RelationshipDescription { get; set; } = string.Empty;
    public string LowestCommonAncestorName { get; set; } = string.Empty;
    public List<Shape> AllShapes { get; set; } = new();
}
