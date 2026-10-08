using QuadWeb.Models;
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

    public Task<List<Shape>> GetAllShapesAsync()
    {
        return _shapeRepository.GetAllShapesAsync();
    }

    public Task<Shape?> GetShapeBySlugAsync(string slug)
    {
        return _shapeRepository.GetShapeBySlugAsync(slug);
    }

    public Task<ShapeDetailViewModel?> GetShapeDetailAsync(string slug)
    {
        return _shapeRepository.GetShapeDetailAsync(slug);
    }
}
