import 'dart:math';
import 'package:flutter/material.dart';

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
