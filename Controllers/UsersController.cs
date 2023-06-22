using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using WeWakeAPI.Data;
using WeWakeAPI.Models;
using WeWakeAPI.RequestModels;
using WeWakeAPI.Utils;

namespace WeWakeAPI.Controllers
{
    [Route("api/")]
    [ApiController]
    public class UsersController : ControllerBase
    {
        private readonly ApplicationDbContext _context;

        public UsersController(ApplicationDbContext context)
        {
            _context = context;
        }
        [HttpPost("SignUp")]
        public async Task<ActionResult> SignUp(UserRequest userRequest)
        {
            try
            {
                var userExists = await _context.Users.FirstOrDefaultAsync(user => user.Email == userRequest.Email);
                if (userExists != null)
                {
                    throw new Exception("User already exists.");
                }
                if (String.IsNullOrEmpty(userRequest.Name))
                {
                    throw new Exception("Name is required");
                }
                var user = new User();
                user.UserId = Guid.NewGuid();
                user.Name = userRequest.Name;
                user.Email = userRequest.Email;
                user.PasswordHash = PasswordHasher.Hash(userRequest.Password); ;
                _context.Users.Add(user);
                await _context.SaveChangesAsync();
                var jwtToken = JWTHasher.GenerateToken(user);
                var resObj = new
                {
                    jwtToken,
                    Name = user.Name,
                    UserId = user.UserId
                };
                return CreatedAtAction("SignUp", new { UserId = user.UserId }, resObj);
            }catch (Exception e)
            {
                return BadRequest(e.Message);
            }
            
        }

        [HttpPost("Login")]
        public async Task<ActionResult> Login(UserRequest userRequest)
        {
            try
            {
                var existingUser = await _context.Users.FirstOrDefaultAsync(u => u.Email == userRequest.Email);
                if(existingUser == null)
                {
                    return Unauthorized();
                }
                var passwordVerify = PasswordHasher.Verify(userRequest.Password, existingUser.PasswordHash);
                if (!passwordVerify)
                {
                    return Unauthorized();
                }
                var jwtToken = JWTHasher.GenerateToken(existingUser);
                var resObj = new
                {
                    jwtToken,
                    Name = existingUser.Name,
                    UserId = existingUser.UserId
                };
                return Ok(resObj);
            }catch(Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        //// GET: api/Users
        //[HttpGet]
        //public async Task<ActionResult<IEnumerable<User>>> GetUsers()
        //{
        //  if (_context.Users == null)
        //  {
        //      return NotFound();
        //  }
        //    return await _context.Users.ToListAsync();
        //}

        //// GET: api/Users/5
        //[HttpGet("{id}")]
        //public async Task<ActionResult<User>> GetUser(Guid id)
        //{
        //  if (_context.Users == null)
        //  {
        //      return NotFound();
        //  }
        //    var user = await _context.Users.FindAsync(id);

        //    if (user == null)
        //    {
        //        return NotFound();
        //    }

        //    return user;
        //}

        //// PUT: api/Users/5
        //// To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        //[HttpPut("{id}")]
        //public async Task<IActionResult> PutUser(Guid id, User user)
        //{
        //    if (id != user.UserId)
        //    {
        //        return BadRequest();
        //    }

        //    _context.Entry(user).State = EntityState.Modified;

        //    try
        //    {
        //        await _context.SaveChangesAsync();
        //    }
        //    catch (DbUpdateConcurrencyException)
        //    {
        //        if (!UserExists(id))
        //        {
        //            return NotFound();
        //        }
        //        else
        //        {
        //            throw;
        //        }
        //    }

        //    return NoContent();
        //}

        //// POST: api/Users
        //// To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        //[HttpPost]
        //public async Task<ActionResult<User>> PostUser(User user)
        //{
        //  if (_context.Users == null)
        //  {
        //      return Problem("Entity set 'ApplicationDbContext.Users'  is null.");
        //  }
        //    _context.Users.Add(user);
        //    await _context.SaveChangesAsync();

        //    return CreatedAtAction("GetUser", new { id = user.UserId }, user);
        //}

        //// DELETE: api/Users/5
        //[HttpDelete("{id}")]
        //public async Task<IActionResult> DeleteUser(Guid id)
        //{
        //    if (_context.Users == null)
        //    {
        //        return NotFound();
        //    }
        //    var user = await _context.Users.FindAsync(id);
        //    if (user == null)
        //    {
        //        return NotFound();
        //    }

        //    _context.Users.Remove(user);
        //    await _context.SaveChangesAsync();

        //    return NoContent();
        //}

        //private bool UserExists(Guid id)
        //{
        //    return (_context.Users?.Any(e => e.UserId == id)).GetValueOrDefault();
        //}
    }
}
