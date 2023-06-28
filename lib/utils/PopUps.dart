import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class YNPopUp extends StatelessWidget {
  final String title;
  final Function() onLogout;
  final String yesText;
  final String noText;
  const YNPopUp(this.title, this.onLogout,
      {this.yesText = "Yes", this.noText = "No"});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CupertinoAlertDialog(
        title: Text(title),
        actions: [
          CupertinoDialogAction(
            child: Text(noText),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          CupertinoDialogAction(
            child: Text(yesText),
            onPressed: onLogout,
            isDestructiveAction: true,
          ),
        ],
      ),
    );
  }
}

class PopUpDialog extends StatelessWidget {
  final String title;
  final Function(String) onOkay;
  final String yesText;
  final String noText;

  const PopUpDialog(
    this.title,
    this.onOkay, {
    this.yesText = "OK",
    this.noText = "Cancel",
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController _textFieldController = TextEditingController();

    return Center(
      child: CupertinoAlertDialog(
        title: Text(
          title,
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
            child: Text(noText),
            onPressed: () async {
              Navigator.of(context).pop();
            },
          ),
          CupertinoDialogAction(
            child: Text(yesText),
            onPressed: () {
              String enteredText = _textFieldController.text;
              Navigator.of(context).pop();
              onOkay(enteredText);
            },
          ),
        ],
      ),
    );
  }
}
