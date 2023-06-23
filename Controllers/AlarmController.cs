using Microsoft.AspNetCore.Mvc;
using WeWakeAPI.Data;
using WeWakeAPI.DBServices;
using WeWakeAPI.Models;

namespace WeWakeAPI.Controllers
{
    [Route("api/Alarm")]
    [ApiController]
    public class AlarmController : ControllerBase
    {
        private readonly ApplicationDbContext _context;
        private readonly AlarmService _alarmService;
        private readonly UserService _userService;

        public AlarmController(ApplicationDbContext context, AlarmService alarmService, UserService userService)
        {
            _context = context;
            _alarmService = alarmService;
            _userService = userService;
        }

        [HttpPost("Create")]
        public async Task<ActionResult> SetAlarm(Alarm alarm)
        {
            Guid userId = await _userService.CheckIfUserExistsFromJWT();
            Alarm createdAlarm = await _alarmService.CreateAlarm(alarm, userId);
            return Ok(createdAlarm);
        }
    }
}
