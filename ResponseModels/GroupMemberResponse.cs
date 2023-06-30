namespace WeWakeAPI.ResponseModels
{
    public class GroupMemberResponse
    {
        public Guid MemberId { get; set; }
        public Guid GroupId { get; set; }
        public Guid AdminId { get; set; }

        public string MemberName { get; set; }= string.Empty;
        public string GroupName { get; set; }
        public bool IsAdmin { get; set; } = false;
        public DateTime CreatedAt {get;set;}
        public bool CanSetAlarm { get; set; } = false;
        public int MemberCount {get;set;} = 0;
    }
}
