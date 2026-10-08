using Neo4j.Driver;
using QuadWeb.Models;
using QuadWeb.Services;

namespace QuadWeb.Repositories;

public class LearnerRepository : ILearnerRepository
{
    private readonly INeo4jDriverService _driverService;
    private readonly ILogger<LearnerRepository> _logger;

    public LearnerRepository(INeo4jDriverService driverService, ILogger<LearnerRepository> logger)
    {
        _driverService = driverService;
        _logger = logger;
    }

    public async Task<Learner> GetOrCreateLearnerAsync(string clientId, string defaultDisplayName = "Người học")
    {
        await using var session = _driverService.CreateSession();
        var query = @"
            MERGE (l:Learner {clientId: $clientId})
            ON CREATE SET l.displayName = $defaultDisplayName,
                          l.createdAt = datetime(),
                          l.updatedAt = datetime()
            RETURN l.clientId AS clientId, l.displayName AS displayName
        ";
        var cursor = await session.RunAsync(query, new { clientId, defaultDisplayName });
        if (await cursor.FetchAsync())
        {
            return new Learner
            {
                ClientId = cursor.Current["clientId"].As<string>(),
                DisplayName = cursor.Current["displayName"].As<string>()
            };
        }

        return new Learner { ClientId = clientId, DisplayName = defaultDisplayName };
    }

    public async Task UpdateDisplayNameAsync(string clientId, string displayName)
    {
        await using var session = _driverService.CreateSession();
        var query = @"
            MERGE (l:Learner {clientId: $clientId})
            SET l.displayName = $displayName,
                l.updatedAt = datetime()
        ";
        await session.RunAsync(query, new { clientId, displayName });
    }

    public async Task<List<LeaderboardEntry>> GetLeaderboardAsync(int top = 10, string? currentClientId = null)
    {
        await using var session = _driverService.CreateSession();
        var query = @"
            MATCH (l:Learner)-[:MADE_ATTEMPT]->(a:QuizAttempt)
            WITH l, count(a) AS totalAttempts, max(a.score) AS maxScore, max(a.submittedAt) AS lastActive
            RETURN l.clientId AS clientId,
                   l.displayName AS displayName,
                   maxScore,
                   totalAttempts,
                   toString(lastActive) AS lastActiveStr
            ORDER BY maxScore DESC, totalAttempts ASC, lastActive DESC
            LIMIT $top
        ";

        var cursor = await session.RunAsync(query, new { top });
        var list = new List<LeaderboardEntry>();
        int rank = 1;

        while (await cursor.FetchAsync())
        {
            var record = cursor.Current;
            var cId = record["clientId"].As<string>();
            var lastActiveStr = record["lastActiveStr"].As<string?>();
            DateTime? lastActive = null;
            if (!string.IsNullOrEmpty(lastActiveStr) && DateTime.TryParse(lastActiveStr, out var parsedDt))
            {
                lastActive = parsedDt;
            }

            list.Add(new LeaderboardEntry
            {
                Rank = rank++,
                ClientId = cId,
                DisplayName = record["displayName"].As<string?>() ?? "Học sinh",
                MaxScore = (int)record["maxScore"].As<long>(),
                TotalAttempts = (int)record["totalAttempts"].As<long>(),
                LastActive = lastActive,
                IsCurrentLearner = !string.IsNullOrEmpty(currentClientId) && cId == currentClientId
            });
        }

        return list;
    }
}
