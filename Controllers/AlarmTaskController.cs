using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using WeWakeAPI.Data;
using WeWakeAPI.DBServices;
using WeWakeAPI.Models;
using WeWakeAPI.RequestModels;
using WeWakeAPI.ResponseModels;

namespace WeWakeAPI.Controllers
{
    [Route("api/Tasks")]
    [ApiController]
    public class AlarmTaskController : ControllerBase
    {
        private readonly ApplicationDbContext _context;
        private readonly AlarmService _alarmService;
        private readonly AlarmTaskService _alarmTaskService;
        private readonly UserService _userService;
        private readonly GroupService _groupService;
        public AlarmTaskController(ApplicationDbContext applicationDbContext,AlarmService alarmService, AlarmTaskService alarmTaskService, UserService userService,GroupService groupService)
        {
            _context = applicationDbContext;
            _alarmService = alarmService;
            _alarmTaskService = alarmTaskService;
            _userService = userService;
            _groupService = groupService;
        }

        [HttpGet("{alarmId}")]
        public async Task<IActionResult> GetAlarmTasks (Guid alarmId)
        {
            try
            {
                await _alarmService.GetAlarm(alarmId);
                List<AlarmTaskResponse> tasks = await _alarmTaskService.GetTasks(alarmId, _userService.GetUserIdFromJWT());
                return Ok(new { success = true, tasks });


            }catch(Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [HttpPost("Create")]
        public async Task<IActionResult> CreateTask([FromBody] AlarmTaskRequest req)
        {
            try
            {
                Group group =await _groupService.GetGroup(req.GroupId);
                Alarm alarm = await _alarmService.GetAlarm(req.AlarmId);
                Guid userId = _userService.GetUserIdFromJWT();
                if((group.AdminId!=userId) || (alarm.CreatedBy != userId))
                {
                    return Unauthorized("User unauthorized");
                }

                AlarmTaskResponse task = await _alarmTaskService.CreateTask(req.AlarmId,userId, req.TaskText);

                return Ok(new { sucess = true, task });

            }catch(Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [HttpGet("Status/{taskId}")]
        public async Task<IActionResult> UpdateTaskStatus(Guid taskId)
        {
            try
            {
                Guid userId = _userService.GetUserIdFromJWT();

                bool status = await _alarmTaskService.SetTaskStatus(taskId, userId);

                return Ok(new
                {
                    sucess = true,
                    task = new { taskId, status }
                });
            }catch(Exception e)
            {
                return BadRequest(e.Message);
            }
        }


    }
}
