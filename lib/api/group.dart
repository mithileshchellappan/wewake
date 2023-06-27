import 'dart:convert';

import 'package:alarm_test/api/api.dart';
import 'package:alarm_test/constants/api.dart';
import 'package:alarm_test/models/Group.dart';
import 'package:alarm_test/utils/sharedPref.dart';

Future<void> getUserGroups() async {
  try {
    API api = new API();
    Uri url = Uri.parse(apiRoute + '/User/Groups');
    final res = await api.get(url);
    print(res.statusCode);
    if (res.statusCode <= 299 && res.statusCode >= 200) {
      List<dynamic> response = jsonDecode(res.body.toString());
      print(response);
    }
  } catch (e) {
    print(e);
  }
}
