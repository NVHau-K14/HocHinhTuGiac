using QuadWeb.Repositories;

namespace QuadWeb.Services;

public class ShapeService : IShapeService
{
    private readonly IShapeRepository _shapeRepository;

    public ShapeService(IShapeRepository shapeRepository)
    {
        _shapeRepository = shapeRepository;
    }

    public Task<int> GetShapeCountAsync()
    {
        return _shapeRepository.GetShapeCountAsync();
    }
}
