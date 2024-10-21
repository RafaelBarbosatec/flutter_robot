import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_robot/flutter_robot.dart';
import 'package:flutter_robot_example/src/presentation/home/home_page.dart';

import 'home_page_scenarios.dart';

class HomePageRobot extends Robot<HomePageScenarios> {
  HomePageRobot({
    required super.tester,
    required super.scenario,
  });

  @override
  Widget build() {
    return const HomePage();
  }

  Future<void> assertSunnyGolden() {
    return takeSnapshot('HomePage_sunny');
  }

  Future<void> assertSunnyCloudyGolden() {
    return takeSnapshot('HomePage_sunny_cloudy');
  }

  Future<void> assertNightClearGolden() {
    return takeSnapshot('HomePage_night_clear');
  }

  Future<void> assertNightCloudyGolden() {
    return takeSnapshot('HomePage_night_cloudy');
  }
}
