namespace WeWakeAPI.ResponseModels
{
    public class GroupMemberListResponse
    {
        public Guid MemberId {get;set;}
        public Guid GroupId {get;set;}
        public String MemberName{get;set;}
        public bool IsAdmin{get;set;}
    }
}