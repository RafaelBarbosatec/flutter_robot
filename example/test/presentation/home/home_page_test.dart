import 'package:flutter_robot/flutter_robot.dart';

import 'home_page_robot.dart';
import 'home_page_scenarios.dart';

void main() {
  setUpRobot(
    (tester) => HomePageRobot(tester: tester),
  );

  testRobot<HomePageRobot>('Should show sunny', (robot) async {
    await robot.assertSunnyGolden();
  }, scenario: HomePageScenariosClear(isDay: true));

  testRobot<HomePageRobot>('Should show nigth clear', (robot) async {
    await robot.assertNightClearGolden();
  }, scenario: HomePageScenariosClear(isDay: false));

  testRobot<HomePageRobot>('Should show sunny cloudy', (robot) async {
    await robot.assertSunnyCloudyGolden();
  }, scenario: HomePageScenariosCloudy(isDay: true));

  testRobot<HomePageRobot>('Should show night cloudy', (robot) async {
    await robot.assertNightCloudyGolden();
  }, scenario: HomePageScenariosCloudy(isDay: false));
}
