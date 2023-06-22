using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
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
    }
}
