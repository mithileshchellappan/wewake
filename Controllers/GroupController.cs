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
                _context.Groups.Add(group);
                Member member = new Member(Guid.NewGuid(),UserId, group.GroupId, true);
                _context.Members.Add(member);
                await _context.SaveChangesAsync();
                var resGroup = group.AppendKey("memberCount",1);
                return Ok(new {success=true,group = resGroup});
            }
            catch (Exception e)
            {
                console.log(e);
                return BadRequest(e);
            }
        }
        

        [HttpGet("{groupId}")]
        public async Task<ActionResult> GetGroup (Guid groupId){
            try
            {
                GroupMemberResponse group = await _groupService.GetGroupMemberObject(groupId, _userService.GetUserIdFromJWT());
                return Ok(new { success = true, group}) ;
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

        [HttpDelete("Delete/{groupId}")]
        public async Task<ActionResult> DeleteGroup(Guid groupId){
            try{
                Guid userId = await _userService.CheckIfUserExistsFromJWT();
                bool success = await _groupService.DeleteGroup(groupId,userId);
                return Ok(new {success});

            }catch (Exception e){
                return BadRequest(e.Message);
            }
        }

        [HttpPost("AddMember")]
        public async Task<ActionResult> AddMember([FromBody] GroupMemberRequest request)
        {
            try
            {
                Guid GroupId = Guid.Parse(request.GroupId);
                Guid MemberId = Guid.Parse(request.MemberId);
                 _groupService.CheckIfGroupExists(GroupId);
                Member member = await _groupService.AddMemberToGroup(GroupId,MemberId);
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
                List<GroupMemberListResponse> members = await _groupService.GetMembers(GroupId);
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
                Guid UserId = _userService.GetUserIdFromJWT();
                await _groupService.AddMemberToGroup(link.GroupId,UserId );
                GroupMemberResponse res = await _groupService.GetGroupMemberObject(link.GroupId,UserId);

                return Ok(new { success = true,group = res });

            }catch(Exception e)
            {
                return BadRequest(e.Message);
            }
        }

    }
}
