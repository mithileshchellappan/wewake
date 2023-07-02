import 'package:alarm_test/models/Group.dart';
import 'package:alarm_test/screens/chatScreen.dart';
import 'package:alarm_test/screens/groupViewScreen.dart';
import 'package:alarm_test/screens/userAlarmsScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GroupDashboardScreen extends StatefulWidget {
  Group group;
  Color iconColor;
  GroupDashboardScreen({required this.group, required this.iconColor});
  @override
  _GroupDashboardScreenState createState() => _GroupDashboardScreenState();
}

class _GroupDashboardScreenState extends State<GroupDashboardScreen> {
  List<dynamic> serverAlarms = [];

  int _navBarIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _navBarIndex == 0
            ? GroupViewScreen(
                group: widget.group,
                iconColor: widget.iconColor,
              )
            : ChatScreen(),
        bottomNavigationBar: CupertinoTabBar(
          currentIndex: _navBarIndex,
          onTap: (value) => {
            setState(() {
              _navBarIndex = value;
            })
          },
          backgroundColor: Colors.black,
          height: 60,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.alarm), label: "Alarms"),
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.chat_bubble_2), label: "Chat"),
          ],
        ),
      ),
    );
  }
}



// class FloatingAction extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         Container(
//           padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
//           margin: EdgeInsets.only(bottom: 70),
//           child: Transform.rotate(angle: math.pi / 1, child: Container()),
//         ),
//       ],
//     );
//   }
// }
