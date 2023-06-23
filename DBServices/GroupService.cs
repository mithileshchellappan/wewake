using Microsoft.EntityFrameworkCore;
using System.ComponentModel;
using WeWakeAPI.Data;
using WeWakeAPI.Models;

namespace WeWakeAPI.DBServices
{
    public class GroupService
    {
        private readonly ApplicationDbContext _context;

        public GroupService (ApplicationDbContext context)
        {
            _context = context;
        }

        public bool CheckIfMemberAlreadyExists(Guid groupId,Guid memberId,bool throwException=true)
        {
            int count = _context.Members.Where(m=>m.MemberId == memberId && m.GroupId == groupId).Count();
            if(count >= 1)
            {
                if (throwException)
                {
                    throw new Exception("User Already Exists in group");
                }
                else
                {
                    return true;
                }
            }
            else
            {
                return false;
            }

        }

        public Group GetGroup(Guid groupId)
        {
            try
            {
                Group group = _context.Groups.FirstOrDefault(m => m.GroupId == groupId);
                return group;

            }catch(Exception e)
            {
                throw new Exception(e.Message);

            }
        }

        public bool CheckIfGroupExists(Guid groupId,bool throwException = true)
        {
            int count = _context.Groups.Where(g => g.GroupId == groupId).Count();
            if (count >= 1)
            {
                return true;
            }
            else
            {
                if (throwException)
                {
                    throw new Exception("Group does not exists");
                }
                else
                {
                    return false;
                }
            }
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
                Group group = GetGroup(groupId);
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

        public async Task<List<User>> GetMembers(Guid groupId)
        {
            try
            {
                Group group = GetGroup(groupId);
                List<User> members = await _context.Members.Where(g => g.GroupId == groupId)
                .Select(m => new User
                {
                    UserId = m.User.UserId,
                    Name = m.User.Name,
                }).ToListAsync();
                return members;
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

    
    }
}
