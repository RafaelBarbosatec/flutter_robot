import 'dart:async';

import 'package:flutter_robot/src/font_loader/material_icon_font_loader.dart';
import 'package:flutter_robot/src/font_loader/pubspec_font_loader.dart';
import 'package:flutter_robot/src/font_loader/robot_font_loader.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  RobotFontLoaderManager.instance.add(MaterialIconsFontLoader());
  RobotFontLoaderManager.instance.add(PubspecFontLoader());
  return testMain();
}
