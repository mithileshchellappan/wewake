import 'package:alarm_test/api/group.dart';
import 'package:alarm_test/cards/groupCard.dart';
import 'package:alarm_test/utils/PopUps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:alarm_test/models/Group.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({Key? key}) : super(key: key);

  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  List<Group> userGroups = [];

  void initState() {
    super.initState();
    setGroups();
  }

  void setGroups() async {
    var res = await getUserGroups();
    if (res['success']) {
      setState(() {
        userGroups = res['groups'];
      });
      print(userGroups.length);
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
  }

  Future<void> createGroupAndRefreshList(String name) async {
    var res = await createGroup(name);
    if (res['success']) {
      setState(() {
        userGroups.add(res['group']);
      });
      print(userGroups.length);
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: GroupFloatingActionButton(
        onCreateGroup: () => showDialog(
          context: context,
          builder: (context) => PopUpDialog(
            "Enter Group Name",
            (name) => createGroupAndRefreshList(name),
            yesText: 'Create',
          ),
        ),
        onJoinGroup: () async => await getUserGroups(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Container(
          child: SingleChildScrollView(
              child: Column(
        children:
            userGroups.map((element) => GroupCard(group: element)).toList(),
      ))),
    );
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
