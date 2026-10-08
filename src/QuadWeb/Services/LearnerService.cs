using QuadWeb.Models;
using QuadWeb.Repositories;

namespace QuadWeb.Services;

public class LearnerService : ILearnerService
{
    private readonly ILearnerRepository _learnerRepository;

    public LearnerService(ILearnerRepository learnerRepository)
    {
        _learnerRepository = learnerRepository;
    }

    public Task<Learner> GetOrCreateLearnerAsync(string clientId, string defaultDisplayName = "Người học")
    {
        return _learnerRepository.GetOrCreateLearnerAsync(clientId, defaultDisplayName);
    }

    public Task UpdateDisplayNameAsync(string clientId, string displayName)
    {
        var cleanName = (displayName ?? string.Empty).Trim();
        if (cleanName.Length is < 1 or > 30)
        {
            cleanName = "Người học";
        }
        return _learnerRepository.UpdateDisplayNameAsync(clientId, cleanName);
    }

    public Task<List<LeaderboardEntry>> GetLeaderboardAsync(int top = 10, string? currentClientId = null)
    {
        return _learnerRepository.GetLeaderboardAsync(top, currentClientId);
    }
}
