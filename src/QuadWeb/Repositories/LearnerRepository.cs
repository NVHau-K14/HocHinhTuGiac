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
}
