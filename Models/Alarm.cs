using System.ComponentModel.DataAnnotations;

namespace WeWakeAPI.Models
{
    public class Alarm
    {
        [Key]
        public Guid AlarmId { get; set; }
        public Guid GroupId { get; set; }
        public DateTime Time { get; set; }
        public bool IsEnabled { get; set; }

    }
}
