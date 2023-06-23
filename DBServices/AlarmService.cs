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

        public AlarmService (ApplicationDbContext context, GroupService groupService)
        {
            _context = context;
            _groupService = groupService;
        }

        public async Task<Alarm> CreateAlarm(AlarmRequest alarmReq, Guid userId)
        {
            Group group = _groupService.GetGroup(alarmReq.GroupId);
            
            if (group == null)
            {
                throw new NotFoundException("Group not found");
            }
            if(alarmReq.Time ==  DateTime.MinValue)
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
                time:alarmReq.Time,
                loopAudio: alarmReq.LoopAudio,
                internalAudioFile: alarmReq.InternalAudioFile,
                useExternalAudio: alarmReq.UseExternalAudio,
                audioURL: alarmReq.AudioUrl,
                vibrate: alarmReq.Vibrate, 
                notificationBody: alarmReq.NotificationBody,
                notificationTitle: alarmReq.NotificationTitle);
            

            return alarm;
        }

    }
}
