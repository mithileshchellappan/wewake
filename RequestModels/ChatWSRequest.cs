﻿using Newtonsoft.Json;
using System.ComponentModel.DataAnnotations;

namespace WeWakeAPI.RequestModels
{
    public class ChatWSRequest
    {
        [JsonProperty("messageId")]
        public string MessageId { get; set; }

        [JsonProperty("senderId")]
        public string SenderId { get; set; }
        [JsonProperty("senderName")]
        public string SenderName { get;set;}
        [JsonProperty("data")]
        public string Data { get;set;}
    }
}

