namespace QuadWeb.Models;

public class ShapeSpecItem
{
    public string Slug { get; set; } = string.Empty;
    public string Name { get; set; } = string.Empty;
    public string Family { get; set; } = "goc";
    public string SpecParallel { get; set; } = string.Empty;
    public string SpecSides { get; set; } = string.Empty;
    public string SpecAngles { get; set; } = string.Empty;
    public string SpecDiagonals { get; set; } = string.Empty;
    public string SpecSymmetry { get; set; } = string.Empty;
}

public class ShapeConditionItem
{
    public string FromSlug { get; set; } = string.Empty;
    public string FromName { get; set; } = string.Empty;
    public string ToSlug { get; set; } = string.Empty;
    public string ToName { get; set; } = string.Empty;
    public string Condition { get; set; } = string.Empty;
}

public class CompareViewModel
{
    // Phần 1: Bảng đặc tả 8 hình
    public List<ShapeSpecItem> ShapeSpecs { get; set; } = new();

    // Phần 2: Danh sách 10 điều kiện quan hệ IS_A
    public List<ShapeConditionItem> Conditions { get; set; } = new();

    // Phần 3: So sánh 2 hình
    public ShapeDetailViewModel? Shape1 { get; set; }
    public ShapeDetailViewModel? Shape2 { get; set; }
    public List<PropertyItem> CommonProperties { get; set; } = new();
    public List<PropertyItem> UniqueProperties1 { get; set; } = new();
    public List<PropertyItem> UniqueProperties2 { get; set; } = new();
    public string RelationshipDescription { get; set; } = string.Empty;
    public string LowestCommonAncestorName { get; set; } = string.Empty;
    public List<Shape> AllShapes { get; set; } = new();
    public string? ErrorMessage { get; set; }
}
