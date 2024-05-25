import 'package:flutter/services.dart';
import 'package:flutter_robot/flutter_robot.dart';
import 'package:flutter_test/flutter_test.dart';

import 'devices_robot.dart';

void main() {
  testWidgets(
    'Should show small device with statusBar and IOSHomeButton',
    (tester) async {
      final robot = DevicesRobot(tester: tester, device: RobotDevice.small());
      await robot.setup();
      await robot.assertSmallDeviceStatusBarIOSHomeButton();
    },
  );

  testWidgets(
    'Should show medium device with statusBar and IOSHomeButton',
    (tester) async {
      final robot = DevicesRobot(tester: tester);
      await robot.setup();
      await robot.assertMediumDeviceStatusBarIOSHomeButton();
    },
  );

  testWidgets(
    'Should show large device with statusBar and IOSHomeButton',
    (tester) async {
      final robot = DevicesRobot(tester: tester, device: RobotDevice.large());
      await robot.setup();
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
      await robot.setup();
      await robot.assertMediumDeviceStatusBarIOSHomeButtonKeyboard();
    },
  );

  testWidgets(
    'Should show medium device with statusBar dark',
    (tester) async {
      final robot =
          DevicesRobot(tester: tester, sytemUi: SystemUiOverlayStyle.dark);
      await robot.setup();
      await robot.assertMediumDeviceStatusBarDark();
    },
  );
}
