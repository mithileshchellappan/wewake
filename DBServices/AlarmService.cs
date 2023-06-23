using WeWakeAPI.Data;
using WeWakeAPI.Models;

namespace WeWakeAPI.DBServices
{
    public class AlarmService
    {
        private readonly ApplicationDbContext _context;

        public AlarmService (ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<Alarm> CreateAlarm(Alarm alarm,Guid userId)
        {
            return alarm;
        }
    }
}
