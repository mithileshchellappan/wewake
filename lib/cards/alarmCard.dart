import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';

import '../models/Alarm.dart';

class AlarmCard extends StatefulWidget {
  final Alarm alarm;

  AlarmCard({required this.alarm, Key? key}) : super(key: key);

  @override
  _AlarmCardState createState() => _AlarmCardState();
}

class _AlarmCardState extends State<AlarmCard> {
  late String time;
  late String timeText;
  @override
  void initState() {
    super.initState();
    time = formatTimeDifference(
        widget.alarm.Time.difference(DateTime.now().add(Duration(hours: 1))));
    timeText = DateFormat('dd MMMM yy \nhh:mm a').format(widget.alarm.Time);
  }

  static String formatTimeDifference(Duration difference) {
    if (difference.inSeconds < 60) {
      return "just now";
    } else if (difference.inMinutes < 60) {
      return "In ${difference.inMinutes} minutes";
    } else if (difference.inHours < 24) {
      return "In ${difference.inHours} hours";
    } else if (difference.inDays < 30) {
      return "In ${difference.inDays} days";
    } else if (difference.inDays < 365) {
      int months = (difference.inDays / 30).floor();
      return "In $months ${months == 1 ? 'month' : 'months'}";
    } else {
      int years = (difference.inDays / 365).floor();
      return "In $years ${years == 1 ? 'year' : 'years'}";
    }
  }

  @override
  Widget build(BuildContext context) {
    String audioLink = widget.alarm.InternalAudioFile;

    return Padding(
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
                      "${widget.alarm.IsEnabled ? "🟢" : "🔴"}${widget.alarm.NotificationTitle}",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  Expanded(child: Container()),
                  PlayButton(url: audioLink),
                  SizedBox(width: 5),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Text(
                  widget.alarm.NotificationBody,
                  style: TextStyle(fontSize: 12, color: Colors.white60),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Text(
                  "$timeText",
                  style: TextStyle(fontSize: 11, color: Colors.white60),
                ),
              ),
              SizedBox(height: 10),
              bottomBar(),
            ],
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
                Text("$time"),
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
  PlayButton({
    super.key,
    required this.url,
  });

  @override
  State<PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> {
  bool _isPlaying = false;
  final player = AudioPlayer();

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
              padding: EdgeInsets.all(2.0),
              child: Row(
                children: [
                  Icon(
                    _isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                    color: Colors.black,
                  ),
                  SizedBox(width: 5),
                  Text(
                    _isPlaying ? "Pause" : "Play",
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(width: 5),
                ],
              ),
            )));
  }
}
