using QuadWeb.Models;

namespace QuadWeb.Services;

public interface ILearnerService
{
    Task<Learner> GetOrCreateLearnerAsync(string clientId, string defaultDisplayName = "Người học");
    Task UpdateDisplayNameAsync(string clientId, string displayName);
}
