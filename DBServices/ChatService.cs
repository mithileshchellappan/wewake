using WeWakeAPI.Data;
using WeWakeAPI.Models;

namespace WeWakeAPI.DBServices
{
    public class ChatService
    {
        private readonly ApplicationDbContext _context;

        public ChatService(ApplicationDbContext context)
        {
            _context = context;
        }

        public void AddMessage(Chat message)
        {
            _context.Chats.Add(message);
            _context.SaveChanges();
        }
    }
}
