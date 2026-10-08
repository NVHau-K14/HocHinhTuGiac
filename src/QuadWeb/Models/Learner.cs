namespace QuadWeb.Models;

public class Learner
{
    public string ClientId { get; set; } = string.Empty;
    public string DisplayName { get; set; } = "Người học";
    public DateTime? CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }
}

public class LeaderboardEntry
{
    public int Rank { get; set; }
    public string ClientId { get; set; } = string.Empty;
    public string DisplayName { get; set; } = string.Empty;
    public int MaxScore { get; set; }
    public int TotalAttempts { get; set; }
    public DateTime? LastActive { get; set; }
    public bool IsCurrentLearner { get; set; }
}

