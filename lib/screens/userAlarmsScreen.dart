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

  @override
  void initState() {
    super.initState();
    setAlarmPerGroup();
  }

  var alarmProvider;
  var groupProvider;
  Future<void> setAlarmPerGroup() async {
    alarmProvider = Provider.of<AlarmProvider>(context, listen: false);
    late List<Alarm> alarms = alarmProvider?.alarms ?? [];
    print(alarms);
    for (int i = 0; i < alarms.length; i++) {
      String groupName = alarms[i].GroupName ?? "Undefined Group";
      if (groupedAlarms.containsKey(groupName)) {
        if (alarms[i].IsEnabled &&
            alarms[i].Time.compareTo(DateTime.now()) > 0) {
          print(alarms[i].Time);
          groupedAlarms[groupName]!.add(alarms[i]);
        }
      } else {
        if (alarms[i].IsEnabled &&
            alarms[i].Time.compareTo(DateTime.now()) > 0) {
          groupedAlarms[groupName] = [alarms[i]];
        }
      }
    }
  }

  Group getGroup(String groupId) {
    List<Group> groups = groupProvider.groups ?? [];
    print("groups" + groups.toString());
    return groups.where((element) => element.GroupId == groupId).first;
  }

  @override
  Widget build(BuildContext context) {
    alarmProvider = Provider.of<AlarmProvider>(context, listen: true);
    groupProvider = Provider.of<GroupProvider>(context, listen: true);

    return Scaffold(
        appBar: CupertinoNavigationBar(
          brightness: Theme.of(context).brightness,
          backgroundColor: Theme.of(context).backgroundColor,
          transitionBetweenRoutes: false,
          automaticallyImplyLeading: false,
          leading: const Padding(
            padding: EdgeInsets.only(top: 15.0),
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

                    return AlarmCard(
                      alarm: alarm,
                      isAdmin: false,
                      alarmProvider: alarmProvider,
                      allowActions: false,
                    );
                  },
                ),
              ],
            );
          },
        ));
  }
}
