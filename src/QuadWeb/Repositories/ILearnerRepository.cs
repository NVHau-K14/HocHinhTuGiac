using QuadWeb.Models;

namespace QuadWeb.Repositories;

public interface ILearnerRepository
{
    Task<Learner> GetOrCreateLearnerAsync(string clientId, string defaultDisplayName = "Người học");
    Task UpdateDisplayNameAsync(string clientId, string displayName);
}
