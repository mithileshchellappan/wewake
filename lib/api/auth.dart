import 'package:alarm_test/api/api.dart';
import 'package:alarm_test/constants/api.dart';
import 'package:alarm_test/models/User.dart';
import 'package:alarm_test/utils/sharedPref.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final errorText = "Something went wrong, try again!";

Future<Map<String, dynamic>> signUp(
    String name, String email, String password) async {
  try {
    final route = Uri.parse("${apiRoute}/SignUp");
    print(route);
    var data = {"name": name, "email": email, "password": password};
    var encodedData = json.encode(data);
    print(encodedData);
    final headers = {'Content-Type': 'application/json'};
    final res = await http.post(route, headers: headers, body: encodedData);
    print(res.statusCode);
    print(res.body.toString());
    if (res.statusCode == 200) {
      Map<String, dynamic> response = jsonDecode(res.body.toString());
      print(response);
      SharedPreferencesHelper.setString('jwtToken', response['jwtToken']);
      SharedPreferencesHelper.setString('userName', response['name']);
      SharedPreferencesHelper.setString('userId', response['userId']);
      return {
        "success": true,
        "message": "Great to have you ${response['Name']}"
      };
    } else {
      return {"success": false, "message": errorText};
    }
  } catch (e) {
    print(e);
    return {"success": false, "message": errorText};
  }
}

Future<Map<String, dynamic>> login(String email, String password) async {
  try {
    final route = Uri.parse("${apiRoute}/Login");
    print(route);
    var data = {"email": email, "password": password};
    var encodedData = json.encode(data);
    print(encodedData);
    final headers = {'Content-Type': 'application/json'};
    final res = await http.post(route, headers: headers, body: encodedData);
    print(res.statusCode);
    if (res.statusCode == 200) {
      Map<String, dynamic> response = jsonDecode(res.body.toString());
      print(response);
      SharedPreferencesHelper.setString('jwtToken', response['jwtToken']);
      SharedPreferencesHelper.setString('userName', response['name']);
      SharedPreferencesHelper.setString('userId', response['userId']);
      return {"success": true, "message": "Welcome back ${response['name']}"};
    } else if (res.statusCode == 401) {
      return {"success": false, "message": "Incorrect Credentials. Try again!"};
    } else {
      print(res.body.toString());
      return {"success": false, "message": errorText};
    }
  } catch (e) {
    print(e);
    return {"success": false, "message": errorText};
  }
}

Future<bool> verify() async {
  try {
    API api = new API();
    Uri url = Uri.parse("$apiRoute/User/Verify");
    final res = await api.get(url);
    print(res.statusCode);
    if (res.statusCode == 200) {
      return true;
    } else {
      SharedPreferencesHelper.clear();
      return false;
    }
  } catch (e) {
    return false;
  }
}

Future<void> logout() async {
  try {
    await SharedPreferencesHelper.clear();
  } catch (e) {
    print(e);
  }
}
