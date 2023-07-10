using System.ComponentModel.DataAnnotations.Schema;

namespace WeWakeAPI.Models
{
    public class OptOut
    {
        public Guid OptOutId { get; set; }
        public Guid AlarmId { get; set; }
        public Guid MemberId { get; set; }
        public bool IsOptOut { get; set; } = false;

        [ForeignKey("AlarmId")]
        public Alarm Alarm { get; set; }


        public OptOut(Guid alarmId,Guid memberId,bool isOptOut) {

            OptOutId = Guid.NewGuid();
            AlarmId = alarmId;
            MemberId = memberId;
            IsOptOut = isOptOut;
            
        }

        public OptOut(Guid optOutId, Guid alarmId, Guid memberId, bool isOptOut)
        {
            OptOutId = optOutId;
            AlarmId = alarmId;
            MemberId = memberId;
            IsOptOut = isOptOut;
        }
    }
}
