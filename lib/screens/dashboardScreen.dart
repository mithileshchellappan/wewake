import 'package:alarm_test/models/Alarm.dart';
import 'package:alarm_test/screens/groupScreen.dart';
import 'package:alarm_test/utils/alarmService.dart';
import 'package:alarm_test/utils/sharedPref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:alarm_test/api/alarm.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
    setAlarms();
    userNameFuture = getUserName();
  }

  void setAlarms() async {
    var res = await getUserAlarms();
    if (res['success']) {
      List<dynamic> alarms = res['alarms'];
      List<Alarm> serverAlarms = [];
      for (int i = 0; i < alarms.length; i++) {
        serverAlarms.add(alarms[i]['alarm']);
      }
      await AlarmService.syncAlarms(serverAlarms);
    } else {
      Fluttertoast.showToast(msg: "Error retrieving alarms");
    }
  }

  Future<String?> getUserName() async {
    return SharedPreferencesHelper.getString('userName');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
