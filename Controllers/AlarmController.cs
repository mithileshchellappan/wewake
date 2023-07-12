using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using System.Text.RegularExpressions;
using WeWakeAPI.Data;
using WeWakeAPI.DBServices;
using WeWakeAPI.Exceptions;
using WeWakeAPI.Models;
using WeWakeAPI.RequestModels;
using WeWakeAPI.Services;

namespace WeWakeAPI.Controllers
{
    [Route("api/Alarm")]
    [ApiController]
    public class AlarmController : ControllerBase
    {
        private readonly ApplicationDbContext _context;
        private readonly AlarmService _alarmService;
        private readonly UserService _userService;
        private readonly GroupService _groupService;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly IRedisService _redisService;

        public AlarmController(ApplicationDbContext context, AlarmService alarmService, UserService userService, GroupService groupService, IHttpContextAccessor httpContextAccessor,IRedisService redisService)
        {
            _context = context;
            _alarmService = alarmService;
            _userService = userService;
            _groupService = groupService;
            _httpContextAccessor = httpContextAccessor;
            _redisService = redisService;
        }

        private HttpContext _httpContext => _httpContextAccessor.HttpContext;


        [HttpGet("Group/{groupId}")]
        public async Task<ActionResult> GetAlarms(Guid groupId)
        {
            try
            {
                _groupService.CheckIfGroupExists(groupId);
                Member userExists = await _groupService.CheckIfMemberAlreadyExists(groupId, await _userService.CheckIfUserExistsFromJWT(), false);
                if (userExists == null) throw new UnauthorizedAccessException("User not in group");
                List<Alarm> alarms = await _alarmService.GetAlarms(groupId);
                return Ok(new { success = true, alarms });

            }
            catch (UnauthorizedAccessException e)
            {
                return Unauthorized(e.Message);
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [HttpPost("Create")]
        public async Task<ActionResult> SetAlarm([FromBody] AlarmRequest alarm)
        {
            try
            {
                // console.log(alarm["groupId"]+alarm["time"]+alarm["isEnabled"]+alarm["loopAudio"]+alarm["vibrate"]+alarm["notificationTitle"]+alarm["notificationBody"]+alarm["internalAudioFile"]+alarm["useExternalAudio"]+alarm["audioUrl"]);
                // AlarmRequest ar = new(Guid.Parse(alarm["groupId"]), DateTime.Parse(alarm["time"]), alarm["isEnabled"], alarm["loopAudio"], alarm["vibrate"], alarm["notificationTitle"], alarm["notificationBody"], alarm["internalAudioFile"], alarm["useExternalAudio"], alarm["audioUrl"]);
                Guid userId = await _userService.CheckIfUserExistsFromJWT();
                Alarm createdAlarm = await _alarmService.CreateAlarm(alarm, userId);
                var sendAlarm =new {
                    alarmId = createdAlarm.AlarmId,
                    groupId= createdAlarm.GroupId,
                    createdBy=createdAlarm.CreatedBy,
                    canMemberCreateAlarm = createdAlarm.Group.CanMemberCreateAlarm,
                    alarmAppId = createdAlarm.AlarmAppId,
                    time= createdAlarm.Time,
                    isEnabled= createdAlarm.IsEnabled,
                    loopAudio= createdAlarm.LoopAudio,
                    vibrate= createdAlarm.Vibrate,
                    notificationTitle= createdAlarm.NotificationTitle,
                    notificationBody= createdAlarm.NotificationBody,
                    internalAudioFile= createdAlarm.InternalAudioFile,
                    useExternalAudio= createdAlarm.UseExternalAudio,
                    audioURL= createdAlarm.AudioURL,
                    groupName= createdAlarm.Group.GroupName,
                };
                _redisService.PublishToGroup(createdAlarm.GroupId.ToString(), JsonConvert.SerializeObject(new { action = "create", alarm = sendAlarm }));
                return Ok(new { success = true, alarm = createdAlarm });

            }
            catch (UnauthorizedAccessException e)
            {
                console.log(e);
                return Unauthorized(e.Message);
            }
            catch (NotFoundException e)
            {
                console.log(e);
                return NotFound(e.Message);
            }
            catch (BadRequestException e)
            {
                console.log(e);
                return BadRequest(e.Message);
            }
            catch (Exception e)
            {
                console.log(e);

                return StatusCode(StatusCodes.Status500InternalServerError, e.Message);
            }
        }

        [HttpDelete("Delete/{alarmId}")]
        public async Task<ActionResult> DeleteAlarm(Guid alarmId)
        {
            try
            {
                Guid userId = await _userService.CheckIfUserExistsFromJWT();
                bool success = await _alarmService.DeleteAlarm(alarmId, userId);
                return Ok(new { success });
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }

        }

        [HttpGet("OptOut/{alarmId}")]
        public async Task<ActionResult> OptOut(Guid alarmId)
        {
            try
            {
                bool optOutValue = Boolean.Parse(_httpContext.Request.Query["optOut"].ToString());
                Guid userId = _userService.GetUserIdFromJWT();

                bool success = await _alarmService.UpdateOptOut(alarmId,userId, optOutValue);
                if (success)
                {
                    return Ok(new {success});
                }
                else
                {
                    return StatusCode(StatusCodes.Status500InternalServerError);
                }


            }catch(Exception e)
            {
                return BadRequest(e.Message);
            }
        }


    }
}
