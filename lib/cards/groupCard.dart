import 'package:alarm_test/screens/groupViewScreen.dart';
import 'package:alarm_test/utils/TextIcon.dart';
import 'package:alarm_test/utils/helpers.dart';
import 'package:flutter/material.dart';
import '../models/Group.dart';

class GroupCard extends StatelessWidget {
  final Group group;

  GroupCard({required this.group});
  final iconColor = getRandomDarkColor();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.0),
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
            trailing: Text(group.CreatedAt.toLocal().toString()),
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
    );
  }
}
