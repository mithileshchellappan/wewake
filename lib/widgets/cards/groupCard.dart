import 'package:alarm_test/api/group.dart';
import 'package:alarm_test/providers/alarmsProvider.dart';
import 'package:alarm_test/providers/groupProvider.dart';
import 'package:alarm_test/providers/userProvider.dart';
import 'package:alarm_test/screens/groupViewScreen.dart';
import 'package:alarm_test/utils/PopUps.dart';
import 'package:alarm_test/utils/TextIcon.dart';
import 'package:alarm_test/utils/alarmService.dart';
import 'package:alarm_test/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../models/Group.dart';

class GroupCard extends StatelessWidget {
  final Group group;
  final String userId;
  final GroupProvider groupProvider;
  GroupCard({
    required this.group,
    required this.userId,
    required this.groupProvider,
  });
  final iconColor = getRandomDarkColor();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: SwipeActionCell(
        trailingActions: <SwipeAction>[
          SwipeAction(
              backgroundRadius: 5,
              title: group.IsAdmin ? "Delete" : "Leave",
              onTap: (CompletionHandler handler) async {
                showDialog(
                    context: context,
                    builder: (context) => YNPopUp(
                            "${group.IsAdmin ? "Delete" : "Leave"} Group?",
                            yesText: group.IsAdmin ? "Delete" : "Leave",
                            () async {
                          var res;
                          if (group.IsAdmin) {
                            res = await deleteGroup(group.GroupId);
                          } else {
                            res = await removeMember(group.GroupId, userId);
                          }
                          if (res['success']) {
                            Fluttertoast.showToast(
                                msg: "Left ${group.GroupName}");
                            groupProvider.removeGroup(group);
                            var alarmProvider = Provider.of<AlarmProvider>(
                                context,
                                listen: false);
                            var alarms = alarmProvider
                                .getAlarmsWithGroupId(group.GroupId);
                            AlarmService.cancelMultipleAlarms(alarms);
                            alarmProvider
                                .removeAlarmsWithGroupId(group.GroupId);
                          } else {
                            Fluttertoast.showToast(msg: res['message']);
                          }
                          Navigator.of(context).pop();
                        }));
              },
              color: Colors.red),
        ],
        key: ObjectKey(group.GroupId),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 2),
            child: ListTile(
              leading: TextIcon(
                  text: group.GroupName?.trim() ?? 'Group',
                  backgroundColor: iconColor),
              title: Text(group.GroupName ?? ''),
              subtitle: Text('👥x ${group.MemberCount ?? 0}'),
              trailing: Text(group.IsAdmin ? "👑" : ""),
              onTap: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GroupViewScreen(
                              group: group,
                              iconColor: iconColor,
                            )))
              },
            ),
          ),
        ),
      ),
    );
  }
}
