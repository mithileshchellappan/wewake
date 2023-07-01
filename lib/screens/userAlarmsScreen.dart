import 'package:alarm_test/models/Group.dart';
import 'package:alarm_test/screens/groupViewScreen.dart';
import 'package:alarm_test/widgets/cards/alarmCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/Alarm.dart';
import '../providers/alarmsProvider.dart';
import '../providers/groupProvider.dart';
import '../utils/helpers.dart';

class UserAlarmsScreen extends StatefulWidget {
  UserAlarmsScreen({super.key});

  @override
  State<UserAlarmsScreen> createState() => _UserAlarmsScreenState();
}

class _UserAlarmsScreenState extends State<UserAlarmsScreen> {
  Map<String, List<Alarm>> groupedAlarms = {};
  var groupProvider;
  @override
  void initState() {
    super.initState();
    setAlarmPerGroup();
    groupProvider = Provider.of<GroupProvider>(context, listen: false);
  }

  Future<void> setAlarmPerGroup() async {
    final alarmProvider = Provider.of<AlarmProvider>(context, listen: false);
    late List<Alarm> alarms = alarmProvider.alarms ?? [];
    for (int i = 0; i < alarms.length; i++) {
      String groupName = alarms[i].GroupName ?? "Undefined Group";
      if (groupedAlarms.containsKey(groupName)) {
        groupedAlarms[groupName]!.add(alarms[i]);
      } else {
        groupedAlarms[groupName] = [alarms[i]];
      }
    }
    print(groupedAlarms['First']?[0].GroupId);
  }

  Group getGroup(String groupId) {
    List<Group> groups = groupProvider.groups ?? [];
    return groups.where((element) => element.GroupId == groupId).first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CupertinoNavigationBar(
          brightness: Theme.of(context).brightness,
          backgroundColor: Theme.of(context).backgroundColor,
          transitionBetweenRoutes: false,
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Text(
              "Your Alarms",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        body: ListView.builder(
          itemCount: groupedAlarms.length,
          itemBuilder: (context, index) {
            String groupName = groupedAlarms.keys.elementAt(index);
            List<Alarm> alarms = groupedAlarms[groupName]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(width: 5),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GroupViewScreen(
                                group: getGroup(
                                    groupedAlarms[groupName]![0].GroupId!),
                                iconColor: getRandomDarkColor(),
                              )),
                    ),
                    child: Row(
                      children: [
                        Text(
                          groupName.toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Icon(Icons.arrow_right)
                      ],
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: alarms.length,
                  itemBuilder: (context, index) {
                    Alarm alarm = alarms[index];

                    return AlarmCard(alarm: alarm);
                  },
                ),
              ],
            );
          },
        ));
  }
}
