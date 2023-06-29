import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

Color getRandomDarkColor() {
  final int darkIntensity = 150;
  final int red = _getRandomNumber(darkIntensity);
  final int green = _getRandomNumber(darkIntensity);
  final int blue = _getRandomNumber(darkIntensity);
  return Color.fromARGB(255, red, green, blue);
}

int _getRandomNumber(int max) {
  final Random random = Random();
  return random.nextInt(max + 1);
}

class LoadingButton extends StatefulWidget {
  String text;
  Function onTap;
  bool useColor;
  LoadingButton({
    super.key,
    required this.text,
    required this.onTap,
    this.useColor = false,
  });
  @override
  State<LoadingButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: MaterialButton(
          color: widget.useColor
              ? Theme.of(context).focusColor
              : Colors.transparent,
          onPressed: isLoading ? null : () => _onPress(),
          child: isLoading
              ? const CupertinoActivityIndicator()
              : Text(widget.text,
                  style: TextStyle(
                      decoration: widget.useColor
                          ? TextDecoration.none
                          : TextDecoration.underline,
                      decorationStyle: TextDecorationStyle.dotted,
                      decorationThickness: 3))),
    );
  }

  _onPress() async {
    setState(() {
      isLoading = true;
    });
    var res = await widget.onTap();
    setState(() {
      isLoading = false;
    });
    return res;
  }
}
