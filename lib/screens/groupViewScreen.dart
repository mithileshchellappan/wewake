import 'package:alarm_test/api/group.dart';
import 'package:alarm_test/cards/memberCard.dart';
import 'package:alarm_test/utils/TextIcon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getTopDash(context),
            if (isExpanded) buildMemberList(),
          ],
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
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text("👥x ${widget.group.MemberCount}"),
              ),
            ],
          ),
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

  Widget buildMemberList() {
    if (isLoading) {
      return Expanded(child: Center(child: CupertinoActivityIndicator()));
    }

    if (members.isEmpty) {
      return Expanded(child: Center(child: Text("No members found.")));
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          addAutomaticKeepAlives: true,
          children: [
            ...members.map((e) => MemberCard(member: e)),
            SizedBox(height: 64)
          ],
        ),
      ),
    );
  }
}
