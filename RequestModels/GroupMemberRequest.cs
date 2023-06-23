namespace WeWakeAPI.RequestModels
{
    public class GroupMemberRequest
    {
        public String GroupId { get; set; }
        public String? MemberId { get; set; } = null;
        public bool? SelfRemove { get; set; } = false;
    }

}
