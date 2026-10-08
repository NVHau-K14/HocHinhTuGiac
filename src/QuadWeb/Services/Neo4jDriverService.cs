using Microsoft.Extensions.Options;
using Neo4j.Driver;
using QuadWeb.Models;

namespace QuadWeb.Services;

public class Neo4jDriverService : INeo4jDriverService
{
    private readonly Neo4jSettings _settings;
    private readonly ILogger<Neo4jDriverService> _logger;
    private IDriver? _driver;
    private readonly object _lock = new();

    public Neo4jDriverService(IOptions<Neo4jSettings> settingsOptions, ILogger<Neo4jDriverService> logger)
    {
        _settings = settingsOptions.Value;
        _logger = logger;
    }

    public IDriver Driver
    {
        get
        {
            if (_driver == null)
            {
                lock (_lock)
                {
                    _driver ??= InitializeDriver();
                }
            }
            return _driver;
        }
    }

    public string Database => string.IsNullOrWhiteSpace(_settings.Database) ? "neo4j" : _settings.Database;

    private IDriver InitializeDriver()
    {
        IAuthToken authToken;
        if (string.IsNullOrEmpty(_settings.Password))
        {
            // If password is empty, authentication is disabled in Neo4j Desktop
            authToken = AuthTokens.None;
        }
        else
        {
            authToken = AuthTokens.Basic(_settings.Username, _settings.Password);
        }

        try
        {
            _logger.LogInformation("Initializing Neo4j Driver with URI: {Uri}", _settings.Uri);
            return GraphDatabase.Driver(_settings.Uri, authToken, builder =>
            {
                builder.WithMaxConnectionPoolSize(50);
                builder.WithConnectionTimeout(TimeSpan.FromSeconds(5));
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to initialize Neo4j driver");
            throw;
        }
    }

    public IAsyncSession CreateSession()
    {
        return Driver.AsyncSession(o =>
        {
            if (!string.IsNullOrWhiteSpace(_settings.Database))
            {
                o.WithDatabase(_settings.Database);
            }
        });
    }

    public async Task<bool> PingAsync()
    {
        try
        {
            await using var session = CreateSession();
            var cursor = await session.RunAsync("RETURN 1 AS ping");
            if (await cursor.FetchAsync())
            {
                return cursor.Current["ping"].As<int>() == 1;
            }
            return false;
        }
        catch (Exception ex)
        {
            _logger.LogWarning("Neo4j ping failed: {Message}", ex.Message);
            return false;
        }
    }

    public void Dispose()
    {
        _driver?.Dispose();
    }

    public async ValueTask DisposeAsync()
    {
        if (_driver != null)
        {
            await _driver.DisposeAsync();
        }
    }
}
