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

        public GroupController(ApplicationDbContext context,UserService userService)
        {
            _context = context;
            _userService = userService;
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
        public async Task<ActionResult> AddMemberToGroup([FromBody] dynamic jsonData)
        {
            try
            {
                var converter = new ExpandoObjectConverter();
                var conObject = JsonConvert.DeserializeObject<ExpandoObject>(jsonData.ToString(), converter) as dynamic;
                Guid GroupId = new Guid(conObject.groupId);
                Group group = await _context.Groups.FirstOrDefaultAsync(g => g.GroupId == GroupId);
                if (group == null)
                {
                    throw new Exception("Group Does Not Exist");
                }
                Guid UserId = await _userService.CheckIfUserExistsFromJWT();
                Member member = new Member(UserId, GroupId);
                _context.Members.Add(member);
                await _context.SaveChangesAsync();
                return Ok(member);
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

    }
}
