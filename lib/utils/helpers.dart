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
  LoadingButton({super.key, required this.text, required this.onTap});
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
          color: Theme.of(context).focusColor,
          child: isLoading ? CupertinoActivityIndicator() : Text(widget.text),
          onPressed: isLoading ? null : () => _onPress()),
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
