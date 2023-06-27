using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using System.Dynamic;
using WeWakeAPI.Data;
using WeWakeAPI.DBServices;
using WeWakeAPI.Models;
using WeWakeAPI.RequestModels;
using WeWakeAPI.ResponseModels;

namespace WeWakeAPI.Controllers
{
    [Route("api/Group")]
    public class GroupController : ControllerBase
    {
        private readonly ApplicationDbContext _context;
        private readonly UserService _userService;
        private readonly GroupService _groupService;

        public GroupController(ApplicationDbContext context,UserService userService,GroupService groupService)
        {
            _context = context;
            _userService = userService;
            _groupService = groupService;
        }

        //GET: api/Group
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Group>>> GetGroups()
        {
            
            if (_context.Groups == null)
            {
                return NotFound();
            }
            return await _context.Groups.ToListAsync();
        }

        [HttpPost("Create")]
        public async Task<ActionResult> AddGroup([FromBody] GroupRequest gr) 
        {
            try
            {
                Console.WriteLine(gr.GroupName);
                var group = new Group();
                group.GroupId = Guid.NewGuid();
                group.GroupName = gr.GroupName;
                Guid UserId = _userService.GetUserIdFromJWT();
                group.AdminId = UserId;
                group.CreatedAt = DateTime.Now;
                var resObj = new
                {
                    GroupId = group.GroupId,
                    GroupName = group.GroupName,
                    AdminId = group.AdminId
                };

                _context.Groups.Add(group);
                Member member = new Member(UserId, group.GroupId, true);
                _context.Members.Add(member);
                await _context.SaveChangesAsync();

                return Ok(resObj);
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [HttpPut("Update/{groupId}")]
        public async Task<ActionResult> UpdateGroup(Guid groupId, [FromBody] GroupRequest groupRequest)
        {
            try
            {
                Group group = await _groupService.GetGroup(groupId);
                if (group == null)
                {
                   return NotFound("Group does not exist");
                }
                if(group.AdminId != _userService.GetUserIdFromJWT())
                {
                    return Unauthorized("User is not group admin");
                }
                console.log(groupRequest.GroupName);
                group.CanMemberCreateAlarm = groupRequest?.CanMemberCreateAlarm ?? group.CanMemberCreateAlarm;
                group.GroupName = groupRequest?.GroupName ?? group.GroupName;
                group.AdminId = groupRequest.AdminId ?? group.AdminId;

                _context.Groups.Update(group);
                await _context.SaveChangesAsync();

                return Ok(new { success=true, group });

            }catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [HttpPost("AddMember")]
        public async Task<ActionResult> AddMember([FromBody] GroupMemberRequest request)
        {
            try
            {
                Guid GroupId = new(request.GroupId);
                 _groupService.CheckIfGroupExists(GroupId);
                Guid UserId = await _userService.CheckIfUserExistsFromJWT();
                 _groupService.CheckIfMemberAlreadyExists(GroupId, UserId);
                Member member = await _groupService.AddMemberToGroup(GroupId, UserId);
                return Ok(new {success=true,member});
            }
            catch (Exception e)
            {
                return BadRequest(new {success=false,error=e.Message});
            }
        }
        [HttpPost("RemoveMember")]
        public async Task<ActionResult> RemoveMember([FromBody] GroupMemberRequest req)
        {
            try
            {
                console.log(req.MemberId);
                Guid GroupId = Guid.Parse(req.GroupId);
                Guid MemberId = Guid.Parse(req.MemberId);
                Guid UserId = _userService.GetUserIdFromJWT();

                await _groupService.RemoveMemberFromGroup(GroupId, MemberId,UserId);
                return Ok(new {success=true,message="Member removed successfully"});

            }
            catch(UnauthorizedAccessException e)
            {
                return Unauthorized(e.Message);
            }
            catch(Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [HttpGet("Members/{groupId}")]
        public async Task<IActionResult> GetMembers(string groupId)
        {
            try
            {
                Guid GroupId = Guid.Parse(groupId);
                List<GroupMemberResponse> members = await _groupService.GetMembers(GroupId);
                return Ok(new { success = true, members });


            }catch(Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [HttpGet("GetInviteLink/{groupId}")]
        public async Task<IActionResult> GetInviteLink(string groupId)
        {
            try
            {
                Guid GroupId = Guid.Parse(groupId);
                Guid userId = _userService.GetUserIdFromJWT();
                Guid inviteId = await _groupService.CreateInviteLink(GroupId, userId);
                return Ok(new {success=true,inviteId});

            }catch(Exception e)
            {
                console.log(e);
                return NotFound(e.Message);
            }
        }

        [HttpGet("Join/{inviteId}")]
        public async Task<IActionResult> JoinFromInviteId(string inviteId)
        {
            try
            {
                Guid InviteId = Guid.Parse(inviteId);
                InviteLink link = await _context.InviteLinks.FirstOrDefaultAsync(i=>i.InviteLinkId == InviteId);
                if (link==null)
                {
                    return NotFound("Invite Link Invalid");
                }

                await _groupService.AddMemberToGroup(link.GroupId, _userService.GetUserIdFromJWT());

                return Ok(new { success = true });

            }catch(Exception e)
            {
                return BadRequest(e.Message);
            }
        }

    }
}
