namespace QuadWeb.Models;

public class Learner
{
    public string ClientId { get; set; } = string.Empty;
    public string DisplayName { get; set; } = "Người học";
    public DateTime? CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }
}
