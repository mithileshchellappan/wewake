import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

class MultiActionPopup extends StatefulWidget {
  final String title;
  final String subtitle;
  final String description;
  final List<CupertinoDialogAction> actions;
  const MultiActionPopup(this.title, this.subtitle, this.description,
      {required this.actions, super.key});
  @override
  State<MultiActionPopup> createState() => _MultiActionPopupState();
}

class _MultiActionPopupState extends State<MultiActionPopup> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CupertinoAlertDialog(
        title: Text(widget.title),
        content: Column(
          children: [
            Text(widget.subtitle),
            Text(
              widget.description,
              style: TextStyle(fontSize: 14),
            )
          ],
        ),
        actions: widget.actions,
      ),
    );
  }
}

class PopUpDialog extends StatefulWidget {
  final String title;
  final Function(String, bool) onOkay;
  final String yesText;
  final String noText;
  final bool showOption;
  final String optionText;

  const PopUpDialog(this.title, this.onOkay,
      {this.yesText = "OK",
      this.noText = "Cancel",
      this.showOption = false,
      this.optionText = "Option"});

  @override
  State<PopUpDialog> createState() => _PopUpDialogState();
}

class _PopUpDialogState extends State<PopUpDialog> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _textFieldController = TextEditingController();
    ValueNotifier<bool> OptionValueListenable = ValueNotifier<bool>(true);
    bool returnBool = false;
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
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(color: Colors.white),
              controller: _textFieldController,
            ),
            if (this.widget.showOption)
              Row(
                children: [
                  Text(
                    widget.optionText,
                    style: TextStyle(fontSize: 15),
                  ),
                  Expanded(child: Container()),
                  ValueListenableBuilder(
                      valueListenable: OptionValueListenable,
                      builder: (context, value, child) {
                        return CupertinoSwitch(
                            value: value,
                            onChanged: (newValue) {
                              // print(value);
                              OptionValueListenable.value = newValue;
                            });
                      })
                ],
              )
          ],
        ),
        actions: [
          CupertinoDialogAction(
            child: Text(widget.noText),
            onPressed: () async {
              Navigator.of(context).pop();
            },
          ),
          CupertinoDialogAction(
            child: Text(widget.yesText),
            onPressed: () {
              String enteredText = _textFieldController.text;
              if (enteredText.isEmpty) {
                Fluttertoast.showToast(msg: "Value can't be empty");
              } else {
                Navigator.of(context).pop();
                widget.onOkay(enteredText, OptionValueListenable.value);
              }
            },
          ),
        ],
      ),
    );
  }
}
