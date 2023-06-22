using WeWakeAPI.Utils;

namespace WeWakeAPI.Middlewares
{
    public class JWTMiddleware
    {
        private readonly RequestDelegate _next;
        private readonly PathString[] _allowedPaths;

        public JWTMiddleware(RequestDelegate next)
        {
            _next = next;
            _allowedPaths = new PathString[]
            {
                new PathString("/api/Login"),
                new PathString("/api/SignUp")
            };
        }

        public async Task InvokeAsync(HttpContext context)
        {
            Console.WriteLine(context.Request.Path);

            if (_allowedPaths.Any(path => path.Equals(context.Request.Path)))
            {
                await _next(context);
                return;
            }

            if (!context.Request.Headers.ContainsKey("Authorization"))
            {
                SetUnauthorizedResponse(context);
                return;
            }

            var bearerToken = context.Request.Headers["Authorization"].ToString().Replace("Bearer ", "");
            var (isValid, UserId, Name) = JWTHasher.ValidateToken(bearerToken);

            if (isValid)
            {
                context.Items["UserId"] = UserId;
                context.Items["Name"] = Name;
                await _next(context);
                return;
            }
            else
            {
                SetUnauthorizedResponse(context);
                return;
            }
        }

        private static void SetUnauthorizedResponse(HttpContext context)
        {
            context.Response.StatusCode = 401;
            context.Response.WriteAsync("Unauthorized");
        }
    }

    public static class JWTMiddlewareExtensions
    {
        public static IApplicationBuilder UseJWTMiddleware(this IApplicationBuilder builder)
        {
            return builder.UseMiddleware<JWTMiddleware>();
        }
    }
}
