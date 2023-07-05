namespace WeWakeAPI.RequestModels
{
    public class AlarmTaskRequest
    {
        public Guid AlarmId { get; set; }
        public Guid GroupId { get; set; }
        public string TaskText { get; set; }
    }
}
