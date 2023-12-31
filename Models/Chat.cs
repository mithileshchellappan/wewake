using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace WeWakeAPI.Models
{
    public class Chat
    {

        [Key]
        public Guid MessageId { get; set; }
        public Guid GroupId { get; set; }
        public Guid SenderId { get; set; }
        public string SenderName {get;set;}
        public string Data { get; set; }
        public DateTime CreatedAt { get; set; }

       
        public Chat(Guid messageId,Guid groupId, Guid senderId, string senderName, string data)
        {
            this.MessageId = messageId;
            this.GroupId = groupId;
            this.SenderId = senderId;
            this.SenderName = senderName;
            this.CreatedAt = DateTime.Now;
            this.Data = data;
        }

        // public Dictionary<String, object> AppendKey(string key, object obj)
        // {
        //     var spreadObj = new Dictionary<string, object>();
        //     spreadObj.Add("groupId", GroupId);
        //     spreadObj.Add("groupName", GroupName);
        //     spreadObj.Add("adminId", AdminId);
        //     spreadObj.Add("createdAt", CreatedAt);
        //     spreadObj.Add("canMemberCreateAlarm", CanMemberCreateAlarm);
        //     spreadObj.Add(key, obj);

        //     return spreadObj;
        // }

    }

}