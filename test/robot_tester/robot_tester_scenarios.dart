import 'dart:async';

import 'package:flutter_robot/flutter_robot.dart';

abstract class RobotTesterScenario extends RobotScenario {
  bool get isSunny;
  @override
  FutureOr<void> injectDependencies() {}

  @override
  FutureOr<void> mockScenario() {}
}

class RobotTesterScenario1 extends RobotTesterScenario {
  @override
  bool get isSunny => true;
}

class RobotTesterScenario2 extends RobotTesterScenario {
  @override
  bool get isSunny => false;
}
