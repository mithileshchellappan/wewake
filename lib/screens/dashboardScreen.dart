import 'package:alarm_test/api/auth.dart';
import 'package:alarm_test/api/group.dart';
import 'package:alarm_test/screens/groupScreen.dart';
import 'package:alarm_test/utils/PopUps.dart';
import 'package:alarm_test/utils/sharedPref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class DashboardScreen extends StatefulWidget {
  static String route = "dashboardScreen";

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Future<String?>? userNameFuture;
  int _navBarIndex = 0;
  @override
  void initState() {
    super.initState();
    userNameFuture = getUserName();
  }

  Future<String?> getUserName() async {
    return SharedPreferencesHelper.getString('userName');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
          brightness: Theme.of(context).brightness,
          backgroundColor: Theme.of(context).backgroundColor,
          transitionBetweenRoutes: false,
          automaticallyImplyLeading: false,
          trailing: CupertinoButton(
            child: Icon(Icons.logout),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => YNPopUp(
                "Logout?",
                () {
                  logout();
                  Navigator.pushReplacementNamed(context, 'signUpScreen');
                },
                yesText: "Logout",
                noText: "Cancel",
              ),
            ),
          )),
      body: _navBarIndex == 0 ? GroupScreen() : Container(),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: _navBarIndex,
        onTap: (value) => {
          setState(() {
            _navBarIndex = value;
          })
        },
        backgroundColor: Colors.black,
        height: 60,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.group), label: "Groups"),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.alarm), label: "Alarms"),
        ],
      ),
    );
  }
}



// class FloatingAction extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         Container(
//           padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
//           margin: EdgeInsets.only(bottom: 70),
//           child: Transform.rotate(angle: math.pi / 1, child: Container()),
//         ),
//       ],
//     );
//   }
// }
