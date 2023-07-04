import 'dart:async';

import 'package:alarm_test/api/alarm.dart';
import 'package:alarm_test/providers/alarmsProvider.dart';
import 'package:alarm_test/providers/userProvider.dart';
import 'package:alarm_test/utils/alarmService.dart';
import 'package:alarm_test/widgets/taskList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import '../../models/Alarm.dart';

class AlarmCard extends StatefulWidget {
  final Alarm alarm;
  final bool isAdmin;
  final AlarmProvider alarmProvider;
  AlarmCard(
      {required this.alarm,
      required this.isAdmin,
      Key? key,
      required this.alarmProvider})
      : super(key: key);

  @override
  _AlarmCardState createState() => _AlarmCardState();
}

class _AlarmCardState extends State<AlarmCard> {
  static Timer? _timer;
  static StreamController<DateTime> _timeController =
      StreamController<DateTime>.broadcast();
  @override
  void initState() {
    super.initState();
    !_timeController.isClosed ? _timeController.add(DateTime.now()) : null;
    _timer ??= Timer.periodic(Duration(seconds: 10), (_) {
      _timeController.add(DateTime.now());
    });
  }

  List<String> tasks = ["task 1", "task 2", "task 3"];
  static String formatTimeDifference(Duration difference, widget) {
    if (difference.inSeconds < 60 && difference.inSeconds > 0) {
      return "In ${difference.inSeconds} seconds";
    } else if (difference.inMinutes < 60) {
      if (difference.inMinutes < 0) {
        widget.alarm.IsEnabled = false;
        return "Alarm Expired";
      }

      return "In ${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'}";
    } else if (difference.inHours < 24) {
      if (difference.inHours < 0) {
        widget.alarm.IsEnabled = false;
        return "Alarm Expired";
      }
      return "In ${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'}";
    } else if (difference.inDays < 30) {
      if (difference.inDays < 0) {
        widget.alarm.IsEnabled = false;
        return "Alarm Expired";
      }
      return "In ${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'}";
    } else {
      int months = (difference.inDays / 30).floor();
      if (months < 0) {
        widget.alarm.IsEnabled = false;
        return "Alarm Expired";
      }
      return "In $months ${months == 1 ? 'month' : 'months'}";
    }
  }

  @override
  void dispose() async {
    _timer?.cancel();
    _timeController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? audioLink = widget.alarm.InternalAudioFile;
    // AlarmProvider alarmProvider = Provider.of
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    return Padding(
      padding: EdgeInsets.only(top: 2),
      child: SwipeActionCell(
        key: ObjectKey(widget.alarm.AlarmAppId),
        leadingActions: [
          SwipeAction(
              icon: Icon(Icons.exit_to_app),
              color: Colors.green,
              backgroundRadius: 5,
              onTap: (CompletionHandler handler) async {},
              title: "  Opt Out"),
        ],
        trailingActions: (widget.isAdmin ||
                widget.alarm.CreatedBy == userProvider.user!.UserId)
            ? [
                SwipeAction(
                    icon: const Icon(Icons.delete_forever),
                    backgroundRadius: 5,
                    onTap: (CompletionHandler handler) async {
                      var res = await deleteAlarm(widget.alarm.AlarmId);
                      print(res);
                      if (res['success']) {
                        AlarmService.cancelAlarm(widget.alarm.AlarmAppId);
                        widget.alarmProvider.removeAlarm(widget.alarm);
                        Fluttertoast.showToast(msg: "Delete Alarm!");
                      } else {
                        Fluttertoast.showToast(msg: res['message']);
                      }
                    },
                    title: "  Delete"),
              ]
            : [],
        child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 8, right: 8),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Theme.of(context).focusColor,
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Text(
                          widget.alarm.NotificationTitle,
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      Expanded(child: Container()),
                      PlayButton(
                        url: audioLink ?? "nokia.mp3",
                        isExpanded: true,
                      ),
                      SizedBox(width: 5),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text(
                      widget.alarm.NotificationBody,
                      style: TextStyle(fontSize: 13, color: Colors.white70),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text(
                      DateFormat('dd MMMM yy \nhh:mm a')
                          .format(widget.alarm.Time),
                      style: TextStyle(fontSize: 11, color: Colors.white30),
                    ),
                  ),
                  // Text(widget.alarm.AlarmAppId.toString()),
                  SizedBox(height: 10),
                  bottomBar(),
                  TaskList(tasks: tasks),
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5))),
                      child: const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Icon(Icons.add), Text("Add New Task")],
                        ),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget bottomBar() {
    return LayoutBuilder(
      builder: ((context, constraints) => Container(
            width: constraints.maxWidth,
            padding: EdgeInsets.only(top: 3),
            decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5))),
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Text((widget.alarm.IsEnabled &&
                        DateTime.now().compareTo(widget.alarm.Time) <= 0)
                    ? "🟢"
                    : "🔴"),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () => Fluttertoast.showToast(
                    msg: widget.alarm.Vibrate
                        ? "Vibration is Enabled."
                        : "Vibration is Disabled.",
                  ),
                  child: Icon(
                    Icons.vibration,
                    color: widget.alarm.Vibrate
                        ? Colors.white
                        : Theme.of(context).disabledColor,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () => Fluttertoast.showToast(
                    msg: widget.alarm.LoopAudio
                        ? "Audio Loop is Enabled."
                        : "Audio Loop is Disabled.",
                  ),
                  child: Icon(
                    Icons.loop_sharp,
                    color: widget.alarm.LoopAudio
                        ? Colors.white
                        : Theme.of(context).disabledColor,
                  ),
                ),
                Expanded(child: Container()),
                StreamBuilder<DateTime>(
                    stream: _timeController.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          formatTimeDifference(
                              widget.alarm.Time.difference(snapshot.data!),
                              widget),
                          style: TextStyle(fontSize: 11, color: Colors.white),
                        );
                      } else {
                        return Text(
                            formatTimeDifference(
                                widget.alarm.Time.difference(DateTime.now()),
                                widget),
                            style:
                                TextStyle(fontSize: 11, color: Colors.white));
                      }
                    }),
                SizedBox(
                  width: 10,
                )
              ],
            ),
          )),
    );
  }
}

class PlayButton extends StatefulWidget {
  String url;
  bool isExpanded;
  PlayButton({super.key, required this.url, this.isExpanded = true});

  @override
  State<PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> {
  bool _isPlaying = false;
  final player = AudioPlayer();

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () async {
          await player.setAsset("assets/${widget.url}");
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
            if (event.processingState == ProcessingState.completed) {
              setState(() {
                _isPlaying = false;
              });
            }
          });
        },
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding:
                  widget.isExpanded ? EdgeInsets.all(2.0) : EdgeInsets.all(0.0),
              child: Row(
                children: [
                  Icon(
                    _isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                    color: Colors.black,
                  ),
                  if (widget.isExpanded) SizedBox(width: 5),
                  if (widget.isExpanded)
                    Text(
                      _isPlaying ? "Pause" : "Play",
                      style: TextStyle(color: Colors.black),
                    ),
                  if (widget.isExpanded) SizedBox(width: 5),
                ],
              ),
            )));
  }
}
