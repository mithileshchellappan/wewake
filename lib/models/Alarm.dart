class Alarm {
  String? AlarmId;
  String? GroupId;
  String? CreatedBy; //done
  DateTime Time = DateTime.now(); //done
  bool IsEnabled = true; //done
  bool LoopAudio = false; //done
  bool Vibrate = false; //done
  String NotificationTitle = "Alarm Title"; //done
  String NotificationBody = "Alarm Body"; //done
  String InternalAudioFile = 'nokia.mp3'; //done
  bool? UseExternalAudio;
  String? AudioURL;

  Alarm.fromJson(Map<String, dynamic> json) {
    AlarmId = json['alarmId'];
    GroupId = json['groupId'];
    CreatedBy = json['createdBy'];
    Time = DateTime.parse(json['time']).toLocal();
    IsEnabled = json['isEnabled'];
    LoopAudio = json['loopAudio'];
    Vibrate = json['vibrate'];
    NotificationTitle = json['notificationTitle'];
    NotificationBody = json['notificationBody'];
    InternalAudioFile = json['internalAudioFile'];
    UseExternalAudio = json['useExternalAudio'];
    AudioURL = json['audioURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['alarmId'] = this.AlarmId;
    data['groupId'] = this.GroupId;
    data['createdBy'] = this.CreatedBy;
    data['time'] = this.Time;
    data['isEnabled'] = this.IsEnabled;
    data['loopAudio'] = this.LoopAudio;
    data['vibrate'] = this.Vibrate;
    data['notificationTitle'] = this.NotificationTitle;
    data['notificationBody'] = this.NotificationBody;
    data['internalAudioFile'] = this.InternalAudioFile;
    data['useExternalAudio'] = this.UseExternalAudio;
    data['audioURL'] = this.AudioURL;
    return data;
  }

  static List<Alarm> fromListJson(List<dynamic> arr) {
    List<Alarm> alarms = [];
    for (var json in arr) {
      Alarm alarm = Alarm.fromJson(json);
      alarms.add(alarm);
    }
    alarms.sort((a, b) => a.Time.compareTo(b.Time));
    return alarms;
  }
}
