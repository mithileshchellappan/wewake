import 'package:flutter/cupertino.dart';

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
