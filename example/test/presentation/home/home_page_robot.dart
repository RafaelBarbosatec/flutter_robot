import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_robot/flutter_robot.dart';
import 'package:flutter_robot_example/src/presentation/home/home_page.dart';

class HomePageRobot extends Robot {
  HomePageRobot({required super.tester})
      : super(
          scenario: RobotScenarioNone(),
        );

  @override
  Widget build() {
    return const HomePage();
  }

  Future<void> assertSunnyGolden() {
    return takeSnapshot('HomePage_sunny');
  }
}
