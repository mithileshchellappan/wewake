namespace WeWakeAPI.ResponseModels
{
    public class GroupMemberResponse
    {
        public Guid MemberId { get; set; }
        public Guid GroupId { get; set; }
        public string MemberName { get; set; }= string.Empty;
        public bool IsAdmin { get; set; } = false;
    }
}
