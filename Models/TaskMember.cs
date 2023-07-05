using Microsoft.EntityFrameworkCore.Metadata.Internal;
using System.ComponentModel.DataAnnotations.Schema;

namespace WeWakeAPI.Models
{
    public class TaskMember
    {
        public Guid TaskMemberId { get; set; }
        public Guid AlarmTaskId { get; set; }
        public Guid MemberId { get; set; }
        public bool IsDone { get; set; } = false;

        [ForeignKey("AlarmTaskId")]
        public AlarmTask AlarmTask { get; set; }

        public TaskMember(Guid taskMemberId, Guid taskId, Guid memberId, bool isDone=false)
        {
            TaskMemberId = taskMemberId;
            AlarmTaskId = taskId;
            MemberId = memberId;
            IsDone = isDone;
        }

        public TaskMember(Guid taskId,Guid memberId,bool isDone = false)
        {
            TaskMemberId = Guid.NewGuid();
            AlarmTaskId = taskId;
            MemberId = memberId;
            IsDone = isDone;
        }

        public TaskMember()
        {
            TaskMemberId = Guid.NewGuid();
        }
    }
}
