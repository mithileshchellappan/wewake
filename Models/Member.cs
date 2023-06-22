namespace WeWakeAPI.Models
{
    public class Member
    {
        public Guid MemberId { get; set; }
        public Guid GroupId { get; set; }
        public bool isAdmin { get; set; }
    }
}
