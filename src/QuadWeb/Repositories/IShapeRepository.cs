namespace QuadWeb.Repositories;

public interface IShapeRepository
{
    Task<int> GetShapeCountAsync();
}
