import 'package:alarm_test/utils/TextIcon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../models/Group.dart';

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
          children: [getTopDash(context)],
        ),
      ),
    );
  }

  Widget getTopDash(BuildContext context) {
    String groupName = widget.group.GroupName ?? "Group Name";
    String createdOn = DateFormat('dd MMMM yy').format(widget.group.CreatedAt);
    return Container(
      height: MediaQuery.of(context).size.height * 0.15,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20))),
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
                    )),
              ),
              Text(
                groupName,
                style: TextStyle(fontSize: 20),
              ),
              Expanded(child: Container()),
              Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text("👥x ${widget.group.MemberCount}"))
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Created On: $createdOn",
                    style: TextStyle(color: Colors.white38))),
          ),
          // if(isExpanded) getMemberList(),
          Expanded(child: SizedBox()),
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton.icon(
                onPressed: () => {setState(() => isExpanded = !isExpanded)},
                icon: Icon(!isExpanded
                    ? Icons.expand_more_outlined
                    : Icons.expand_less_outlined),
                label: Text(!isExpanded ? "Members" : "")),
          ),
        ],
      ),
    );
  }
  // List<Widget> getMemberList(){

  // }
}
