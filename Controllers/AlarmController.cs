﻿using Microsoft.AspNetCore.Mvc;
using WeWakeAPI.Data;
using WeWakeAPI.DBServices;
using WeWakeAPI.Exceptions;
using WeWakeAPI.Models;
using WeWakeAPI.RequestModels;

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

        public AlarmController(ApplicationDbContext context, AlarmService alarmService, UserService userService, GroupService groupService)
        {
            _context = context;
            _alarmService = alarmService;
            _userService = userService;
            _groupService = groupService;
        }

        [HttpGet("Group/{groupId}")]
        public async Task<ActionResult> GetAlarms(Guid groupId)
        {
            try
            {
                _groupService.CheckIfGroupExists(groupId);
                bool userExists = _groupService.CheckIfMemberAlreadyExists(groupId, await _userService.CheckIfUserExistsFromJWT(),false);
                if (!userExists) throw new UnauthorizedAccessException("User not in group");
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
        public async Task<ActionResult> SetAlarm(AlarmRequest alarm)
        {
            try
            {
                Guid userId = await _userService.CheckIfUserExistsFromJWT();
                Alarm createdAlarm = await _alarmService.CreateAlarm(alarm, userId);
                return Ok(createdAlarm);

            }
            catch (UnauthorizedAccessException e)
            {
                return Unauthorized(e.Message);
            }
            catch (NotFoundException e)
            {
                return NotFound(e.Message);
            }
            catch(BadRequestException e)
            {
                return BadRequest(e.Message);
            }
            catch (Exception e)
            {
                return StatusCode(StatusCodes.Status500InternalServerError,e.Message);
            }
        }
    }
}