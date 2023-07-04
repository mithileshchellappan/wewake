import 'package:alarm_test/models/Alarm.dart';
import 'package:flutter/material.dart';

class AlarmProvider extends ChangeNotifier {
  List<Alarm>? _alarms;
  List<Alarm>? get alarms => _alarms;

  void setAlarms(List<Alarm> alarms) {
    print("ALARM PROVIDER: Setting alarms");
    _alarms = alarms;
    notifyListeners();
  }

  void removeAlarm(Alarm alarm) {
    _alarms?.remove(alarm);
    notifyListeners();
  }

  void appendAlarm(Alarm alarm) {
    _alarms?.add(alarm);
    notifyListeners();
  }

  void clearAlarms() {
    _alarms = [];
    notifyListeners();
  }

  List<Alarm> getAlarmsWithGroupId(String groupId) {
    List<Alarm>? alarms =
        _alarms?.where((element) => element.GroupId == groupId).toList();
    return alarms ?? [];
  }

  void removeAlarmsWithGroupId(String groupId) {
    List<Alarm> alarmsToRemove =
        _alarms!.where((element) => element.GroupId == groupId).toList();

    alarmsToRemove.forEach((element) {
      removeAlarm(element);
    });
  }

  Alarm? getAlarmFromAlarmAppId(int alarmAppId) {
    Alarm alarm =
        _alarms!.where((element) => element.AlarmAppId == alarmAppId).first;
    return alarm;
  }

  void editAlarm(String alarmId, Alarm updatedAlarm) {
    final index = _alarms?.indexWhere((element) => element.AlarmId == alarmId);
    if (index != null && index >= 0) {
      _alarms?[index] = updatedAlarm;
      notifyListeners();
    }
  }
}
