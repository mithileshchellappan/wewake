import 'dart:async';

import 'package:alarm_test/models/Alarm.dart';
import 'package:alarm_test/models/Group.dart';
import 'package:alarm_test/providers/alarmsProvider.dart';
import 'package:alarm_test/providers/groupProvider.dart';
import 'package:alarm_test/screens/groupListScreen.dart';
import 'package:alarm_test/screens/groupViewScreen.dart';
import 'package:alarm_test/screens/userAlarmsScreen.dart';
import 'package:alarm_test/utils/alarmService.dart';
import 'package:alarm_test/utils/helpers.dart';
import 'package:alarm_test/utils/sharedPref.dart';
import 'package:alarm_test/widgets/PopUps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:alarm_test/api/alarm.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:alarm/alarm.dart' as AP;

class DashboardScreen extends StatefulWidget {
  static String route = "dashboardScreen";

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<dynamic> serverAlarms = [];
  int _navBarIndex = 0;
  static StreamSubscription? subscription;
  var alarmProvider;

  @override
  void initState() {
    super.initState();
    GroupProvider groupProvider =
        Provider.of<GroupProvider>(context, listen: false);

    setAlarms();
    subscription ??= AP.Alarm.ringStream.stream.listen((alarmSettings) {
      showDialog(
          context: context,
          builder: (context) {
            Alarm? alarm =
                alarmProvider.getAlarmFromAlarmAppId(alarmSettings.id);
            Group group = groupProvider.getGroup(alarm!.GroupId!);

            return MultiActionPopup(
              "⏰ ${alarm!.NotificationTitle}",
              "${alarm.NotificationBody}",
              "from: ${group.GroupName}",
              actions: [
                CupertinoDialogAction(
                  child: const Text("Snooze (+5 min)"),
                  textStyle: TextStyle(color: Colors.yellowAccent),
                  onPressed: () {
                    alarm.Time = alarm.Time.add(const Duration(minutes: 1));
                    alarmProvider.editAlarm(alarm.AlarmId, alarm);
                    AP.Alarm.set(
                        alarmSettings:
                            alarmSettings.copyWith(dateTime: alarm.Time));
                    Navigator.of(context).pop();
                    Fluttertoast.showToast(msg: "Snoozing");
                  },
                ),
                CupertinoDialogAction(
                  child: const Text("Go to group"),
                  onPressed: () {
                    Group group = groupProvider.getGroup(alarm.GroupId!);
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => GroupViewScreen(
                            group: group, iconColor: getRandomDarkColor())));
                    AP.Alarm.stop(alarmSettings.id);
                  },
                ),
                CupertinoDialogAction(
                  child: Text("Stop"),
                  isDestructiveAction: true,
                  onPressed: () {
                    AP.Alarm.stop(alarmSettings.id);
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });
  }

  void setAlarms() async {
    var providerAlarms = alarmProvider?.alarms ?? [];
    if (providerAlarms.length <= 0) {
      var res = await getUserAlarms();
      print(res);
      if (res['success']) {
        List<Alarm> alarms = res['alarms'];
        print("Setting alarms");
        alarmProvider.setAlarms(alarms);
        await AlarmService.syncAlarms(alarms);
      } else {
        Fluttertoast.showToast(msg: "Error retrieving alarms");
      }
    } else {
      serverAlarms = providerAlarms;
    }
  }

  @override
  Widget build(BuildContext context) {
    alarmProvider = Provider.of<AlarmProvider>(context, listen: true);
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
