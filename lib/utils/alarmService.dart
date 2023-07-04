import 'package:alarm/alarm.dart' as AP;
import 'package:alarm/model/alarm_settings.dart';
import 'package:alarm_test/models/Alarm.dart';

class AlarmService {
  static Future<void> initAlarm() async {
    print("ALARM INIT");
    await AP.Alarm.init(showDebugLogs: false);
    // await setAlarm();
  }

  static List<AlarmSettings> getAlarmsInSystem() {
    List<AlarmSettings> alarms = AP.Alarm.getAlarms();
    // print(alarms.length);
    return alarms;
  }

  static Future<void> setAlarm(Alarm alarm) async {
    final now = DateTime.now().add(Duration(minutes: 1));
    var alarmSettings = AlarmSettings(
      id: alarm.AlarmAppId,
      dateTime: alarm.Time,
      loopAudio: alarm.LoopAudio,
      vibrate: alarm.Vibrate,
      notificationTitle: alarm.NotificationTitle,
      notificationBody: alarm.NotificationBody,
      assetAudioPath: 'assets/${alarm.InternalAudioFile}',
      enableNotificationOnKill: true,
      stopOnNotificationOpen: true,
    );
    if (alarm.IsEnabled &&
        alarm.Time.compareTo(DateTime.now()) > 0 &&
        !await checkAlarm(alarm.AlarmAppId)) {
      print(
          "alarm set ${alarm.Time} ${alarm.AlarmId} ${alarm.NotificationTitle}");
      await AP.Alarm.set(alarmSettings: alarmSettings);
    }
  }

  static void cancelAlarm(int alarmId) {
    print("Cancelled alarm $alarmId");
    AP.Alarm.stop(alarmId);
  }

  static Future<bool> checkAlarm(alarmId) async {
    List<AlarmSettings> alarms = getAlarmsInSystem();
    for (int i = 0; i < alarms.length; i++) {
      if (alarms[i].id == alarmId) return true;
    }
    return false;
  }

  static Future<void> syncAlarms(List<Alarm> serverAlarms) async {
    List<AlarmSettings> deviceAlarms = getAlarmsInSystem();

    for (int i = 0; i < deviceAlarms.length; i++) {
      if (!serverAlarms
          .any((alarm) => alarm.AlarmAppId == deviceAlarms[i].id)) {
        cancelAlarm(deviceAlarms[i].id);
      }
    }

    for (int i = 0; i < serverAlarms.length; i++) {
      bool isAlarmSet = await checkAlarm(serverAlarms[i].AlarmAppId);
      if (!isAlarmSet) {
        await setAlarm(serverAlarms[i]);
      }
    }
  }

  static Future<void> cancelMultipleAlarms(List<Alarm> alarms) async {
    for (var alarm in alarms) {
      cancelAlarm(alarm.AlarmAppId);
    }
  }

  static Future<void> cancelAllAlarms() async {
    List<AlarmSettings> deviceAlarms = getAlarmsInSystem();

    for (int i = 0; i < deviceAlarms.length; i++) {
      cancelAlarm(deviceAlarms[i].id);
    }
  }
}
