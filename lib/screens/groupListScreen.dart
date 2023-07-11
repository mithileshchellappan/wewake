import 'dart:async';

import 'package:alarm_test/api/auth.dart';
import 'package:alarm_test/api/group.dart';
import 'package:alarm_test/models/Alarm.dart';
import 'package:alarm_test/providers/alarmsProvider.dart';
import 'package:alarm_test/providers/groupProvider.dart';
import 'package:alarm_test/utils/alarmService.dart';
import 'package:alarm_test/widgets/cards/groupCard.dart';
import 'package:alarm_test/widgets/PopUps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:alarm_test/models/Group.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:alarm_test/providers/userProvider.dart';

class GroupScreen extends StatefulWidget {
  GroupScreen({Key? key}) : super(key: key);

  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  List<Group> userGroups = [];
  Alarm? alarm;
  var groupProvider;
  var alarmProvider;
  var userProvider;
  var upcomingAlarm;
  static StreamController<DateTime> _timeController =
      StreamController<DateTime>.broadcast();
  static Timer? _timer;

  @override
  void initState() {
    super.initState();
    setGroups();
    getUpcomingAlarm();
    !_timeController.isClosed ? _timeController.add(DateTime.now()) : null;
    _timer ??= Timer.periodic(Duration(microseconds: 500), (_) {
      _timeController.add(DateTime.now());
    });
  }

  void getUpcomingAlarm() {
    alarmProvider = Provider.of<AlarmProvider>(context, listen: false);
    alarm = alarmProvider.getUpcomingAlarm();
  }

  void setGroups() async {
    groupProvider = Provider.of<GroupProvider>(context, listen: false);
    var providerGroups = groupProvider?.groups ?? [];
    if (providerGroups.length <= 0) {
      var res = await getUserGroups();
      if (res['success']) {
        groupProvider.setGroup(res['groups']);
        userGroups = groupProvider.groups;

        print(userGroups.length);
      } else {
        Fluttertoast.showToast(msg: res['message']);
      }
    } else {
      userGroups = groupProvider.groups;
    }
  }

  Future<void> createGroupAndRefreshList(
      String name, Function callback, bool optionValue) async {
    print(optionValue);
    var res = await callback(name, optionValue);
    print(res);
    if (res['success']) {
      groupProvider.appendGroup(res['group']);
      setState(() {});

      print(userGroups.length);
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
  }

  String formatTimeDifference(Duration difference) {
    if (difference.inSeconds < 60 && difference.inSeconds > 0) {
      return "Next alarm in ${difference.inSeconds} seconds";
    } else if (difference.inMinutes < 60) {
      if (difference.inMinutes < 0) {
        return "Alarm Expired";
      }

      return "Next alarm in ${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'}";
    } else if (difference.inHours < 24) {
      if (difference.inHours < 0) {
        return "Alarm Expired";
      }
      return "Next alarm in ${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'}";
    } else if (difference.inDays < 30) {
      if (difference.inDays < 0) {
        return "Alarm Expired";
      }
      return "Next alarm in ${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'}";
    } else {
      int months = (difference.inDays / 30).floor();
      if (months < 0) {
        return "Alarm Expired";
      }
      return "Next alarm in $months ${months == 1 ? 'month' : 'months'}";
    }
  }

  @override
  Widget build(BuildContext context) {
    // final userProvider = Provider.of<UserProvider>(context, listen: false);
    groupProvider = Provider.of<GroupProvider>(context, listen: true);
    userProvider = Provider.of<UserProvider>(context, listen: true);
    alarmProvider = Provider.of<AlarmProvider>(context, listen: true);
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        // appBar: CupertinoNavigationBar(
        //     brightness: Theme.of(context).brightness,
        //     backgroundColor: Theme.of(context).backgroundColor,
        //     transitionBetweenRoutes: false,
        //     automaticallyImplyLeading: false,
        //     leading: Padding(
        //       padding: const EdgeInsets.only(top: 15.0),
        //       child: Text(
        //         "Hello ${userProvider.user?.Name}",
        //         style: TextStyle(color: Colors.white),
        //       ),
        //     ),
        //     trailing: CupertinoButton(
        //       child: Icon(Icons.logout),
        //       onPressed: () => showDialog(
        //         context: context,
        //         builder: (context) => YNPopUp(
        //           "Logout?",
        //           () async {
        //             logout();
        //             await AlarmService.cancelAllAlarms();
        //             userProvider.removeUser();
        //             Navigator.pushReplacementNamed(context, 'signUpScreen');
        //           },
        //           yesText: "Logout",
        //           noText: "Cancel",
        //         ),
        //       ),
        //     )),
        floatingActionButton: GroupFloatingActionButton(
          onCreateGroup: () => showDialog(
            context: context,
            builder: (context) => PopUpDialog(
              "Enter Group Name",
              (name, optionValue) async => await createGroupAndRefreshList(
                  name, createGroup, optionValue),
              yesText: 'Create',
              showOption: true,
              optionText: "Allow users set alarm?",
            ),
          ),
          onJoinGroup: () => showDialog(
            context: context,
            builder: (context) => PopUpDialog(
              "Enter Invite Link",
              showOption: false,
              (name, optionValue) async =>
                  await createGroupAndRefreshList(name, joinGroup, optionValue),
              yesText: 'Join',
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: Container(
            child: CustomScrollView(slivers: <Widget>[
          CupertinoSliverNavigationBar(
            backgroundColor: Theme.of(context).backgroundColor,
            largeTitle: Text("Groups", style: TextStyle(color: Colors.white)),
            trailing: Material(
              color: Colors.black,
              child: InkWell(
                child: Icon(
                  CupertinoIcons.square_arrow_right,
                  color: Theme.of(context).highlightColor,
                ),
                onTap: () => showDialog(
                  context: context,
                  builder: (context) => YNPopUp(
                    "Logout?",
                    () async {
                      logout();
                      await AlarmService.cancelAllAlarms();
                      userProvider.removeUser();
                      Navigator.pushReplacementNamed(context, 'signUpScreen');
                    },
                    yesText: "Logout",
                    noText: "Cancel",
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                childCount: userGroups.length + 1, ((context, index) {
              if (index == 0) {
                return StreamBuilder<DateTime>(
                  stream: _timeController.stream,
                  builder: (context, snapshot) {
                    alarm = alarmProvider?.getUpcomingAlarm();
                    if (alarm != null && snapshot.hasData) {
                      return Container(
                          margin: const EdgeInsets.all(4),
                          height: 40,
                          decoration: BoxDecoration(
                              color: Theme.of(context).canvasColor,
                              border: Border.all(color: Colors.black38),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          child: Container(
                              margin: const EdgeInsets.only(
                                left: 10,
                              ),
                              child: (alarm?.Time == Alarm.empty().Time ||
                                      alarm!.Time.isBefore(snapshot.data!))
                                  ? Container(
                                      margin:
                                          EdgeInsets.only(left: 10, top: 10),
                                      child: Text('No upcoming alarms',
                                          style: TextStyle(
                                              color: Colors.grey[700])),
                                    )
                                  : Row(
                                      children: [
                                        Text(formatTimeDifference(alarm!.Time
                                            .difference(snapshot.data!))),
                                        Expanded(
                                          child: Container(),
                                        ),
                                        Text("${alarm!.GroupName!}, ",
                                            style: TextStyle(
                                                color: Colors.grey[700])),
                                        Text(
                                            DateFormat('hh:mm a')
                                                .format(alarm!.Time),
                                            style: TextStyle(
                                                color: Colors.grey[700])),
                                        const SizedBox(width: 10)
                                      ],
                                    )));
                    } else {
                      return Container(
                          margin: EdgeInsets.all(4),
                          height: 40,
                          decoration: BoxDecoration(
                              color: Theme.of(context).canvasColor,
                              border: Border.all(color: Colors.black38),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Container(
                            margin: EdgeInsets.only(left: 10, top: 10),
                            child: Text('No upcoming alarms',
                                style: TextStyle(color: Colors.grey[700])),
                          ));
                    }
                  },
                );
              }

              if (index > 0) {
                var adjIndex = index - 1;
                return GroupCard(
                    group: userGroups[adjIndex],
                    userId: userProvider.user!.UserId!,
                    groupProvider: groupProvider);
              }
            })),
          )
        ])));
  }
}

class GroupFloatingActionButton extends StatelessWidget {
  final VoidCallback onCreateGroup;
  final VoidCallback onJoinGroup;

  const GroupFloatingActionButton({
    required this.onCreateGroup,
    required this.onJoinGroup,
  });

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      spacing: 5,
      icon: Icons.expand_less,
      activeIcon: Icons.expand_more,
      iconTheme: IconThemeData(size: 50),
      animationCurve: Curves.elasticInOut,
      backgroundColor: Theme.of(context).focusColor,
      children: [
        SpeedDialChild(
            child: const Icon(Icons.nat),
            label: 'Debugging Button',
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return MultiActionPopup(
                      "⏰ Test",
                      "Test",
                      "from: Group",
                      actions: [
                        CupertinoDialogAction(
                          textStyle:
                              TextStyle(backgroundColor: Colors.yellowAccent),
                          child: Container(
                            child: const Text("Snooze (+5 min)"),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            Fluttertoast.showToast(msg: "Snoozing");
                          },
                        ),
                        CupertinoDialogAction(
                          child: Text("Go to group"),
                          onPressed: () {},
                        ),
                        CupertinoDialogAction(
                          child: Text("Stop"),
                          isDestructiveAction: true,
                          onPressed: () {},
                        )
                      ],
                    );
                  });
            }),
        SpeedDialChild(
          child: const Icon(Icons.add),
          label: 'Create Group',
          onTap: onCreateGroup,
        ),
        SpeedDialChild(
          child: const Icon(Icons.group_add_outlined),
          label: 'Join Group',
          onTap: onJoinGroup,
        ),
      ],
    );
  }
}

  //  Column(
                    //       children: userGroups
                    //           .map((element) => GroupCard(
                    //                 group: element,
                    //                 groupProvider: groupProvider,
                    //                 userId: userProvider.user!.UserId!,
                    //               ))
                    //           .toList(),
                    //     ))