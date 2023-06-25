class Alarm {
  String? AlarmId;
  String? GroupId;
  String? CreatedBy;
  DateTime? Time;
  bool? IsEnabled;
  bool? LoopAudio;
  bool? Vibrate;
  String? NotificationTitle;
  String? NotificationBody;
  String? InternalAudioFIle;
  bool? UseExternalAudio;
  String? AudioURL;

  Alarm.fromJson(Map<String, dynamic> json) {
    AlarmId = json['AlarmId'];
    GroupId = json['GroupId'];
    CreatedBy = json['CreatedBy'];
    Time = json['Time'];
    IsEnabled = json['IsEnabled'];
    LoopAudio = json['LoopAudio'];
    Vibrate = json['Vibrate'];
    NotificationTitle = json['NotificationTitle'];
    NotificationBody = json['NotificationBody'];
    InternalAudioFIle = json['InternalAudioFIle'];
    UseExternalAudio = json['UseExternalAudio'];
    AudioURL = json['AudioURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AlarmId'] = this.AlarmId;
    data['GroupId'] = this.GroupId;
    data['CreatedBy'] = this.CreatedBy;
    data['Time'] = this.Time;
    data['IsEnabled'] = this.IsEnabled;
    data['LoopAudio'] = this.LoopAudio;
    data['Vibrate'] = this.Vibrate;
    data['NotificationTitle'] = this.NotificationTitle;
    data['NotificationBody'] = this.NotificationBody;
    data['InternalAudioFIle'] = this.InternalAudioFIle;
    data['UseExternalAudio'] = this.UseExternalAudio;
    data['AudioURL'] = this.AudioURL;
    return data;
  }
}
