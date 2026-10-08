using QuadWeb.Models;

namespace QuadWeb.Services;

public interface IShapeService
{
    Task<int> GetShapeCountAsync();
    Task<List<Shape>> GetAllShapesAsync();
    Task<Shape?> GetShapeBySlugAsync(string slug);
    Task<ShapeDetailViewModel?> GetShapeDetailAsync(string slug);
    Task<GraphDataDto> GetGraphDataAsync();
}
