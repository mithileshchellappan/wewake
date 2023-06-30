import 'dart:async';
import 'package:alarm_test/api/auth.dart';
import 'package:alarm_test/models/User.dart';
import 'package:alarm_test/providers/userProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:alarm_test/utils/sharedPref.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  static String route = 'SplashScreen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    loadScreen();
  }

  Future<void> loadScreen() async {
    bool userExists = await verify();
    String? jwtToken = await SharedPreferencesHelper.getString('jwtToken');
    String? userName = await SharedPreferencesHelper.getString('userName');
    String? userId = await SharedPreferencesHelper.getString('userId');
    User user = User(userId, userName, jwtToken, "");
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.setUser(user);
    Navigator.pushReplacementNamed(
      context,
      !userExists ? 'signUpScreen' : 'dashboardScreen',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlutterLogo(
              size: 100.0,
            ),
            SizedBox(height: 16.0),
            Text(
              'WeWake',
              style: TextStyle(
                fontSize: 24.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
