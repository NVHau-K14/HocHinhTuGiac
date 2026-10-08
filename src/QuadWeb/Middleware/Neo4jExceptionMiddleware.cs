using Neo4j.Driver;

namespace QuadWeb.Middleware;

public class Neo4jExceptionMiddleware
{
    private readonly RequestDelegate _next;
    private readonly ILogger<Neo4jExceptionMiddleware> _logger;

    public Neo4jExceptionMiddleware(RequestDelegate next, ILogger<Neo4jExceptionMiddleware> logger)
    {
        _next = next;
        _logger = logger;
    }

    public async Task InvokeAsync(HttpContext context)
    {
        try
        {
            await _next(context);
        }
        catch (Exception ex) when (IsNeo4jException(ex))
        {
            _logger.LogError(ex, "Neo4j database connection error on path: {Path}", context.Request.Path);

            if (context.Response.HasStarted)
            {
                throw;
            }

            if (context.Request.Path.StartsWithSegments("/api") || 
                context.Request.Headers.Accept.ToString().Contains("application/json"))
            {
                context.Response.Clear();
                context.Response.StatusCode = StatusCodes.Status503ServiceUnavailable;
                context.Response.ContentType = "application/json; charset=utf-8";
                await context.Response.WriteAsJsonAsync(new
                {
                    success = false,
                    error = "Lỗi kết nối cơ sở dữ liệu",
                    message = "Không thể kết nối cơ sở dữ liệu đồ thị Neo4j. Vui lòng thử lại sau."
                });
                return;
            }

            var returnUrl = context.Request.Path + context.Request.QueryString;
            context.Response.Redirect($"/Home/DatabaseError?retryUrl={Uri.EscapeDataString(returnUrl)}");
        }
    }

    private static bool IsNeo4jException(Exception ex)
    {
        return ex is Neo4jException ||
               ex is TimeoutException ||
               (ex.InnerException != null && IsNeo4jException(ex.InnerException));
    }
}
