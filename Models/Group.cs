using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace WeWakeAPI.Models
{
    public class Group
    {
        //public Group() {
        //    Members = new HashSet<User>();
        //}

        [Key]
        public Guid GroupId { get; set; }
        public string GroupName { get; set; }
        public Guid AdminId { get; set; }
        public DateTime CreatedAt { get; set; }
        public bool CanMemberCreateAlarm { get; set; } = false;
    }
}