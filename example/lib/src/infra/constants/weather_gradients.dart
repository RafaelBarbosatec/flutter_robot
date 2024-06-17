import 'package:flutter/material.dart';

abstract class WeatherGradients {
  static const LinearGradient day = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xff2F5AF4),
      Color(0xff0FA2AB),
    ],
  );

  static const LinearGradient dayCloudy = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xffBCE8FF),
      Color(0xffFFFFFF),
    ],
  );

  static const LinearGradient night = LinearGradient(
    colors: [
      Color(0xff1D2837),
    ],
  );
}
