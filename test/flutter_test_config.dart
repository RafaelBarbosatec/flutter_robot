import 'dart:async';

import 'package:flutter_robot/flutter_robot.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  RobotFontLoaderManager().add(MaterialIconsFontLoader());
  RobotFontLoaderManager().add(PubspecFontLoader());
  return testMain();
}
