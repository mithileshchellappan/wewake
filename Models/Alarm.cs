using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace WeWakeAPI.Models
{
    public class Alarm
    {
        [Key]
        public Guid AlarmId { get; set; }
        [Required]
        public Guid GroupId { get; set; }
        public Guid CreatedBy { get; set; }
        public DateTime Time { get; set; }
        public bool IsEnabled { get; set; } = true;
        public bool LoopAudio { get; set; } = false;
        public bool Vibrate { get; set; } = false;
        public String NotificationTitle { get; set; }
        public String NotificationBody { get; set; }
        public String InternalAudioFile { get; set; } = "nokia.mp3";
        public bool UseExternalAudio { get; set; } = false;
        public String? AudioURL { get; set; } = null;

        [ForeignKey("GroupId")]
        public Group Group { get; set; }

        public Alarm(Guid groupId,Guid createdBy, DateTime time, bool isEnabled, bool loopAudio, bool vibrate, string notificationTitle, string notificationBody, string internalAudioFile, bool useExternalAudio, string audioURL)
        {
            AlarmId = Guid.NewGuid(); 
            GroupId = groupId;
            CreatedBy = createdBy;
            Time = time;
            IsEnabled = isEnabled;
            LoopAudio = loopAudio;
            Vibrate = vibrate;
            NotificationTitle = notificationTitle;
            NotificationBody = notificationBody;
            InternalAudioFile = internalAudioFile;
            UseExternalAudio = useExternalAudio;
            AudioURL = audioURL;
        }
    }
}
