using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations;

namespace WeWakeAPI.Models
{
    public class Member
    {
        [Key]
        public Guid MemberGroupId { get; set; }
        public Guid MemberId { get; set; }
        public Guid GroupId { get; set; }
        public bool isAdmin { get; set; }

        public Member(Guid memberId, Guid groupId, bool isAdmin = false)
        {
            this.MemberGroupId = Guid.NewGuid();
            this.MemberId = memberId;
            this.GroupId = groupId;
            this.isAdmin = isAdmin;
        }
    }
}
