﻿namespace WeWakeAPI.RequestModels
{
    public class GroupRequest
    {
        public string GroupName { get; set; }
        public Guid? AdminId { get; set; } = null;
        
    }
}
