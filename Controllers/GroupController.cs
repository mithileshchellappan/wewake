using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using System.Dynamic;
using WeWakeAPI.Data;
using WeWakeAPI.DBServices;
using WeWakeAPI.Models;
using WeWakeAPI.RequestModels;

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

        [HttpPost("AddMember")]
        public async Task<ActionResult> AddMemberToGroup([FromBody] GroupMemberRequest request)
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
        public async Task<ActionResult> RemoveMemberFromGroup([FromBody] GroupMemberRequest req)
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

    }
}
