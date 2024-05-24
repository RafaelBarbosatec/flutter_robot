import 'package:flutter_robot/src/robot.dart';
import 'package:flutter_test/flutter_test.dart';

import 'devices_robot.dart';

void main() {
  testWidgets(
    'Should show small device with statusBar and IOSHomeButton',
    (tester) async {
      final robot = DevicesRobot(tester: tester, device: RobotDevice.small());
      await robot.configure();
      await robot.assertSmallDeviceStatusBarIOSHomeButton();
    },
  );

  testWidgets(
    'Should show medium device with statusBar and IOSHomeButton',
    (tester) async {
      final robot = DevicesRobot(tester: tester);
      await robot.configure();
      await robot.assertMediumDeviceStatusBarIOSHomeButton();
    },
  );

  testWidgets(
    'Should show large device with statusBar and IOSHomeButton',
    (tester) async {
      final robot = DevicesRobot(tester: tester, device: RobotDevice.large());
      await robot.configure();
      await robot.assertLargeDeviceStatusBarIOSHomeButton();
    },
  );

  testWidgets(
    'Should show medium device with statusBar, IOSHomeButton and keyboard',
    (tester) async {
      final robot = DevicesRobot(
        tester: tester,
        device: RobotDevice.medium(
          withKeyboard: true,
        ),
      );
      await robot.configure();
      await robot.assertMediumDeviceStatusBarIOSHomeButtonKeyboard();
    },
  );
}
