import 'dart:convert';

import 'package:alarm_test/api/api.dart';
import 'package:alarm_test/constants/api.dart';
import 'package:alarm_test/models/Alarm.dart';

Future<dynamic> getGroupAlarms(groupId) async {
  try {
    API api = new API();
    Uri url = Uri.parse('$apiRoute/Alarm/Group/$groupId');
    final res = await api.get(url);
    print('here in createGroup' +
        res.body.toString() +
        res.statusCode.toString());
    if (res.statusCode <= 299 && res.statusCode >= 200) {
      List<Alarm> alarms =
          Alarm.fromListJson((jsonDecode(res.body.toString()))['alarms']);
      return {"success": true, "alarms": alarms};
    } else {
      throw new Exception(res.body.toString());
    }
  } catch (e) {
    print(e);
    return {"success": false, "message": e};
  }
}
