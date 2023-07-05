using System.ComponentModel.DataAnnotations.Schema;

namespace WeWakeAPI.Models
{
    public class AlarmTask
    {
        public Guid AlarmTaskId { get; set; }
        public Guid AlarmId { get; set; }
        public string TaskText { get; set; }

        [ForeignKey("AlarmId")]
        public Alarm Alarm { get; set; }

        public AlarmTask(Guid alarmTaskId, Guid alarmId, string taskText)
        {
            AlarmTaskId = alarmTaskId;
            AlarmId = alarmId;
            TaskText = taskText;
        }

        public AlarmTask(Guid alarmId,string taskText)
        {
            AlarmTaskId = Guid.NewGuid();
            AlarmId = alarmId;
            TaskText = taskText;
        }
    }
}
