import 'dart:convert';
import 'package:alarm_test/api/api.dart';
import 'package:alarm_test/constants/api.dart';
import 'package:alarm_test/models/Group.dart';

Future<dynamic> getUserGroups() async {
  try {
    API api = new API();
    Uri url = Uri.parse('$apiRoute/User/Groups');
    final res = await api.get(url);
    print(res.statusCode);
    if (res.statusCode <= 299 && res.statusCode >= 200) {
      List<dynamic> response = jsonDecode(res.body.toString());
      print(response);
      List<Group> groups = Group.fromListJson(response);
      return {"success": true, "groups": groups};
    } else {
      throw new Exception("Unable to get groups");
    }
  } catch (e) {
    print(e);
    return {"success": false, "message": e};
  }
}

Future<dynamic> createGroup(String groupName) async {
  try {
    API api = new API();
    Uri url = Uri.parse('$apiRoute/Group/Create');
    final res =
        await api.post(url, body: json.encode({"groupName": groupName}));
    print(res.body.toString() + res.statusCode.toString());
    if (res.statusCode <= 299 && res.statusCode >= 200) {
      Group group = Group.fromJson(jsonDecode(res.body.toString()));
      return {"success": true, "group": group};
    } else {
      throw new Exception("Unable to create group");
    }
  } catch (e) {
    print(e);
    return {"success": false, "message": e};
  }
}
