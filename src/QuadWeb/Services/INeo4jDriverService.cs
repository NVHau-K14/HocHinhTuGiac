using Neo4j.Driver;

namespace QuadWeb.Services;

public interface INeo4jDriverService : IAsyncDisposable, IDisposable
{
    IDriver Driver { get; }
    string Database { get; }
    IAsyncSession CreateSession();
    Task<bool> PingAsync();
}
