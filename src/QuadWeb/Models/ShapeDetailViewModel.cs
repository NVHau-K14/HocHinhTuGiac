namespace QuadWeb.Models;

public class DefinitionItem
{
    public string Id { get; set; } = string.Empty;
    public string Content { get; set; } = string.Empty;
    public string? Note { get; set; }
}

public class PropertyItem
{
    public string Id { get; set; } = string.Empty;
    public string Content { get; set; } = string.Empty;
    public List<string> Sources { get; set; } = new();
    public bool IsDirect { get; set; }
}

public class TheoremItem
{
    public string Id { get; set; } = string.Empty;
    public string Title { get; set; } = string.Empty;
    public string Content { get; set; } = string.Empty;
}

public class RecognitionItem
{
    public string Id { get; set; } = string.Empty;
    public string Content { get; set; } = string.Empty;
}

public class FormulaItem
{
    public string Id { get; set; } = string.Empty;
    public string Name { get; set; } = string.Empty;
    public string Expression { get; set; } = string.Empty;
    public string? Note { get; set; }
}

public class ExampleItem
{
    public string Id { get; set; } = string.Empty;
    public string Title { get; set; } = string.Empty;
    public string Content { get; set; } = string.Empty;
    public string Solution { get; set; } = string.Empty;
}

public class ShapeRelationItem
{
    public string Slug { get; set; } = string.Empty;
    public string Name { get; set; } = string.Empty;
    public string? Condition { get; set; }
}

public class ShapeDetailViewModel
{
    public Shape Shape { get; set; } = new();
    public List<DefinitionItem> Definitions { get; set; } = new();
    public List<PropertyItem> DirectProperties { get; set; } = new();
    public List<PropertyItem> InheritedProperties { get; set; } = new();
    public List<TheoremItem> Theorems { get; set; } = new();
    public List<RecognitionItem> Recognitions { get; set; } = new();
    public List<FormulaItem> Formulas { get; set; } = new();
    public List<ExampleItem> Examples { get; set; } = new();
    public List<ShapeRelationItem> Parents { get; set; } = new();
    public List<ShapeRelationItem> Children { get; set; } = new();
    public bool IsKiteDefinitionNote => Shape.Slug == "hinh-dieu";
}
