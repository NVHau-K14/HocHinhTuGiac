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

    public Task<GraphDataDto> GetGraphDataAsync()
    {
        return _shapeRepository.GetGraphDataAsync();
    }

    public Task<List<SearchResultItem>> SearchAsync(string query)
    {
        return _shapeRepository.SearchAsync(query);
    }

    public Task<CompareViewModel> CompareShapesAsync(string slug1, string slug2)
    {
        return _shapeRepository.CompareShapesAsync(slug1, slug2);
    }

    public Task<List<ShapeSpecItem>> GetShapeSpecsAsync()
    {
        return _shapeRepository.GetShapeSpecsAsync();
    }

    public Task<List<ShapeConditionItem>> GetShapeConditionsAsync()
    {
        return _shapeRepository.GetShapeConditionsAsync();
    }

    public Task<EdgeRelationDetailDto?> GetEdgeRelationDetailAsync(string childSlug, string parentSlug)
    {
        return _shapeRepository.GetEdgeRelationDetailAsync(childSlug, parentSlug);
    }

    public Task<LabMetaResponseDto> GetLabMetaAsync()
    {
        return _shapeRepository.GetLabMetaAsync();
    }
}
