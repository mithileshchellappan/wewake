using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using WeWakeAPI.Data;
using WeWakeAPI.DBServices;

namespace WeWakeAPI.Controllers
{
    [Route("api/Tasks")]
    [ApiController]
    public class AlarmTasksController : ControllerBase
    {
        private readonly ApplicationDbContext _context;
        private readonly AlarmService _alarmService;
        public AlarmTasksController(ApplicationDbContext applicationDbContext,AlarmService alarmService)
        {
            _context = applicationDbContext;
            _alarmService = alarmService;
        }

        [HttpGet("{alarmId]")]
        public async Task<IActionResult> GetAlarmTasks (Guid alarmId)
        {
            try
            {
                _alarmService.GetAlarm(alarmId);


            }catch(Exception e)
            {
                return BadRequest(e.Message);
            }
        }


    }
}
