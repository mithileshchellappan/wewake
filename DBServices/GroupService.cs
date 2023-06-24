using Microsoft.EntityFrameworkCore;
using System.ComponentModel;
using WeWakeAPI.Data;
using WeWakeAPI.Models;
using WeWakeAPI.ResponseModels;

namespace WeWakeAPI.DBServices
{
    public class GroupService
    {
        private readonly ApplicationDbContext _context;

        public GroupService (ApplicationDbContext context)
        {
            _context = context;
        }

        public bool CheckIfMemberAlreadyExists(Guid groupId, Guid memberId, bool throwException = true)
        {
            bool exists = _context.Members.Any(m => m.MemberId == memberId && m.GroupId == groupId);

            if (exists && throwException)
            {
                throw new Exception("User already exists in the group.");
            }

            return exists;
        }


        public async Task<Group> GetGroup(Guid groupId)
        {
            try
            {
                Group group =await _context.Groups.FirstOrDefaultAsync(m => m.GroupId == groupId);
                return group;

            }catch(Exception e)
            {
                throw new Exception(e.Message);

            }
        }

        public bool CheckIfGroupExists(Guid groupId, bool throwException = true)
        {
            bool exists = _context.Groups.Any(g => g.GroupId == groupId);

            if (!exists && throwException)
            {
                throw new Exception("Group does not exist.");
            }

            return exists;
        }


        public async Task<Member> AddMemberToGroup(Guid groupId,Guid memberId)
        {
            try
            {
                Member member = new Member(memberId, groupId);
                _context.Members.Add(member);
                var result = await _context.SaveChangesAsync();
                console.log(result);
                return member;
            }
            catch(Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        public async Task<bool> RemoveMemberFromGroup(Guid groupId,Guid memberId,Guid requesterId)
        {
            try
            {
                Group group = await GetGroup(groupId);
                if (memberId!=requesterId&& group.AdminId!=requesterId)
                {
                    throw new UnauthorizedAccessException("Only Admins can remove other members from group");
                }
                Member removingMember = new Member(memberId, groupId);
                _context.Members.Remove(removingMember);
                await _context.SaveChangesAsync();
                return true;
            }catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<List<GroupMemberResponse>> GetMembers(Guid groupId)
        {
            try
            {
                Group group = await GetGroup(groupId);
                List<GroupMemberResponse> members = await _context.Members
                .Where(m => m.GroupId == groupId)
                .Select(m => new GroupMemberResponse
                {
                    MemberId = m.User.UserId,
                    GroupId = groupId,
                    MemberName = m.User.Name,
                    GroupName = m.Group.GroupName,
                    IsAdmin = m.isAdmin
                })
                .ToListAsync();

                return members;
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }
    
    }
}
