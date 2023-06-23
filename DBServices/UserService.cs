using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using WeWakeAPI.Data;
using WeWakeAPI.Models;
using WeWakeAPI.ResponseModels;

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
        
        public async Task<List<GroupMemberResponse>> GetUserGroups()
        {
                Guid userId = GetUserIdFromJWT();
                List<GroupMemberResponse> groups = await _context.Members
                    .Where(m => m.MemberId == userId)
                    .Select(m => new GroupMemberResponse
                    {
                        MemberId = m.User.UserId,
                        GroupId = m.GroupId,
                        MemberName = m.User.Name,
                        IsAdmin = m.isAdmin
                    })
                    .ToListAsync();

                return groups;
           
       }
    }
}
