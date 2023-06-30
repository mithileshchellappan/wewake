import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';

import '../../models/Alarm.dart';

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
        widget.alarm.Time.difference(DateTime.now()), widget);
    timeText = DateFormat('dd MMMM yy \nhh:mm a').format(widget.alarm.Time);
  }

  static String formatTimeDifference(Duration difference, widget) {
    print(difference.inMinutes);
    if (difference.inSeconds < 60 && difference.inSeconds > 0) {
      return "just now";
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
  Widget build(BuildContext context) {
    String? audioLink = widget.alarm.InternalAudioFile;

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
              Text(widget.alarm.AlarmAppId.toString()),
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
