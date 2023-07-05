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

        public async Task<bool> SetTaskStatus(Guid taskId,Guid memberId)
        {
            //AlarmTask task = await _context.AlarmsTasks.Where(m=>m.AlarmTaskId).FindAsync()

            TaskMember taskMember = _context.TaskMembers.Where(m => m.AlarmTaskId == taskId && m.TaskMemberId == memberId).FirstOrDefault();
            if (taskMember!=null)
            {
                taskMember.IsDone = !taskMember.IsDone;
                _context.TaskMembers.Update(taskMember);
                await _context.SaveChangesAsync();
                return taskMember.IsDone;
            }
            else
            {
                taskMember = new TaskMember(taskId, memberId, true);
                _context.TaskMembers.Add(taskMember);
                await _context.SaveChangesAsync();
                return true;
            }


        }

        

    }
}
