
import 'package:flutter/material.dart';


class TextIcon extends StatelessWidget {
  final String text;
  final double size;
  final Color backgroundColor;

  TextIcon({required this.text, required this.backgroundColor,this.size = 48.0});

  @override
  Widget build(BuildContext context) {
    final String initials = _getInitials(text);

    return CircleAvatar(
      backgroundColor: backgroundColor,
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
      return text.substring(0, 2).toUpperCase();
    }
  }


}
