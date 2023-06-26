import 'package:alarm_test/constants/api.dart';
import 'package:alarm_test/models/User.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<bool> signUp(String name, String email, String password) async {
  try {
    final route = Uri.parse("${apiRoute}/SignUp");
    print(route);
    var data = {"name": name, "email": email, "password": password};
    var encodedData = json.encode(data);
    print(encodedData);
    final headers = {'Content-Type': 'application/json'};
    final res = await http.post(route, headers: headers, body: encodedData);
    print(res.statusCode);
    if (res.statusCode == 200) {
      print(jsonDecode(res.body.toString()));
      return true;
    } else {
      return false;
    }
  } catch (e) {
    print(e);
    return false;
  }
}
