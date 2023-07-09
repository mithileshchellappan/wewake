class Alarm {
  late String AlarmId;
  String? GroupId;
  String? CreatedBy; //done
  int AlarmAppId = 1;
  DateTime Time = DateTime.now(); //done
  bool IsEnabled = true; //done
  bool LoopAudio = false; //done
  bool Vibrate = false; //done
  String NotificationTitle = "Alarm Title"; //done
  String NotificationBody = "Alarm Body"; //done
  String? InternalAudioFile; //done
  bool UseExternalAudio = false;
  String AudioURL = "";
  String? GroupName = "";

  Alarm(
    this.GroupId,
    this.NotificationTitle,
    this.NotificationBody,
    this.IsEnabled,
    this.Vibrate,
    this.LoopAudio,
    this.Time,
    this.InternalAudioFile,
    this.GroupName,
  );

  Alarm.fromJson(Map<String, dynamic> json) {
    AlarmId = json['alarmId'];
    GroupId = json['groupId'];
    AlarmAppId = json['alarmAppId'];
    CreatedBy = json['createdBy'];
    Time = DateTime.parse(json['time']);
    IsEnabled = json['isEnabled'];
    LoopAudio = json['loopAudio'];
    Vibrate = json['vibrate'];
    NotificationTitle = json['notificationTitle'];
    NotificationBody = json['notificationBody'];
    InternalAudioFile = json['internalAudioFile'];
    UseExternalAudio = json['useExternalAudio'];
    AudioURL = json['audioURL'] ?? "";
    GroupName = json['groupName'] ?? "";
  }

  Map toJson() {
    Map data = {};
    // data['alarmId'] = this.AlarmId;
    data['groupId'] = this.GroupId ?? "";
    // data['createdBy'] = this.CreatedBy;
    data['time'] = this.Time.toIso8601String();
    data['isEnabled'] = this.IsEnabled;
    data['loopAudio'] = this.LoopAudio;
    data['vibrate'] = this.Vibrate;
    data['notificationTitle'] = this.NotificationTitle;
    data['notificationBody'] = this.NotificationBody;
    data['internalAudioFile'] = this.InternalAudioFile ?? "nokia.mp3";
    data['useExternalAudio'] = this.UseExternalAudio;
    data['audioURL'] = this.AudioURL;
    return data;
  }

  Alarm.empty() {
    AlarmId = "";
    GroupId = "";
    AlarmAppId = 0;
    CreatedBy = "";
    Time = DateTime(0);
    IsEnabled = false;
    LoopAudio = false;
    Vibrate = false;
    NotificationTitle = "";
    NotificationBody = "";
    InternalAudioFile = "";
    UseExternalAudio = false;
    AudioURL = "";
    GroupName = "";
  }

  static List<Alarm> fromListJson(List<dynamic> arr) {
    List<Alarm> alarms = [];
    for (var json in arr) {
      Alarm alarm = Alarm.fromJson(json);
      alarms.add(alarm);
    }
    alarms.sort((a, b) {
      print(" " + a.Time.toString() + b.Time.toString());

      if (a.Time.isAfter(DateTime.now()) && b.Time.isAfter(DateTime.now())) {
        return a.Time.compareTo(b.Time);
      } else if (a.Time.isAfter(DateTime.now()) &&
          b.Time.isBefore(DateTime.now())) {
        return -1;
      } else if (a.Time.isBefore(DateTime.now()) &&
          b.Time.isAfter(DateTime.now())) {
        return 1;
      } else {
        return a.Time.compareTo(b.Time);
      }
    });

    return alarms;
  }
}
