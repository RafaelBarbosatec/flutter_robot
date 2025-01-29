import 'package:flutter/material.dart';
import 'package:flutter_robot/flutter_robot.dart';

import '../util/widget_test_tester.dart';
import 'robot_tester_scenarios.dart';

class RobotTesterRobot extends Robot<RobotTesterScenario> {
  RobotTesterRobot({required super.tester});

  @override
  Widget build() {
    return MyWidgetTest(
      isSunny: scenario.isSunny,
    );
  }

  RobotElement get sunIcon => RobotElement.byType(InkWell, tester);

  Future<void> assertPageSunnyGolden() {
    return takeSnapshot('page_sunny');
  }

  Future<void> assertPageCloudyGolden() {
    return takeSnapshot('page_cloudy');
  }
}
