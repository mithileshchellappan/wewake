using WeWakeAPI.Data;

namespace WeWakeAPI.DBServices
{
    public class AlarmTaskService
    {
        private readonly ApplicationDbContext _context;

        public AlarmTaskService(ApplicationDbContext context)
        {
            _context = context;

        }

        public async Task<List<AlarmTaskResponse>> GetTasks(Guid taskId,Guid memberId)
        {

        }

    }
}
