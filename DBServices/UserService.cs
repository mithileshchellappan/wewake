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
                .Join(_context.Groups,
                    member => member.GroupId,
                    group => group.GroupId,
                    (member, group) => new
                    {
                        MemberId = member.User.UserId,
                        GroupId = member.GroupId,
                        AdminId = group.AdminId,
                        MemberName = member.User.Name,
                        GroupName = group.GroupName,
                        IsAdmin = member.isAdmin,
                        CreatedAt = group.CreatedAt,
                        CanSetAlarm = group.CanMemberCreateAlarm
                    })
                .GroupJoin(_context.Members,
                    g => g.GroupId,
                    member => member.GroupId,
                    (g, members) => new GroupMemberResponse
                    {
                        MemberId = g.MemberId,
                        GroupId = g.GroupId,
                        AdminId = g.AdminId,
                        MemberName = g.MemberName,
                        GroupName = g.GroupName,
                        IsAdmin = g.IsAdmin,
                        CreatedAt = g.CreatedAt,
                        CanSetAlarm = g.CanSetAlarm,
                        MemberCount = members.Count()
                    })
                .ToListAsync();




            return groups;

        }

        public async Task<dynamic> GetUserAlarms()
        {
            Guid userId = GetUserIdFromJWT();
            var alarms = await (
                from member in _context.Members
                join alarm in _context.Alarms on member.GroupId equals alarm.GroupId
                join grp in _context.Groups on alarm.GroupId equals grp.GroupId
                where member.MemberId == userId
                select new {
                    alarmId = alarm.AlarmId,
                    groupId=alarm.GroupId,
                    createdBy=alarm.CreatedBy,
                    alarmAppId = alarm.AlarmAppId,
                    time=alarm.Time,
                    isEnabled=alarm.IsEnabled,
                    loopAudio=alarm.LoopAudio,
                    vibrate=alarm.Vibrate,
                    notificationTitle=alarm.NotificationTitle,
                    notificationBody=alarm.NotificationBody,
                    internalAudioFile=alarm.InternalAudioFile,
                    useExternalAudio=alarm.UseExternalAudio,
                    audioURL=alarm.AudioURL,
                    groupName=grp.GroupName
                }
                ).ToListAsync();
            
            

            return alarms;
        }
    }
}
