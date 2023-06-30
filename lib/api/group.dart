import 'dart:convert';
import 'package:alarm_test/api/api.dart';
import 'package:alarm_test/constants/api.dart';
import 'package:alarm_test/models/Group.dart';
import 'package:alarm_test/models/Member.dart';

Future<dynamic> getUserGroups() async {
  try {
    API api = new API();
    Uri url = Uri.parse('$apiRoute/User/Groups');
    final res = await api.get(url);
    // print(res.body.toString());
    if (res.statusCode <= 299 && res.statusCode >= 200) {
      Map<String, dynamic> parseGroup = jsonDecode(res.body.toString());
      List<Group> groups = Group.fromListJson(parseGroup['groups']);
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
    if (res.statusCode <= 299 && res.statusCode >= 200) {
      Map<String, dynamic> parseGroup = jsonDecode(res.body.toString());
      Group group = Group.fromJson(parseGroup['group']);
      // print('in success');
      return {"success": true, "group": group};
    } else {
      throw new Exception("Unable to create group");
    }
  } catch (e) {
    print(e);
    return {"success": false, "message": e};
  }
}

Future<dynamic> getInviteCode(groupId) async {
  try {
    API api = new API();
    Uri url = Uri.parse('$apiRoute/Group/GetInviteLink/$groupId');
    final res = await api.get(url);
    if (res.statusCode <= 299 && res.statusCode >= 200) {
      return jsonDecode(res.body.toString());
    } else {
      return {"success": false, "message": res.body.toString()};
    }
  } catch (e) {
    return {"success": false, "message": e};
  }
}

Future<dynamic> joinGroup(String inviteCode) async {
  try {
    API api = new API();
    Uri url = Uri.parse('$apiRoute/Group/Join/$inviteCode');
    final res = await api.get(url);
    print(res.body.toString() + res.statusCode.toString());
    if (res.statusCode <= 299 && res.statusCode >= 200) {
      Group group = Group.fromJson((jsonDecode(res.body.toString()))['group']);
      return {"success": true, "group": group};
    } else {
      throw new Exception(res.body.toString());
    }
  } catch (e) {
    return {"success": false, "message": e};
  }
}

Future<dynamic> getMembers(String groupId) async {
  try {
    API api = new API();
    Uri url = Uri.parse("$apiRoute/Group/Members/$groupId");
    final res = await api.get(url);
    print(res.body.toString() + res.statusCode.toString());

    if (res.statusCode <= 299 && res.statusCode >= 200) {
      List<Member> members =
          Member.fromListJson((jsonDecode(res.body.toString()))['members']);
      return {"success": true, "members": members};
    } else {
      throw new Exception("Unable to fetch members");
    }
  } catch (e) {
    return {"success": false, "message": e};
  }
}

Future<dynamic> removeMember(String groupId, String memberId) async {
  try {
    API api = new API();
    Uri url = Uri.parse("$apiRoute/Group/RemoveMember");
    var data = {"GroupId": groupId, "MemberId": memberId};
    final res = await api.post(url, body: jsonEncode(data));
    if (res.statusCode <= 299 && res.statusCode >= 200) {
      return {"success": true, "message": "Member Removed successfully"};
    } else {
      print(res.body.toString());
      return {
        "success": false,
        "message": "Unable to remove member ${res.body.toString()}"
      };
    }
  } catch (e) {
    print(e.toString());
    return {
      "success": false,
      "message": "Unable to remove member ${e.toString()}"
    };
  }
}
