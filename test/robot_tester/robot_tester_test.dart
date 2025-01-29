import 'package:flutter_robot/flutter_robot.dart';

import 'robot_tester_robot.dart';
import 'robot_tester_scenarios.dart';

void main() {
  setUpRobot(
    (tester) => RobotTesterRobot(tester: tester),
  );

  testRobot<RobotTesterRobot>(
    'robot tester test a',
    (robot) async {
      await robot.assertPageSunnyGolden();
      await robot.sunIcon.tap();
      await robot.assertPageCloudyGolden();
    },
    scenario: RobotTesterScenario1(),
  );

  testRobot<RobotTesterRobot>(
    'robot tester test b',
    (robot) async {
      await robot.assertPageCloudyGolden();
    },
    scenario: RobotTesterScenario2(),
  );

  testRobot<RobotTesterRobot>(
    'robot tester test multi device',
    (robot) async {
      await robot.assertPageCloudyGolden();
    },
    devices: [
      RobotDevice.large(),
      RobotDevice.small(),
      RobotDevice.medium(),
    ],
    scenario: RobotTesterScenario2(),
  );
}
