import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
// import 'package:flutter_cupertino_datetime_picker/src/'
import 'package:intl/intl.dart';

class AddAlarmButton extends StatefulWidget {
  @override
  _AddAlarmButtonState createState() => _AddAlarmButtonState();
}

class _AddAlarmButtonState extends State<AddAlarmButton> {
  String selectedOption = 'Option 1';
  ValueNotifier<bool> IsEnabledSwitch = ValueNotifier<bool>(true);
  ValueNotifier<bool> VibrateSwitch = ValueNotifier<bool>(true);
  ValueNotifier<bool> LoopAudioSwitch = ValueNotifier<bool>(true);
  TextEditingController notificationTitleController = TextEditingController();
  TextEditingController notificationBodyController = TextEditingController();
  ValueNotifier<String> dateTimeController =
      ValueNotifier<String>("Select Date and Time");
  DateTime selectedDateTime = DateTime.now();

  @override
  void dispose() {
    IsEnabledSwitch.dispose();
    VibrateSwitch.dispose();
    notificationTitleController.dispose();
    notificationBodyController.dispose();
    super.dispose();
  }

  void _showFormDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Add Alarm'),
          content: Column(
            children: [
              CupertinoTextField(
                controller: notificationTitleController,
                placeholder: 'Alarm Title',
              ),
              SizedBox(height: 12),
              CupertinoTextField(
                controller: notificationBodyController,
                placeholder: 'Alarm Body',
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Enable Alarm?'),
                  ValueListenableBuilder<bool>(
                    valueListenable: IsEnabledSwitch,
                    builder: (context, value, child) {
                      return CupertinoSwitch(
                        value: value,
                        onChanged: (newValue) {
                          IsEnabledSwitch.value = newValue;
                        },
                      );
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Vibrate'),
                  ValueListenableBuilder<bool>(
                    valueListenable: VibrateSwitch,
                    builder: (context, value, child) {
                      return CupertinoSwitch(
                        value: value,
                        onChanged: (newValue) {
                          VibrateSwitch.value = newValue;
                        },
                      );
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Loop Audio'),
                  ValueListenableBuilder<bool>(
                    valueListenable: LoopAudioSwitch,
                    builder: (context, value, child) {
                      return CupertinoSwitch(
                        value: value,
                        onChanged: (newValue) {
                          LoopAudioSwitch.value = newValue;
                        },
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 12),
              Text('Dropdown'),
              CupertinoPicker(
                itemExtent: 32.0,
                onSelectedItemChanged: (int index) {
                  setState(() {
                    selectedOption = 'Option ${index + 1}';
                  });
                },
                children: [
                  Text('Option 1'),
                  Text('Option 2'),
                  Text('Option 3'),
                ],
              ),
              SizedBox(height: 12),
              Text("Date and Time"),
              ValueListenableBuilder(
                  valueListenable: dateTimeController,
                  builder: (context, value, child) {
                    return CupertinoButton(
                      onPressed: () async {
                        _showDialog(CupertinoDatePicker(
                          onDateTimeChanged: (res) {
                            setState(() {
                              this.selectedDateTime = res;
                              dateTimeController.value =
                                  DateFormat('dd MMMM yy hh:mm a').format(res);
                            });
                          },
                        ));
                      },
                      child: Text(
                        dateTimeController.value,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  })
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
              child: Text('Submit'),
              onPressed: () {
                final NotificationTitle = notificationTitleController.text;
                final NotificationBody = notificationBodyController.text;
                final IsEnabled = IsEnabledSwitch.value;
                final Vibrate = VibrateSwitch.value;
                final Time = selectedDateTime;
                print(Time);
                // Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showFormDialog(context),
      child: Icon(
        Icons.alarm_add_outlined,
        size: 35,
      ),
      backgroundColor: Theme.of(context).focusColor,
    );
  }
}
