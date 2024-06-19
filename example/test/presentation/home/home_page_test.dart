import 'package:flutter_test/flutter_test.dart';

import 'home_page_robot.dart';
import 'home_page_scenarios.dart';

void main() {
  testWidgets('Should show sunny', (tester) async {
    final robot = HomePageRobot(
      tester: tester,
      scenario: HomePageScenariosClear(isDay: true),
    );
    await robot.setup();
    await robot.assertSunnyGolden();
  });

  testWidgets('Should show nigth clear', (tester) async {
    final robot = HomePageRobot(
      tester: tester,
      scenario: HomePageScenariosClear(isDay: false),
    );
    await robot.setup();
    await robot.assertNightClearGolden();
  });
  testWidgets('Should show sunny cloudy', (tester) async {
    final robot = HomePageRobot(
      tester: tester,
      scenario: HomePageScenariosCloudy(isDay: true),
    );
    await robot.setup();
    await robot.assertSunnyCloudyGolden();
  });

  testWidgets('Should show night cloudy', (tester) async {
    final robot = HomePageRobot(
      tester: tester,
      scenario: HomePageScenariosCloudy(isDay: false),
    );
    await robot.setup();
    await robot.assertNightCloudyGolden();
  });
}
