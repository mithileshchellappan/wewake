import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AlarmCard extends StatelessWidget {
  final DateTime dt;
  final String time;

  AlarmCard({Key? key})
      : dt = DateTime.now().add(Duration(hours: 1)),
        time = formatTimeDifference(
            DateTime.now().difference(DateTime.now().add(Duration(hours: -1)))),
        super(key: key);

  static String formatTimeDifference(Duration difference) {
    if (difference.inSeconds < 60) {
      return "just now";
    } else if (difference.inMinutes < 60) {
      return "in ${difference.inMinutes} minutes";
    } else if (difference.inHours < 24) {
      return "in ${difference.inHours} hours";
    } else if (difference.inDays < 30) {
      return "in ${difference.inDays} days";
    } else if (difference.inDays < 365) {
      int months = (difference.inDays / 30).floor();
      return "in $months ${months == 1 ? 'month' : 'months'}";
    } else {
      int years = (difference.inDays / 365).floor();
      return "in $years ${years == 1 ? 'year' : 'years'}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(time),
        ],
      ),
    );
  }
}
