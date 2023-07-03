using Microsoft.EntityFrameworkCore;
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

        public async Task<Guid> GetLastMessageId(Guid groupId)
        {
            var lastId = await _context.Chats
                .Where(c => c.GroupId == groupId)
                .OrderByDescending(x=>x.CreatedAt)
                                              .FirstOrDefaultAsync();      
            if (lastId != null)
            {
                return lastId.MessageId;
            }
            else
            {
                return Guid.Empty;
            }
        }

        public async Task<List<Chat>> GetChat(Guid groupId)
        {
            List<Chat> chats = await _context.Chats
                .Where(c=> c.GroupId == groupId)
                .OrderByDescending(x => x.CreatedAt).ToListAsync();
            return chats;
        }
    }
}
