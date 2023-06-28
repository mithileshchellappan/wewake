import 'dart:math';

import 'package:flutter/material.dart';

class TextIcon extends StatelessWidget {
  final String text;
  final double size;

  TextIcon({required this.text, this.size = 48.0});

  @override
  Widget build(BuildContext context) {
    final String initials = _getInitials(text);
    final Color randomColor = _getRandomDarkColor();

    return CircleAvatar(
      backgroundColor: randomColor,
      radius: size / 2,
      child: Text(
        initials,
        style: TextStyle(
          color: Colors.white,
          fontSize: size / 2,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _getInitials(String text) {
    final words = text.split(' ');
    if (words.length >= 2) {
      return words[0][0].toUpperCase() + words[1][0].toUpperCase();
    } else if (words.length == 1 && words[0].length >= 2) {
      return words[0].substring(0, 2).toUpperCase();
    } else {
      return text.substring(0, min(2, text.length)).toUpperCase();
    }
  }

  Color _getRandomDarkColor() {
    final random = Random();
    final darkIntesity = 150;
    final red = random.nextInt(darkIntesity);
    final green = random.nextInt(darkIntesity);
    final blue = random.nextInt(darkIntesity);
    return Color.fromARGB(255, red, green, blue);
  }
}
