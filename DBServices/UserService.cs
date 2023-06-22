using Microsoft.EntityFrameworkCore;
using WeWakeAPI.Data;
using WeWakeAPI.Models;

namespace WeWakeAPI.DBServices
{
    public class UserService
    {
        private readonly ApplicationDbContext _context;
        private readonly IHttpContextAccessor _httpContextAccessor;

        public UserService(ApplicationDbContext context, IHttpContextAccessor httpContextAccessor)
        {
            _context = context;
            _httpContextAccessor = httpContextAccessor;
        }

        private HttpContext HttpContext => _httpContextAccessor.HttpContext;

        public Guid GetUserIdFromJWT()
        {
            Guid? userId = (Guid?)HttpContext.Items["UserId"];
            if (userId == null)
            {
                throw new UnauthorizedAccessException("User ID not found");
            }
            return userId.Value;
        }

        public Task<bool> CheckIfUserExists(Guid userId)
        {
            return _context.Users.AnyAsync(u => u.UserId == userId);
        }

        public async Task<Guid> CheckIfUserExistsFromJWT()
        {
            Guid guid = GetUserIdFromJWT();
            if (await CheckIfUserExists(guid))
            {
                return guid;
            }
            else
            {
                throw new Exception("User doesn't exist");
            }
        }
    }
}
