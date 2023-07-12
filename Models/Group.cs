using Newtonsoft.Json;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace WeWakeAPI.Models
{
    public class Group
    {
        //public Group() {
        //    Members = new HashSet<User>();
        //}

        [Key]
        public Guid GroupId { get; set; }
        public string GroupName { get; set; }
        public Guid AdminId { get; set; }
        public DateTime CreatedAt { get; set; }
        public bool CanMemberCreateAlarm { get; set; } = false;

        public Dictionary<String, object> AppendKey(string key, object obj)
        {
            var spreadObj = new Dictionary<string, object>();
            spreadObj.Add("groupId", GroupId);
            spreadObj.Add("groupName", GroupName);
            spreadObj.Add("adminId", AdminId);
            spreadObj.Add("createdAt", CreatedAt);
            spreadObj.Add("canMemberCreateAlarm", CanMemberCreateAlarm);
            spreadObj.Add(key, obj);

            return spreadObj;
        }

        override
        public string ToString()
        {
            return JsonConvert.SerializeObject(this);
        }

    }

}