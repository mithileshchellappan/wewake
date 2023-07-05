import 'dart:async';

import 'package:alarm_test/api/alarm.dart';
import 'package:alarm_test/api/task.dart';
import 'package:alarm_test/constants/app.dart';
import 'package:alarm_test/models/Task.dart';
import 'package:alarm_test/providers/alarmsProvider.dart';
import 'package:alarm_test/providers/userProvider.dart';
import 'package:alarm_test/utils/alarmService.dart';
import 'package:alarm_test/widgets/taskTextField.dart';
import 'package:flutter/cupertino.dart';
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
  int memberCount;
  bool allowActions;
  AlarmCard(
      {required this.alarm,
      required this.isAdmin,
      required this.alarmProvider,
      required this.memberCount,
      Key? key,
      this.allowActions = true})
      : super(key: key);

  @override
  _AlarmCardState createState() => _AlarmCardState();
}

enum UpdateTypes { update, remove, insert }

class _AlarmCardState extends State<AlarmCard> {
  static Timer? _timer;
  List<Task> tasks = [];
  bool showTasks = false;
  List<FocusNode> _focusNodes = [FocusNode()];
  List<TextEditingController> _textEditingControllers = [
    TextEditingController()
  ];

  bool isTasksLoading = false;
  static StreamController<DateTime> _timeController =
      StreamController<DateTime>.broadcast();

  @override
  void initState() {
    super.initState();
    tasks = [];
    !_timeController.isClosed ? _timeController.add(DateTime.now()) : null;
    _timer ??= Timer.periodic(Duration(seconds: 10), (_) {
      _timeController.add(DateTime.now());
    });
  }

  @override
  void dispose() async {
    _timer?.cancel();
    _timeController.close();
    tasks = [];
    for (var focusNode in _focusNodes) focusNode.dispose();
    for (var editor in _textEditingControllers) editor.dispose();
    super.dispose();
  }

  void removeTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  void addTask(Task task, int index) {
    setState(() {
      tasks.insert(index, task);
    });
  }

  void onUpdate(UpdateTypes upd, int index, Task task) {
    if (upd == UpdateTypes.remove)
      removeTask(index);
    else if (upd == UpdateTypes.insert) addTask(task, index);
  }

  @override
  Widget build(BuildContext context) {
    String? audioLink = widget.alarm.InternalAudioFile;
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    return Padding(
      padding: EdgeInsets.only(top: 2),
      child: SwipeActionCell(
        key: ObjectKey(widget.alarm.AlarmAppId),
        trailingActions: [
          if ((widget.isAdmin ||
                  widget.alarm.CreatedBy == userProvider.user!.UserId) &&
              !showTasks &&
              widget.allowActions)
            customSwipeActionCell(
                Icon(CupertinoIcons.delete, color: Colors.red),
                Text("Delete", style: TextStyle(color: Colors.red)),
                (p0) async {
              print(p0);
              var res = await deleteAlarm(widget.alarm.AlarmId);
              print(res);
              if (res['success']) {
                AlarmService.cancelAlarm(widget.alarm.AlarmAppId);
                widget.alarmProvider.removeAlarm(widget.alarm);
                Fluttertoast.showToast(msg: "Delete Alarm!");
              } else {
                Fluttertoast.showToast(msg: res['message']);
              }
            }),
          customSwipeActionCell(
              Icon(Icons.exit_to_app_rounded), Text("Opt Out"), (p0) => null)
        ],
        // : [],
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
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                      Expanded(child: Container()),
                      PlayButton(
                        url: audioLink ?? "nokia.mp3",
                        isExpanded: true,
                      ),
                      SizedBox(width: 2),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text(
                      widget.alarm.NotificationBody,
                      style: TextStyle(fontSize: 15, color: Colors.white70),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text(
                      DateFormat('hh:mm a dd MMMM yy ')
                          .format(widget.alarm.Time),
                      style: TextStyle(fontSize: 11, color: Colors.white30),
                    ),
                  ),
                  // Text(widget.alarm.AlarmAppId.toString()),
                  SizedBox(height: 10),
                  bottomBar(),
                  if (showTasks)
                    InkWell(
                      onTap: () {
                        print("here");
                        setState(() {
                          _focusNodes.insert(0, FocusNode());
                          _textEditingControllers.insert(
                              0, TextEditingController());
                        });

                        tasks.insert(
                            0,
                            Task(
                                widget.alarm.AlarmId, "Add your task", false, 0,
                                IsNew: true));
                      },
                      child: Container(
                          color: Colors.blueGrey[700],
                          child: const Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [Icon(Icons.add), Text("Add New Task")],
                            ),
                          )),
                    ),

                  if (isTasksLoading)
                    Container(
                      color: Colors.black,
                      child: Center(
                        child: CupertinoActivityIndicator(),
                      ),
                    ),
                  if (showTasks)
                    Container(
                      color: Colors.black,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final item = tasks[index];
                          return TaskTextField(
                            index: index,
                            task: item,
                            memberCount: widget.memberCount,
                            groupId: widget.alarm.GroupId!,
                            focusNode: _focusNodes[index],
                            onUpdate: onUpdate,
                            textEditingController:
                                _textEditingControllers[index],
                          );
                        },
                      ),
                    ),

                  InkWell(
                    onTap: () async {
                      if (!showTasks) {
                        setState(() {
                          isTasksLoading = true;
                        });
                      }
                      var res = await getTasks(widget.alarm.AlarmId);
                      if (res['success']) {
                        for (var i = 0; i <= res['tasks'].length; i++) {
                          _focusNodes.insert(0, FocusNode());
                          _textEditingControllers.insert(
                              0, TextEditingController());
                        }
                        setState(() {
                          isTasksLoading = false;
                          showTasks = !showTasks;
                          tasks = res['tasks'];
                        });
                      } else {
                        setState(() {
                          isTasksLoading = false;
                        });
                        Fluttertoast.showToast(msg: "Unable to fetch tasks");
                      }
                    },
                    child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(5),
                                bottomRight: Radius.circular(5))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(showTasks
                                ? Icons.arrow_drop_up
                                : Icons.arrow_drop_down),
                            Text(
                              "Tasks",
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(width: 10)
                          ],
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  SwipeAction customSwipeActionCell(
      Icon icon, Text text, Function(CompletionHandler) onTap) {
    return SwipeAction(
      // icon: const Icon(Icons.delete_forever),
      color: Colors.transparent,
      content: Container(
        margin: EdgeInsets.only(left: 2),
        height: 90,
        decoration: BoxDecoration(
            color: CupertinoColors.darkBackgroundGray,
            borderRadius: BorderRadius.all(Radius.circular(15)),
            border: Border.all(color: CupertinoColors.black)),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              SizedBox(height: 10),
              text,
            ],
          ),
        ),
      ),
      backgroundRadius: 5,
      onTap: onTap,
      // title: "  Delete"
    );
  }

  Widget bottomBar() {
    return LayoutBuilder(
      builder: ((context, constraints) => Container(
            width: constraints.maxWidth,
            padding: EdgeInsets.only(top: 3),
            color: Theme.of(context).backgroundColor,
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

String formatTimeDifference(Duration difference, widget) {
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

class PlayButton extends StatefulWidget {
  String url;
  bool isExpanded;
  PlayButton({
    super.key,
    required this.url,
    this.isExpanded = true,
  });

  @override
  State<PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> {
  bool _isPlaying = false;
  final player = AudioPlayer();
  late String fileName;
  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fileName = ((alarmTones
            .where((element) => element['location'] == widget.url)
            .first)['name'] ??
        "Nokia");
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
                color: Colors.black, borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding:
                  widget.isExpanded ? EdgeInsets.all(2.0) : EdgeInsets.all(0.0),
              child: Row(
                children: [
                  Icon(
                    _isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                    color: Colors.white,
                  ),
                  if (widget.isExpanded) SizedBox(width: 5),
                  if (widget.isExpanded)
                    Text(
                      fileName,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  if (widget.isExpanded) SizedBox(width: 5),
                ],
              ),
            )));
  }
}
