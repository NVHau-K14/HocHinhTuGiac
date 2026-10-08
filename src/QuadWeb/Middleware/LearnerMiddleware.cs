namespace QuadWeb.Middleware;

public class LearnerMiddleware
{
    public const string CookieName = "quad_learner_id";
    public const string ItemKey = "ClientId";
    private readonly RequestDelegate _next;

    public LearnerMiddleware(RequestDelegate next)
    {
        _next = next;
    }

    public async Task InvokeAsync(HttpContext context)
    {
        string? clientId = null;
        if (context.Request.Cookies.TryGetValue(CookieName, out var existingCookie) && !string.IsNullOrWhiteSpace(existingCookie))
        {
            clientId = existingCookie.Trim();
        }

        if (string.IsNullOrEmpty(clientId))
        {
            clientId = Guid.NewGuid().ToString("N");
            context.Response.Cookies.Append(CookieName, clientId, new CookieOptions
            {
                HttpOnly = true,
                SameSite = SameSiteMode.Lax,
                Secure = context.Request.IsHttps,
                Expires = DateTimeOffset.UtcNow.AddYears(1),
                IsEssential = true
            });
        }

        context.Items[ItemKey] = clientId;
        await _next(context);
    }
}
