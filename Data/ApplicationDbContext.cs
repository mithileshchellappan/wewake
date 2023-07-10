using Microsoft.EntityFrameworkCore;
using WeWakeAPI.Models;

namespace WeWakeAPI.Data
{
    public class ApplicationDbContext : DbContext
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options)
        {

        }

        public DbSet<User> Users { get; set; }
        public DbSet<Group> Groups { get; set; }
        public DbSet<Alarm> Alarms { get; set; }
        public DbSet<Member> Members { get; set; }

        public DbSet<InviteLink> InviteLinks { get; set; }
        public DbSet<OptOut> OptOuts { get; set; }

        public DbSet<Chat> Chats { get; set; }

        public DbSet<AlarmTask> AlarmsTasks { get; set; }
        public DbSet<TaskMember> TaskMembers { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            
            base.OnModelCreating(modelBuilder);

        }
    }
}
