import 'dart:ui';

import 'package:flutter/material.dart';

class MainColors {
  static MaterialColor darkGreen = MaterialColor(0xFF7FB77E, colorCodes);
  static MaterialColor lightGreen = MaterialColor(0xFFB1D7B4, colorCodes);
  static MaterialColor lightGrey = MaterialColor(0xFFF7F6DC, colorCodes);
  static MaterialColor lightOrange = MaterialColor(0xFFFFC090, colorCodes);
}
Map<int, Color> colorCodes = {
    50: Color.fromRGBO(147, 205, 72, .1),
    100: Color.fromRGBO(147, 205, 72, .2),
    200: Color.fromRGBO(147, 205, 72, .3),
    300: Color.fromRGBO(147, 205, 72, .4),
    400: Color.fromRGBO(147, 205, 72, .5),
    500: Color.fromRGBO(147, 205, 72, .6),
    600: Color.fromRGBO(147, 205, 72, .7),
    700: Color.fromRGBO(147, 205, 72, .8),
    800: Color.fromRGBO(147, 205, 72, .9),
    900: Color.fromRGBO(147, 205, 72, 1),
  };
