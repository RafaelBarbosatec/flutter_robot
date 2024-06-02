import 'dart:ui';

import 'package:flutter_robot/src/robot.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mulit_devices_robot.dart';

void main() {
  testWidgets('Should run in all devices', (tester) async {
    await MultiDeviceRobot<MultiDevicesRobot>(
      robot: MultiDevicesRobot(tester: tester),
      devices: [
        RobotDevice.small(),
        RobotDevice.medium(),
        RobotDevice.large(),
        RobotDevice(
          name: 'custom',
          sizeScreen: const Size(800, 800),
          withStatusBar: true,
        ),
      ],
      test: (robot, device) async {
        device == RobotDevice.medium();
        await robot.setup();
        await robot.assertScreen();
      },
    ).run();
  });
}
