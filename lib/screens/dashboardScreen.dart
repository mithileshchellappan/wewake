import 'package:alarm_test/utils/sharedPref.dart';
import 'package:flutter/cupertino.dart';

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
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        automaticallyImplyLeading: true,
        middle: FutureBuilder<String?>(
          future: userNameFuture,
          builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('WeWake');
            } else {
              final userName = snapshot.data ?? 'WeWake';
              return Text('Hello $userName');
            }
          },
        ),
      ),
      child: CupertinoTabScaffold(
        resizeToAvoidBottomInset: true,
        tabBar: CupertinoTabBar(
          height: 70,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.group), label: "Groups"),
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.alarm), label: "Alarms"),
          ],
        ),
        tabBuilder: (BuildContext context, int index) {
          return CupertinoTabView(
            builder: (BuildContext context) {
              return Center(
                child: Text('Content of tab $index'),
              );
            },
          );
        },
      ),
    );
  }
}
