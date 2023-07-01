import 'dart:convert';

import 'package:alarm_test/api/api.dart';
import 'package:alarm_test/constants/api.dart';
import 'package:alarm_test/models/Alarm.dart';

Future<dynamic> getGroupAlarms(groupId) async {
  try {
    API api = new API();
    Uri url = Uri.parse('$apiRoute/Alarm/Group/$groupId');
    final res = await api.get(url);
    if (res.statusCode <= 299 && res.statusCode >= 200) {
      List<Alarm> alarms =
          Alarm.fromListJson((jsonDecode(res.body.toString()))['alarms']);
      return {"success": true, "alarms": alarms};
    } else {
      throw new Exception(res.body.toString());
    }
  } catch (e) {
    print(e);
    return {"success": false, "message": e.toString()};
  }
}

Future<dynamic> getUserAlarms() async {
  try {
    API api = new API();
    Uri url = Uri.parse('$apiRoute/User/Alarms');
    final res = await api.get(url);
    if (res.statusCode <= 299 && res.statusCode >= 200) {
      List<dynamic> result = (jsonDecode(res.body.toString()))['alarms'];
      List<Alarm> alarms = [];
      for (int i = 0; i < result.length; i++) {
        var alarmObj = result[i];
        Alarm alarm = Alarm.fromJson(alarmObj);
        alarms.add(alarm);
      }
      return {"success": true, "alarms": alarms};
    } else {
      print("request error" + res.body.toString());
      return {"success": false, "message": res.body.toString()};
    }
  } catch (e) {
    print(e);
    return {"success": false, "message": e.toString()};
  }
}

Future<dynamic> addAlarm(Alarm alarm) async {
  try {
    API api = new API();
    Uri url = Uri.parse('$apiRoute/Alarm/Create');
    final res = await api.post(url, body: json.encode(alarm.toJson()));
    if (res.statusCode <= 299 && res.statusCode >= 200) {
      print(res.body.toString());
      Alarm alarm = Alarm.fromJson(jsonDecode(res.body.toString())['alarm']);
      return {"success": true, "alarm": alarm};
    } else {
      print(res.body.toString());
      return {"success": false, "message": res.body.toString()};
    }
  } catch (e) {
    print(e);
    return {"success": false, "message": e.toString()};
  }
}

Future<dynamic> deleteAlarm(String alarmId) async {
  try {
    API api = new API();
    Uri url = Uri.parse('$apiRoute/Alarm/Delete/$alarmId');
    final res = await api.delete(url);
    if (res.statusCode <= 299 && res.statusCode >= 200) {
      return {"success": true};
    } else {
      return {"success": false, "message": res.body.toString()};
    }
  } catch (e) {
    return {"success": false, "message": e.toString()};
  }
}
