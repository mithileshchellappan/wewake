import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({Key? key}) : super(key: key);

  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SpeedDial(
        spacing: 5,
        icon: Icons.expand_less,
        activeIcon: Icons.expand_more,
        iconTheme: IconThemeData(size: 50),
        animationCurve: Curves.elasticInOut,
        backgroundColor: Theme.of(context).focusColor,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.add),
            label: 'Create Group',
            onTap: () => showDialog(
                context: context,
                builder: (context) =>
                    PopUpDialog("Enter Group Name", (res) => {print(res)})),
          ),
          SpeedDialChild(
              child: const Icon(Icons.group_add_outlined), label: 'Join Group'),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class PopUpDialog extends StatefulWidget {
  final String title;
  final Function(String) onOkay;

  const PopUpDialog(this.title, this.onOkay);

  @override
  _PopUpDialogState createState() => _PopUpDialogState();
}

class _PopUpDialogState extends State<PopUpDialog> {
  TextEditingController _textFieldController = TextEditingController();

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CupertinoAlertDialog(
        title: Text(
          widget.title,
          style: TextStyle(fontWeight: FontWeight.normal),
        ),
        content: Column(
          children: [
            SizedBox(height: 20),
            CupertinoTextField(
              style: TextStyle(color: Colors.white),
              controller: _textFieldController,
            ),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          CupertinoDialogAction(
            child: Text('OK'),
            onPressed: () {
              String enteredText = _textFieldController.text;
              Navigator.of(context).pop();
              widget.onOkay(enteredText);
            },
          ),
        ],
      ),
    );
  }
}
