using Microsoft.EntityFrameworkCore;
using System.Text.RegularExpressions;
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

    
    }
}
