using System.ComponentModel.DataAnnotations;

namespace WeWakeAPI.Models
{
    public class Alarm
    {
        [Key]
        public Guid AlarmId { get; set; }
        public Guid GroupId { get; set; }
        public DateTime Time { get; set; }
        public bool IsEnabled { get; set; } = false;
        public bool loopAudio { get; set; } = false;
        public bool vibrate { get; set; } = false;
        public String NotificationTitle { get; set; }
        public String NotificationBody { get; set; }
        public String InternalAudioFile { get; set; } = "nokia.mp3";
        public bool UseExternalAudio { get; set; } = false;
        public String? AudioURL { get; set; } = null;

        public Alarm(Guid alarmId, Guid groupId, DateTime time, bool isEnabled, bool loopAudio, bool vibrate, string notificationTitle, string notificationBody, string internalAudioFile, bool useExternalAudio, string audioURL)
        {
            AlarmId = alarmId;
            GroupId = groupId;
            Time = time;
            IsEnabled = isEnabled;
            this.loopAudio = loopAudio;
            this.vibrate = vibrate;
            NotificationTitle = notificationTitle;
            NotificationBody = notificationBody;
            InternalAudioFile = internalAudioFile;
            UseExternalAudio = useExternalAudio;
            AudioURL = audioURL;
        }
    }
}
