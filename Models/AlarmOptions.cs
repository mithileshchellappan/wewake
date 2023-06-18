using System.ComponentModel.DataAnnotations;

namespace WeWakeAPI.Models
{
    public class AlarmOptions
    {
        [Key]
        public Guid AlarmOptionsId { get; set; }
        public Guid AlarmId { get; set; }
        public virtual Alarm Alarm { get; set; }
        public bool loopAudio { get; set; }
        public bool vibrate { get; set; }
        public String NotificationTitle { get; set; }
        public String NotificationBody { get; set; }
        public String InternalAudioFile { get; set; }
        public bool UseExternalAudio { get; set; }
        public String AudioURL { get; set; } = null;
    }
}
