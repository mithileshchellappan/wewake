import 'package:alarm_test/models/Group.dart';
import 'package:alarm_test/screens/groupViewScreen.dart';
import 'package:alarm_test/utils/helpers.dart';
import 'package:alarm_test/widgets/cards/alarmCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../models/Alarm.dart';
import '../providers/alarmsProvider.dart';
import '../providers/groupProvider.dart';

class UserAlarmsScreen extends StatefulWidget {
  UserAlarmsScreen({super.key});

  @override
  State<UserAlarmsScreen> createState() => _UserAlarmsScreenState();
}

class _UserAlarmsScreenState extends State<UserAlarmsScreen> {
  Map<String, List<Alarm>> groupedAlarms = {};
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  List<Alarm> focusedAlarms = [];
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  var alarmProvider;
  var groupProvider;
  var tasksProvider;

  // @override
  // void initState() {
  //   super.initState();
  // }

  List<dynamic> _getEventsForRange(DateTime start) {
    alarmProvider = Provider.of<AlarmProvider>(context, listen: false);
    List<Alarm> alarms = alarmProvider!.alarms ?? [];
    focusedAlarms =
        alarms.where((element) => element.Time.day == start.day).toList();
    return focusedAlarms;
  }

  Group getGroup(String groupId) {
    List<Group> groups = groupProvider.groups ?? [];
    print("groups" + groups.toString());
    return groups.where((element) => element.GroupId == groupId).first;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _rangeSelectionMode = RangeSelectionMode.toggledOff;
      // setAlarmPerGroup(selectedDay);
    });
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              TableCalendar(
                  firstDay: DateTime(2023, 1, 1),
                  lastDay: DateTime(2024, 1, 1),
                  currentDay: DateTime.now(),
                  focusedDay: _focusedDay,
                  eventLoader: _getEventsForRange,
                  onDaySelected: _onDaySelected,
                  rangeSelectionMode: _rangeSelectionMode,
                  calendarFormat: _calendarFormat,
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day)),
              ListView.builder(
                shrinkWrap: true,
                itemCount: alarmProvider.alarms
                    .where((element) => element.Time.day == _focusedDay.day)
                    .length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  List<Alarm> alarm = alarmProvider.alarms
                      .where((element) => element.Time.day == _focusedDay.day)
                      .toList();
                  if (alarm[index] != null) {
                    return AlarmCard(
                      alarm: alarm[index],
                      memberCount: 0,
                      isAdmin: false,
                      alarmProvider: alarmProvider,
                      allowActions: false,
                    );
                  }
                },
              ),
            ],
          ),
        ));
  }
}

  // Future<void> setAlarmPerGroup() async {
  //   alarmProvider = Provider.of<AlarmProvider>(context, listen: false);
  //   List<Alarm> alarms = alarmProvider!.alarms ?? [];
  //   print(alarms);
  //   for (int i = 0; i < alarms.length; i++) {
  //     eventAlarms.add(CalendarEventData(
  //         title: alarms[i].NotificationTitle, date: alarms[i].Time));

  //     // String groupName = alarms[i].GroupName ?? "Undefined Group";
  //     // if (groupedAlarms.containsKey(groupName)) {
  //     //   if (alarms[i].IsEnabled &&
  //     //       alarms[i].Time.compareTo(DateTime.now()) > 0) {
  //     //     print(alarms[i].Time);
  //     //     groupedAlarms[groupName]!.add(alarms[i]);
  //     //   }
  //     // } else {
  //     //   if (alarms[i].IsEnabled &&
  //     //       alarms[i].Time.compareTo(DateTime.now()) > 0) {
  //     //     groupedAlarms[groupName] = [alarms[i]];
  //     //   }
  //     // }
  //   }
  // }

  