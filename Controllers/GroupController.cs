using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using System.Dynamic;
using WeWakeAPI.Data;
using WeWakeAPI.Models;
using WeWakeAPI.RequestModels;

namespace WeWakeAPI.Controllers
{
    [Route("api/Group")]
    public class GroupController : ControllerBase
    {
        private readonly ApplicationDbContext _context;

        public GroupController(ApplicationDbContext context)
        {
            _context = context;
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
                Guid UserId = (Guid)HttpContext.Items["UserId"];
                if (UserId == null)
                {
                    return Unauthorized();
                }
                group.AdminId = UserId;
                group.CreatedAt = DateTime.Now;
                var resObj = new
                {
                    GroupId = group.GroupId,
                    GroupName = group.GroupName,
                    AdminId = group.AdminId
                };

                _context.Groups.Add(group);
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
                Guid groupId = new Guid(conObject.groupId);
                Console.WriteLine(groupId);
                Group group = await _context.Groups.FirstOrDefaultAsync(g => g.GroupId == groupId);
                if (group == null)
                {
                    throw new Exception("Group Does Not Exist");
                }
                Guid UserId = (Guid)HttpContext.Items["UserId"];
                User member = await _context.Users.FirstOrDefaultAsync(u => u.UserId == UserId);
                if (member == null)
                {
                    throw new Exception("Member not found");
                }
                //Console.WriteLine("members" + group.Members);
                //group.Members.Add(member);
                await _context.SaveChangesAsync();
                return Ok();
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

    }
}
