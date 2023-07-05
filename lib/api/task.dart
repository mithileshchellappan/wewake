import 'dart:convert';

import 'package:alarm_test/api/api.dart';
import 'package:alarm_test/constants/api.dart';
import 'package:alarm_test/models/Task.dart';

Future<dynamic> getTasks(String alarmId) async {
  try {
    Uri url = Uri.parse('$apiRoute/Tasks/$alarmId');
    API api = new API();
    var res = await api.get(url);
    if (res.statusCode <= 299 && res.statusCode >= 200) {
      Map<String, dynamic> parseTasks = jsonDecode(res.body.toString());
      List<Task> tasks = Task.fromListJson(parseTasks['tasks']);
      return {"success": true, "tasks": tasks};
    } else {
      return {"success": false, "message": res.body.toString()};
    }
  } catch (e) {
    print(e);
    return {"success": false, "message": e.toString()};
  }
}

Future<dynamic> createTask(String groupId, Task task) async {
  try {
    Uri url = Uri.parse('$apiRoute/Tasks/Create');
    API api = new API();
    var body = json.encode(task.toJson(groupId));
    var res = await api.post(url, body: body);
    if (res.statusCode <= 299 && res.statusCode >= 200) {
      Map<String, dynamic> parseTasks = jsonDecode(res.body.toString());
      Task task = Task.fromJson(parseTasks['task']);
      return {"success": true, "task": task};
    } else {
      return {"success": false, "message": res.body.toString()};
    }
  } catch (e) {
    print(e);
    return {"success": false, "message": e.toString()};
  }
}

Future<dynamic> setTaskStatus(String taskId, bool status) async {
  try {
    Uri url = Uri.parse("$apiRoute/Tasks/Status/$taskId");
    API api = new API();
    var res = await api.get(url);
    if (res.statusCode <= 299 && res.statusCode >= 200) {
      return {"success": true};
    } else {
      return {"success": false, "message": res.body.toString()};
    }
  } catch (e) {
    return {"success": false, "message": e.toString()};
  }
}
