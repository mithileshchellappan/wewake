using System.ComponentModel.DataAnnotations;
using Newtonsoft.Json;

namespace WeWakeAPI.Models
{
    public class User
    {
        [Key]
        public Guid UserId { get; set; }
        public string Name { get; set; }
        public string Email { get; set; }
        [JsonIgnore]
        public string PasswordHash { get; set; }

    }


}