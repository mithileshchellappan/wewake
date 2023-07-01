import 'package:alarm_test/models/Alarm.dart';
import 'package:alarm_test/providers/alarmsProvider.dart';
import 'package:alarm_test/screens/groupListScreen.dart';
import 'package:alarm_test/screens/userAlarmsScreen.dart';
import 'package:alarm_test/utils/alarmService.dart';
import 'package:alarm_test/utils/sharedPref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:alarm_test/api/alarm.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  static String route = "dashboardScreen";

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<dynamic> serverAlarms = [];

  int _navBarIndex = 0;
  @override
  void initState() {
    super.initState();
    setAlarms();
  }

  void setAlarms() async {
    var res = await getUserAlarms();
    if (res['success']) {
      List<Alarm> alarms = res['alarms'];
      final alarmProvider = Provider.of<AlarmProvider>(context, listen: false);
      alarmProvider.setAlarms(alarms);
      await AlarmService.syncAlarms(alarms);
    } else {
      Fluttertoast.showToast(msg: "Error retrieving alarms");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _navBarIndex == 0 ? GroupScreen() : UserAlarmsScreen(),
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
