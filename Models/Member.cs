using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace WeWakeAPI.Models
{
    public class Member
    {
        [Key]
        public Guid MemberGroupId { get; set; }
        public Guid MemberId { get; set; }
        public Guid GroupId { get; set; }
        public bool isAdmin { get; set; }

        [ForeignKey("MemberId")]
        public User User { get; set; }

        [ForeignKey("GroupId")]
        public Group Group { get; set; }

        public Member(Guid memberGroupId,Guid memberId, Guid groupId, bool isAdmin = false)
        {
            this.MemberGroupId = memberGroupId;
            this.MemberId = memberId;
            this.GroupId = groupId;
            this.isAdmin = isAdmin;
        }
    }
}
