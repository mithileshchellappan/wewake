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
        public DbSet<AlarmOptions> AlarmOptions { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<User>()
                .HasMany(u => u.Memberships)
                .WithMany(g => g.Members)
                .UsingEntity(j => j.ToTable("GroupUser"));

            modelBuilder.Entity<Alarm>()
                .HasOne(a => a.AlarmOptions)
                .WithOne()
                .HasForeignKey<AlarmOptions>(ao => ao.AlarmId)
                .OnDelete(DeleteBehavior.Cascade);
        }
    }
}
