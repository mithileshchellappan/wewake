﻿using Microsoft.EntityFrameworkCore;
using System.ComponentModel;
using WeWakeAPI.Data;
using WeWakeAPI.Models;
using WeWakeAPI.ResponseModels;

namespace WeWakeAPI.DBServices
{
    public class GroupService
    {
        private readonly ApplicationDbContext _context;

        public GroupService(ApplicationDbContext context)
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
                Group group = await _context.Groups.FirstOrDefaultAsync(m => m.GroupId == groupId);
                return group;

            }
            catch (Exception e)
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

        public async Task<int> GetGroupMemberCount(Guid groupId)
        {
            int count = await _context.Members.CountAsync(m => m.GroupId == groupId);
            return count;
        }

        public async Task<GroupMemberResponse> GetGroupMemberObject(Guid groupId, Guid userId)
        {
            GroupMemberResponse? group = await _context.Members
            .Where(m => m.MemberId == userId && m.GroupId == groupId)
            .Join(_context.Groups,
                member => member.GroupId,
                group => group.GroupId,
                (member, group) => new
                {
                    MemberId = member.User.UserId,
                    GroupId = member.GroupId,
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
                    MemberName = g.MemberName,
                    GroupName = g.GroupName,
                    IsAdmin = g.IsAdmin,
                    CreatedAt = g.CreatedAt,
                    CanSetAlarm = g.CanSetAlarm,
                    MemberCount = members.Count()
                })
                .FirstOrDefaultAsync();
            if (group == null)
            {
                throw new Exception("Group Not Found");
            }
            return group;

        }


        public async Task<Member> AddMemberToGroup(Guid groupId, Guid memberId)
        {
            try
            {
                CheckIfMemberAlreadyExists(groupId, memberId);
                Member member = new Member(memberId, groupId);
                _context.Members.Add(member);
                var result = await _context.SaveChangesAsync();
                console.log(result);
                return member;
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        public async Task<bool> RemoveMemberFromGroup(Guid groupId, Guid memberId, Guid requesterId)
        {
            try
            {
                Group group = await GetGroup(groupId);
                if (memberId != requesterId && group.AdminId != requesterId)
                {
                    throw new UnauthorizedAccessException("Only Admins can remove other members from group");
                }
                Member removingMember = new Member(memberId, groupId);
                _context.Members.Remove(removingMember);
                await _context.SaveChangesAsync();
                return true;
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<List<GroupMemberListResponse>> GetMembers(Guid groupId)
        {
            try
            {
                Group group = await GetGroup(groupId);
                List<GroupMemberListResponse> members = await _context.Members
                .Where(m => m.GroupId == groupId)
                .Select(m => new GroupMemberListResponse
                {
                    MemberId = m.User.UserId,
                    MemberName = m.User.Name,
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

        public async Task<Guid> CreateInviteLink(Guid groupId, Guid inviterId)
        {
            try
            {
                Group group = await GetGroup(groupId);
                if (group.AdminId != inviterId) throw new Exception("Only Admin can create or get invite link");
                InviteLink alreadyExistingId = await _context.InviteLinks.FirstOrDefaultAsync(t=>t.GroupId==groupId);
                if(alreadyExistingId!=null){
                    return alreadyExistingId.InviteLinkId;
                }
                InviteLink invite = new InviteLink(groupId, inviterId);
                _context.InviteLinks.Add(invite);
                await _context.SaveChangesAsync();
                return invite.InviteLinkId;

            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

    }
}
