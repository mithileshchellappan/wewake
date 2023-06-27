using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace WeWakeAPI.Models
{
    public class InviteLink
    {
        [Key]
        public Guid InviteLinkId { get; set; }
        [Required]
        public Guid GroupId { get; set; }

        [Required]
        public Guid InviterId { get; set; }

        [ForeignKey("GroupId")]
        public Group Group { get; set; }

        public InviteLink (Guid groupId, Guid inviterId)
        {
            this.InviteLinkId = Guid.NewGuid();
            this.GroupId = groupId;
            this.InviterId = inviterId;
        }
    }
}
