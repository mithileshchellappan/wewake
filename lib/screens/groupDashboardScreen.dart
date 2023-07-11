import 'package:alarm_test/models/Group.dart';
import 'package:alarm_test/providers/groupProvider.dart';
import 'package:alarm_test/screens/chatScreen.dart';
import 'package:alarm_test/screens/groupViewScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupDashboardScreen extends StatefulWidget {
  final String groupId;
  final Color iconColor;
  const GroupDashboardScreen(
      {super.key, required this.groupId, required this.iconColor});
  @override
  _GroupDashboardScreenState createState() => _GroupDashboardScreenState();
}

class _GroupDashboardScreenState extends State<GroupDashboardScreen> {
  int _navBarIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GroupProvider groupProvider =
        Provider.of<GroupProvider>(context, listen: true);
    return SafeArea(
      child: Scaffold(
        body: _navBarIndex == 0
            ? GroupViewScreen(
                group: groupProvider.getGroup(widget.groupId),
                iconColor: widget.iconColor,
              )
            : ChatScreen(groupProvider.getGroup(widget.groupId).GroupId),
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
