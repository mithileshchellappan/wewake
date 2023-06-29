using System.Text.Json.Serialization;
using Microsoft.AspNetCore.Mvc.ModelBinding;
using Microsoft.Build.Framework;

namespace WeWakeAPI.RequestModels
{
    public class AlarmRequest
    {
        public Guid GroupId { get; set; }
        [BindRequired]
        public DateTime Time { get; set; }
        public bool IsEnabled { get; set; } = true;
        public bool LoopAudio { get; set; } = false;
        public bool Vibrate { get; set; } = true;
        public string? NotificationTitle { get; set; }
        public string? NotificationBody { get; set; }
        public string? InternalAudioFile { get; set; }
        public bool UseExternalAudio { get; set; } = false;
        public string? AudioUrl { get; set; }

        public AlarmRequest(Guid groupId, DateTime time, bool isEnabled, bool loopAudio, bool vibrate, string? notificationTitle, string? notificationBody, string? internalAudioFile, bool useExternalAudio, string? audioUrl)
        {
            GroupId = groupId;
            Time = time;
            IsEnabled = isEnabled;
            LoopAudio = loopAudio;
            Vibrate = vibrate;
            NotificationTitle = notificationTitle;
            NotificationBody = notificationBody;
            InternalAudioFile = internalAudioFile ??="nokia.mp3";
            UseExternalAudio = useExternalAudio;
            AudioUrl = audioUrl;

        }
    }
}
