import 'package:alarm_test/api/group.dart';
import 'package:alarm_test/utils/PopUps.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../models/Member.dart';

class MemberCard extends StatelessWidget {
  Member member;
  final Function callback;
  MemberCard({super.key, required this.member, required this.callback});
  @override
  Widget build(BuildContext context) {
    String memberName = member.MemberName ?? "Member";
    String name = member.IsAdmin ? "${memberName} 👑" : memberName;
    return Container(
      child: InkWell(
        onLongPress: () {
          showDialog(
              context: context,
              builder: (context) =>
                  YNPopUp("Remove ${member.MemberName}?", () async {
                    if (member.IsAdmin) {
                      Fluttertoast.showToast(msg: "Cannot remove admin");
                      Navigator.of(context).pop();
                      return;
                    }
                    var res =
                        await removeMember(member.GroupId, member.MemberId);
                    if (res['success']) {
                      Fluttertoast.showToast(msg: res['message'] ?? 'message');
                      res['member'] = member;
                      callback(res);
                    } else {
                      Fluttertoast.showToast(msg: res['message']);
                    }
                    Navigator.of(context).pop();
                  }));
        },
        child: Card(
            margin: EdgeInsets.symmetric(vertical: 3),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
              child: Text(
                "$name  ${member.MemberId}",
                style: TextStyle(fontSize: 20),
              ),
            )),
      ),
    );
  }
}
