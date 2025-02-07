
import 'dart:math';

import 'package:flutter/material.dart';

class RandomColor {
  static final List<MaterialColor> _colors = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.blueGrey,
  ];

  static final Random _random = Random();

  static Color getRandomShade700() {
    return _colors[_random.nextInt(_colors.length)].shade700;
  }
}