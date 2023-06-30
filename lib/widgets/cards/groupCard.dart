import 'package:alarm_test/screens/groupViewScreen.dart';
import 'package:alarm_test/utils/TextIcon.dart';
import 'package:alarm_test/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import '../../models/Group.dart';

class GroupCard extends StatelessWidget {
  final Group group;
  final Key key;
  GroupCard({required this.group, required this.key});
  final iconColor = getRandomDarkColor();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: SwipeActionCell(
        trailingActions: <SwipeAction>[
          SwipeAction(
              backgroundRadius: 5,
              title: "delete",
              onTap: (CompletionHandler handler) async {},
              color: Colors.red),
        ],
        key: key,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 2),
            child: ListTile(
              leading: TextIcon(
                  text: group.GroupName ?? 'Group', backgroundColor: iconColor),
              title: Text(group.GroupName ?? ''),
              subtitle: Text('👥x ${group.MemberCount ?? 0}'),
              trailing: Text(group.CreatedAt.toString()),
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