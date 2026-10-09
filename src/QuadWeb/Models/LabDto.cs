namespace QuadWeb.Models;

public class ShapeMetaDto
{
    public string Slug { get; set; } = string.Empty;
    public string Name { get; set; } = string.Empty;
    public string Family { get; set; } = string.Empty;
    public int SortOrder { get; set; }
}

public class IsaMetaDto
{
    public string Tu { get; set; } = string.Empty;
    public string Den { get; set; } = string.Empty;
    public string? Condition { get; set; }
    public string? ConditionShort { get; set; }
}

public class FormulaMetaDto
{
    public string Slug { get; set; } = string.Empty;
    public string Id { get; set; } = string.Empty;
    public string Name { get; set; } = string.Empty;
    public string Expression { get; set; } = string.Empty;
    public string? Note { get; set; }
}

public class LabMetaResponseDto
{
    public List<ShapeMetaDto> Shapes { get; set; } = new();
    public List<IsaMetaDto> Isa { get; set; } = new();
    public List<FormulaMetaDto> Formulas { get; set; } = new();
}
