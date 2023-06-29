import 'package:alarm_test/constants/app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cupertino_text_button/cupertino_text_button.dart';
import 'package:just_audio/just_audio.dart';

class AddAlarmButton extends StatefulWidget {
  @override
  _AddAlarmButtonState createState() => _AddAlarmButtonState();
}

class _AddAlarmButtonState extends State<AddAlarmButton> {
  TextEditingController notificationTitleController = TextEditingController();
  TextEditingController notificationBodyController = TextEditingController();
  ValueNotifier<bool> IsEnabledSwitch = ValueNotifier<bool>(true);
  ValueNotifier<bool> VibrateSwitch = ValueNotifier<bool>(true);
  ValueNotifier<bool> LoopAudioSwitch = ValueNotifier<bool>(true);
  ValueNotifier<Map<String, String>> alarmToneNotifier =
      ValueNotifier<Map<String, String>>(alarmTones[0]);
  ValueNotifier<String> dateTimeNotifier =
      ValueNotifier<String>("Select Date and Time");
  DateTime selectedDateTime = DateTime.now();
  bool _isPlaying = false;
  final player = AudioPlayer();

  @override
  void dispose() {
    IsEnabledSwitch.dispose();
    VibrateSwitch.dispose();
    alarmToneNotifier.dispose();
    dateTimeNotifier.dispose();
    notificationTitleController.dispose();
    notificationBodyController.dispose();
    player.dispose();
    super.dispose();
  }

  void _showFormDialog(BuildContext context) {
    print(alarmTones);
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
                  const Text(
                    'Enable Alarm?',
                    style: TextStyle(fontSize: 18),
                  ),
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
                  const Text(
                    'Vibrate',
                    style: TextStyle(fontSize: 18),
                  ),
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
                  const Text(
                    'Loop Audio',
                    style: TextStyle(fontSize: 18),
                  ),
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
              SizedBox(height: 5),
              ValueListenableBuilder(
                  valueListenable: alarmToneNotifier,
                  builder: (context, value, child) {
                    return CupertinoTextButton(
                        color: Theme.of(context).highlightColor,
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                        onLongPress: () async {
                          await player.setAsset(
                              "assets/${alarmToneNotifier.value['location']}");
                          if (player.playing) {
                            await player.stop();
                            setState(() {
                              _isPlaying = false;
                            });
                          } else {
                            setState(() {
                              _isPlaying = true;
                            });
                            await player.play();
                          }
                          player.playerStateStream.listen((event) {
                            if (event.processingState ==
                                ProcessingState.completed) {
                              setState(() {
                                _isPlaying = false;
                              });
                            }
                          });
                        },
                        onTap: () => _showDialog(
                              CupertinoPicker(
                                itemExtent: 32.0,
                                onSelectedItemChanged: (int index) {
                                  alarmToneNotifier.value = alarmTones[index];
                                },
                                children: [
                                  ...alarmTones
                                      .map((e) => Text(e['name'] ?? 'Tone'))
                                ],
                              ),
                            ),
                        text: "Alarm Tone: ${alarmToneNotifier.value['name']}");
                  }),
              ValueListenableBuilder(
                  valueListenable: dateTimeNotifier,
                  builder: (context, value, child) {
                    return CupertinoButton(
                      onPressed: () async {
                        _showDialog(CupertinoDatePicker(
                          minimumDate: DateTime.now(),
                          showDayOfWeek: true,
                          onDateTimeChanged: (res) {
                            setState(() {
                              this.selectedDateTime = res;
                              dateTimeNotifier.value =
                                  DateFormat('dd MMMM yy hh:mm a').format(res);
                            });
                          },
                        ));
                      },
                      child: Text(
                        dateTimeNotifier.value,
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
                player.stop();
                player.dispose();
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
                player.stop();
                player.dispose();
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
