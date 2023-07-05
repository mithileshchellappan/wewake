using Microsoft.EntityFrameworkCore;
using WeWakeAPI.Data;
using WeWakeAPI.Models;
using WeWakeAPI.ResponseModels;

namespace WeWakeAPI.DBServices
{
    public class AlarmTaskService
    {
        private readonly ApplicationDbContext _context;

        public AlarmTaskService(ApplicationDbContext context)
        {
            _context = context;

        }

        public async Task<AlarmTaskResponse> CreateTask(Guid alarmId,Guid memberId,string taskText )
        {
            AlarmTask task =new AlarmTask(alarmId, taskText);
            TaskMember taskMember = new TaskMember(task.AlarmTaskId, memberId, false);
            _context.TaskMembers.Add(taskMember);
            _context.AlarmsTasks.Add(task);
            await _context.SaveChangesAsync();

            return new AlarmTaskResponse { AlarmTaskId =task.AlarmTaskId,TaskText= task.TaskText,AlarmId=alarmId,IsDone=false,DoneCount=0 };

        }

        public async Task<List<AlarmTaskResponse>> GetTasks(Guid alarmId,Guid memberId)
        {
            List<AlarmTaskResponse> tasks = await (
                                            from task in _context.AlarmsTasks
                                            join member in _context.TaskMembers on task.AlarmTaskId equals member.AlarmTaskId into taskMembers
                                            where task.AlarmId == alarmId
                                            select new AlarmTaskResponse
                                             {
                                                AlarmTaskId = task.AlarmTaskId,
                                                AlarmId = task.AlarmId,
                                                TaskText = task.TaskText,
                                                IsDone = taskMembers.Any(member => member.IsDone),
                                                DoneCount = taskMembers.Count(member => member.IsDone)
                                             }
                                            ).ToListAsync();



            return tasks;
        }

        

    }
}
