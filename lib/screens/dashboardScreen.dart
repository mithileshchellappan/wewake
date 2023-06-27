import 'package:alarm_test/api/group.dart';
import 'package:alarm_test/utils/sharedPref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  static String route = "dashboardScreen";

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Future<String?>? userNameFuture;

  @override
  void initState() {
    super.initState();
    userNameFuture = getUserName();
  }

  Future<String?> getUserName() async {
    return SharedPreferencesHelper.getString('userName');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingAction(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: CupertinoTabBar(
        height: 60,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.group), label: "Groups"),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.alarm), label: "Alarms"),
        ],
      ),
    );
  }
}

class FloatingAction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
          margin: EdgeInsets.only(bottom: 70),
          child: FloatingActionButton(
            onPressed: () => getUserGroups(),
            child: Icon(
              Icons.add,
              size: 35,
            ),
            backgroundColor: Theme.of(context).focusColor,
          ),
        ),
      ],
    );
  }
}
