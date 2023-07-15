import 'dart:async';
import 'dart:convert';

import 'package:alarm_test/api/group.dart';
import 'package:alarm_test/constants/api.dart';
import 'package:alarm_test/models/Alarm.dart';
import 'package:alarm_test/models/Group.dart';
import 'package:alarm_test/providers/alarmsProvider.dart';
import 'package:alarm_test/providers/groupProvider.dart';
import 'package:alarm_test/screens/alarmTaskScreen.dart';
import 'package:alarm_test/screens/groupDashboardScreen.dart';
import 'package:alarm_test/screens/groupListScreen.dart';
import 'package:alarm_test/screens/groupViewScreen.dart';
import 'package:alarm_test/screens/userAlarmsScreen.dart';
import 'package:alarm_test/utils/alarmService.dart';
import 'package:alarm_test/utils/helpers.dart';
import 'package:alarm_test/utils/redisServce.dart';
import 'package:alarm_test/widgets/PopUps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:alarm_test/api/alarm.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:alarm/alarm.dart' as AP;
import 'package:redis/redis.dart';

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
  var groupProvider;

  @override
  void initState() {
    super.initState();
    GroupProvider groupProvider =
        Provider.of<GroupProvider>(context, listen: false);

    setAlarms();
    // setGroups();
    subToGroups(context);
    subscription ??= AP.Alarm.ringStream.stream.listen((alarmSettings) {
      showDialog(
          context: context,
          builder: (context) {
            Alarm? alarm =
                alarmProvider?.getAlarmFromAlarmAppId(alarmSettings.id);
            Group group = groupProvider.getGroup(alarm!.GroupId!);

            if (group != null && alarm != null) {
              return MultiActionPopup(
                "⏰ ${alarm.NotificationTitle}",
                alarm.NotificationBody,
                "from: ${group.GroupName}",
                actions: [
                  CupertinoDialogAction(
                    textStyle: const TextStyle(color: Colors.yellowAccent),
                    onPressed: () {
                      alarm.Time = alarm.Time.add(const Duration(minutes: 1));
                      alarmProvider.editAlarm(alarm.AlarmId, alarm);
                      AP.Alarm.set(
                          alarmSettings:
                              alarmSettings.copyWith(dateTime: alarm.Time));
                      Navigator.of(context).pop();
                      Fluttertoast.showToast(msg: "Snoozing");
                    },
                    child: const Text("Snooze (+5 min)"),
                  ),
                  CupertinoDialogAction(
                    child: const Text("Go to group"),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => GroupDashboardScreen(
                              groupId: alarm.GroupId!,
                              iconColor: getRandomDarkColor())));
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
            } else {
              AlarmService.cancelAlarm(alarm.AlarmAppId);
              return Container();
            }
          });
    });
  }

  void subToGroups(context) async {
    var res = await setGroups();

    final redisSubscriber = RedisSubscriber();

    await redisSubscriber
        .connectAndSubscribe(res.map((Group g) => g.GroupId).toList());

    redisSubscriber.messageStream.listen((event) {
      try {
        Map<String, dynamic> decodedValue = jsonDecode(event['message']!);
        print(decodedValue['action']);
        if (decodedValue['action'] == 'create') {
          print(decodedValue['alarm']);
          Alarm newAlarm = Alarm.fromJson(decodedValue['alarm']);
          print(newAlarm);
          bool addedAlarmBool = alarmProvider.alarmAlareadyExists(newAlarm);
          if (addedAlarmBool) {
            alarmProvider.appendAlarm(newAlarm);
            print("here in if of addedAlarmBool");
            AlarmService.setAlarm(newAlarm);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                action: SnackBarAction(
                    label: "Go to Group",
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => GroupDashboardScreen(
                                groupId: newAlarm.GroupId!,
                                iconColor: getRandomDarkColor())))),
                content: const Text('New Alarm Added!'),
              ),
            );
          }
        }
        print("inside event");
      } catch (e) {
        print(e);
        // print(event);
      }
    });
  }

  Future<List<Group>> setGroups() async {
    groupProvider = Provider.of<GroupProvider>(context, listen: false);
    var res = await getUserGroups();
    if (res['success']) {
      groupProvider.setGroup(res['groups']);
      return res['groups'];
      // userGroups = groupProvider.groups;

      // print(userGroups.length);
    } else {
      Fluttertoast.showToast(msg: res['message']);
      return [Group.empty()];
    }
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
        body: _getScreen(),
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
                icon: Icon(CupertinoIcons.calendar), label: "Calendar"),
            //BottomNavigationBarItem(
                //icon: Icon(
                  //CupertinoIcons.today_fill,
               // ),
                //label: "Tasks")
          ],
        ),
      ),
    );
  }

  Widget _getScreen() {
    switch (_navBarIndex) {
      case 0:
        return GroupScreen();
      case 1:
        return UserAlarmsScreen();
      case 2:
        return UserAlarmsScreen();
      default:
        return GroupScreen();
    }
  }
}

bool isJsonDecodable(String value) {
  try {
    jsonDecode(value);
    return true;
  } catch (_) {
    return false;
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
