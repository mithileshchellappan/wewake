import 'package:alarm_test/api/alarm.dart';
import 'package:alarm_test/api/group.dart';
import 'package:alarm_test/cards/alarmCard.dart';
import 'package:alarm_test/cards/memberCard.dart';
import 'package:alarm_test/utils/TextIcon.dart';
import 'package:alarm_test/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../models/Alarm.dart';
import '../models/Group.dart';
import '../models/Member.dart';

class GroupViewScreen extends StatefulWidget {
  final Group group;
  final Color iconColor;
  const GroupViewScreen(
      {Key? key, required this.group, required this.iconColor})
      : super(key: key);

  @override
  State<GroupViewScreen> createState() => _GroupViewScreenState();
}

class _GroupViewScreenState extends State<GroupViewScreen> {
  bool isExpanded = false;
  bool isLoading = false;
  List<Member> members = [];
  List<Alarm> alarms = [];
  bool isAlarmsLoading = false;
  @override
  void initState() {
    super.initState();
    setAlarms();
  }

  void setAlarms() async {
    setState(() {
      isAlarmsLoading = true;
    });
    var res = await getGroupAlarms(widget.group.GroupId);
    if (res['success']) {
      setState(() {
        alarms = res['alarms'];
      });
      print(alarms.length);
    } else {
      Fluttertoast.showToast(msg: res['message']);
    }
    setState(() {
      isAlarmsLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        brightness: Theme.of(context).brightness,
        backgroundColor: Theme.of(context).backgroundColor,
        transitionBetweenRoutes: true,
        automaticallyImplyLeading: true,
        middle: Text(
          widget.group.GroupName ?? 'Group',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              getTopDash(context),
              if (isExpanded) buildMemberList(),
              isAlarmsLoading
                  ? Center(child: CupertinoActivityIndicator())
                  : Container(),
              ...alarms.map((e) => AlarmCard(
                    alarm: e,
                  )),
              SizedBox(height: 20)
            ],
          ),
        ),
      ),
    );
  }

  Widget getTopDash(BuildContext context) {
    String groupName = widget.group.GroupName ?? "Group Name";
    String createdOn = DateFormat('dd MMMM yy').format(widget.group.CreatedAt);

    return Container(
      // height: MediaQuery.of(context).size.height * 0.15,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: TextIcon(
                    text: groupName,
                    backgroundColor: widget.iconColor,
                  ),
                ),
              ),
              Text(
                groupName,
                style: TextStyle(fontSize: 20),
              ),
              Expanded(child: Container()),
              LoadingButton(
                  text: "Invite Code",
                  onTap: () async {
                    var res = await getInviteCode(widget.group.GroupId);
                    if (res['success']) {
                      await Clipboard.setData(
                          ClipboardData(text: res['inviteId']));
                      Fluttertoast.showToast(
                          msg: "Invite Code has been copied to your clipboard");
                    } else {
                      Fluttertoast.showToast(msg: res['message']);
                    }
                  })
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Created On: $createdOn",
                    style: TextStyle(color: Colors.white38),
                  ),
                ),
              ),
              Expanded(child: Container()),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text("👥x ${widget.group.MemberCount}"),
              ),
            ],
          ),
          SizedBox(height: 8),
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton.icon(
              onPressed: () => _toggleExpanded(),
              icon: Icon(isExpanded
                  ? Icons.expand_less_outlined
                  : Icons.expand_more_outlined),
              label: Text("Members"),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMemberList() {
    if (isLoading) {
      return const Center(child: CupertinoActivityIndicator());
    }

    if (members.isEmpty) {
      return const Center(child: Text("No members found."));
    }

    return
        // SizedBox(
        //   height: members.length * 50,
        //   child: Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child:
        ListView(
      shrinkWrap: true,
      addAutomaticKeepAlives: true,
      children: [
        ...members.map((e) => MemberCard(member: e)),
        // SizedBox(height: 64)
      ],
      // ),
      // ),
    );
  }

  void _toggleExpanded() async {
    if (isExpanded) {
      setState(() {
        isExpanded = false;
      });
    } else {
      setState(() {
        isExpanded = true;
        isLoading = true;
      });

      var res = await getMembers(widget.group.GroupId ?? '');

      setState(() {
        isLoading = false;
        if (res['success']) {
          members = res['members'];
        } else {
          Fluttertoast.showToast(msg: res['message']);
          isExpanded = false;
        }
      });
    }
  }
}
