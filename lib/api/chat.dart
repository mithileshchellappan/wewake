import 'dart:convert';

import 'package:alarm_test/constants/api.dart';

import 'api.dart';

Future<dynamic> getChatsCheckerId(groupId) async {
  try {
    API api = new API();
    Uri url = Uri.parse('$apiRoute/Chat/id/${groupId}');
    final res = await api.get(url);
    if (res.statusCode <= 299 && res.statusCode >= 200) {
      return jsonDecode(res.body.toString());
    }
  } catch (e) {
    return {"success": false, "message": e.toString()};
  }
}

Future<dynamic> getGroupChats(groupId) async {
  try {
    API api = new API();
    Uri url = Uri.parse('$apiRoute/Chat/${groupId}');
    final res = await api.get(url);
    if (res.statusCode <= 299 && res.statusCode >= 200) {
      return await jsonDecode(res.body.toString());
    }
  } catch (e) {
    return {"success": false, "message": e.toString()};
  }
}
