namespace WeWakeAPI.ResponseModels
{
    public class AlarmTaskResponse
    {
        public Guid AlarmTaskId { get;set; }
        public Guid AlarmId { get;set; }
        public string TaskText { get; set; }
        public bool IsDone { get; set; }
        public int DoneCount { get; set; }


    }
}
