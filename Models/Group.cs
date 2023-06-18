using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace WeWakeAPI.Models
{
    public class Group
    {
        [Key]
        public Guid GroupId { get; set; }
        public string GroupName { get; set; }
        public Guid AdminId { get; set; }
        public DateTime CreatedAt { get; set; }
        public virtual ICollection<User> Members { get; set; }
    }
}