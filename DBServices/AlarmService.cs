using Microsoft.EntityFrameworkCore;
using WeWakeAPI.Data;
using WeWakeAPI.Exceptions;
using WeWakeAPI.Models;
using WeWakeAPI.RequestModels;

namespace WeWakeAPI.DBServices
{
    public class AlarmService
    {
        private readonly ApplicationDbContext _context;
        private readonly GroupService _groupService;

        public AlarmService(ApplicationDbContext context, GroupService groupService)
        {
            _context = context;
            _groupService = groupService;
        }

        public async Task<Alarm> GetAlarm(Guid alarmId,bool throwException=true)
        {
              Alarm alarm =  await _context.Alarms.FirstAsync(x => x.AlarmId == alarmId);
            if(alarm==null && throwException)
            {
                throw new NotFoundException("Alarm not found");
            }
            return alarm;
        }

        public async Task<Alarm> CreateAlarm(AlarmRequest alarmReq, Guid userId)
        {
            try
            {
                Group group = await _groupService.GetGroup(alarmReq.GroupId);

                if (group == null)
                {
                    throw new NotFoundException("Group not found");
                }
                if (alarmReq.Time == DateTime.MinValue)
                {
                    throw new BadRequestException("Provide time when creating an alarm!");
                }
                console.log(group.CanMemberCreateAlarm + "here");
                if (!group.CanMemberCreateAlarm && group.AdminId != userId)
                {
                    throw new UnauthorizedAccessException("Unauthorized to create alarm in this group");
                }
                alarmReq.NotificationTitle ??= $"Alarm | {group.GroupName}";
                alarmReq.NotificationBody ??= $"Alarm from WeWake Group {group.GroupName}";
                console.log(alarmReq.IsEnabled);
                Alarm alarm = new Alarm(alarmReq.GroupId,
                    createdBy: userId,
                    isEnabled: alarmReq.IsEnabled,
                    time: alarmReq.Time,
                    loopAudio: alarmReq.LoopAudio,
                    internalAudioFile: alarmReq.InternalAudioFile,
                    useExternalAudio: alarmReq.UseExternalAudio,
                    audioURL: alarmReq.AudioUrl,
                    vibrate: alarmReq.Vibrate,
                    notificationBody: alarmReq.NotificationBody,
                    notificationTitle: alarmReq.NotificationTitle);
                OptOut optOut = new OptOut(alarm.AlarmId, alarm.CreatedBy, false);
                await _context.OptOuts.AddAsync(optOut);
                await _context.Alarms.AddAsync(alarm);
                await _context.SaveChangesAsync();
                return alarm;
            }
            catch (Exception e)
            {
                throw new Exception($"Exception: {e.Message}");
            }
        }

        public async Task<bool> DeleteAlarm(Guid alarmId, Guid userId)
        {
            Alarm alarm = await GetAlarm(alarmId);
            if (alarm.CreatedBy != userId)
            {
                throw new UnauthorizedAccessException("Only members who created the alarm can delete it.");
            }
            _context.Alarms.Remove(alarm);
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<List<Alarm>> GetAlarms(Guid groupId)
        {
            try
            {
                List<Alarm> alarms = await _context.Alarms.Where(g => g.GroupId == groupId).ToListAsync();
                return alarms;
            }
            catch (Exception e)
            {
                throw new Exception("Error in getting alarms");
            }

        }

        public async Task<bool> UpdateOptOut(Guid alarmId,Guid memberId,bool isOptOut)
        {
            try
            {
                OptOut optOut = await _context.OptOuts.FirstAsync(g=>g.AlarmId == alarmId && g.MemberId == memberId);
                if(optOut == null)
                {
                    optOut = new OptOut(alarmId, memberId,isOptOut);
                    _context.OptOuts.Add(optOut);
                    await _context.SaveChangesAsync();
                    return true;
                }
                else
                {
                    optOut.IsOptOut = isOptOut;
                    _context.OptOuts.Update(optOut);
                    await _context.SaveChangesAsync();
                    return true;
                }

            }catch(Exception e)
            {

                throw new Exception(e.Message);
            }
        }

    }
}
