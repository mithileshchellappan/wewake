import 'dart:async';

import 'package:alarm_test/api/auth.dart';
import 'package:alarm_test/api/group.dart';
import 'package:alarm_test/providers/groupProvider.dart';
import 'package:alarm_test/utils/alarmService.dart';
import 'package:alarm_test/widgets/cards/groupCard.dart';
import 'package:alarm_test/widgets/PopUps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:alarm_test/models/Group.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:alarm_test/providers/userProvider.dart';

class GroupScreen extends StatefulWidget {
  GroupScreen({Key? key}) : super(key: key);

  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  List<Group> userGroups = [];
  var groupProvider;
  var userProvider;

  @override
  void initState() {
    super.initState();
    setGroups();
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

  @override
  Widget build(BuildContext context) {
    // final userProvider = Provider.of<UserProvider>(context, listen: false);
    groupProvider = Provider.of<GroupProvider>(context, listen: true);
    userProvider = Provider.of<UserProvider>(context, listen: true);
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
            trailing: InkWell(
              child: Icon(CupertinoIcons.square_arrow_right),
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
          SliverList(
            delegate: SliverChildBuilderDelegate(
                childCount: userGroups.length,
                ((context, index) =>
                    //  Column(
                    //       children: userGroups
                    //           .map((element) => GroupCard(
                    //                 group: element,
                    //                 groupProvider: groupProvider,
                    //                 userId: userProvider.user!.UserId!,
                    //               ))
                    //           .toList(),
                    //     ))
                    GroupCard(
                        group: userGroups[index],
                        userId: userProvider.user!.UserId!,
                        groupProvider: groupProvider))),
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
