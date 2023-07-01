import 'package:alarm_test/api/alarm.dart';
import 'package:alarm_test/constants/app.dart';
import 'package:alarm_test/providers/alarmsProvider.dart';
import 'package:alarm_test/utils/alarmService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:cupertino_text_button/cupertino_text_button.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import '../../models/Alarm.dart';
import '../../models/Group.dart';

class AddAlarmButton extends StatefulWidget {
  final Function callback;
  Group group;
  AddAlarmButton({required this.callback, required this.group});
  @override
  _AddAlarmButtonState createState() => _AddAlarmButtonState();
}

class _AddAlarmButtonState extends State<AddAlarmButton> {
  TextEditingController notificationTitleController = TextEditingController();
  TextEditingController notificationBodyController = TextEditingController();
  ValueNotifier<bool> IsEnabledSwitch = ValueNotifier<bool>(true);
  ValueNotifier<bool> VibrateSwitch = ValueNotifier<bool>(true);
  ValueNotifier<bool> LoopAudioSwitch = ValueNotifier<bool>(false);
  ValueNotifier<Map<String, String>> alarmToneNotifier =
      ValueNotifier<Map<String, String>>(alarmTones[0]);
  ValueNotifier<String> dateTimeNotifier =
      ValueNotifier<String>("Select Date and Time");
  DateTime selectedDateTime = DateTime.now();
  bool _isPlaying = false;
  final player = AudioPlayer();
  late Alarm alarm;
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
                style: TextStyle(color: Colors.white),
                controller: notificationTitleController,
                textCapitalization: TextCapitalization.sentences,
                placeholder: 'Alarm Title',
              ),
              SizedBox(height: 12),
              CupertinoTextField(
                style: TextStyle(color: Colors.white),
                controller: notificationBodyController,
                textCapitalization: TextCapitalization.sentences,
                placeholder: 'Alarm Body',
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Enable Alarm',
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
                  }),
              Text("Long Press on Alarm Tone to play",
                  style: TextStyle(fontSize: 12))
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
              onPressed: () async {
                final NotificationTitle = notificationTitleController.text;
                final NotificationBody = notificationBodyController.text;
                final IsEnabled = IsEnabledSwitch.value;
                final Vibrate = VibrateSwitch.value;
                final LoopAudio = LoopAudioSwitch.value;
                final Time = selectedDateTime;
                final InternalAudioFile = alarmToneNotifier.value['location'];
                //         var req = {
                //   "groupId": widget.groupId,
                //   "time": selectedDateTime.toString(),
                //   "isEnabled": IsEnabled,
                //   "loopAudio": LoopAudio,
                //   "vibrate": Vibrate,
                //   "notificationTitle": NotificationTitle,
                //   "notificationBody": NotificationBody,
                //   "internalAudioFile": InternalAudioFile,
                //   "useExternaAudio": alarm.UseExternalAudio,
                //   "audioUrl": alarm.AudioURL
                // }
                print(Time);
                player.stop();
                player.dispose();
                if (NotificationTitle.isEmpty || NotificationBody.isEmpty) {
                  Fluttertoast.showToast(msg: "Please enter all fields.");
                } else if (dateTimeNotifier.value == "Select Date and Time") {
                  Fluttertoast.showToast(
                      msg: "Please select date and time for alarm.");
                } else {
                  alarm = Alarm(
                      widget.group.GroupId,
                      NotificationTitle,
                      NotificationBody,
                      IsEnabled,
                      Vibrate,
                      LoopAudio,
                      Time,
                      InternalAudioFile,
                      widget.group.GroupName);
                  print(alarm.Time);
                  var res = await addAlarm(alarm);
                  if (res['success']) {
                    await AlarmService.setAlarm(res['alarm']);
                    final alarmProvider =
                        Provider.of<AlarmProvider>(context, listen: false);
                    Alarm resAlarm = res['alarm'];
                    resAlarm.GroupName = widget.group.GroupName;
                    alarmProvider.appendAlarm(resAlarm);
                    widget.callback(res['alarm']);
                    Fluttertoast.showToast(msg: "Created Alarm Successfully");
                    Navigator.of(context).pop();
                  } else {
                    Fluttertoast.showToast(msg: res['message']);
                    Navigator.of(context).pop();
                  }
                }
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
