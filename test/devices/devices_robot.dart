import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_robot/flutter_robot.dart';

import '../util/widget_test_default.dart';

class DevicesRobot extends Robot {
  DevicesRobot({
    required super.tester,
    RobotDevice? device,
    SystemUiOverlayStyle? sytemUi,
  }) : super(
          scenario: RobotScenario.none(),
          overrideDevice: device,
          theme: ThemeData.light().copyWith(
            appBarTheme: const AppBarTheme().copyWith(
              systemOverlayStyle: sytemUi,
            ),
          ),
        );

  @override
  Widget build() {
    return const WidgetTestDefault();
  }

  Future<void> assertMediumDeviceStatusBarIOSHomeButton() {
    return takeSnapshot('Device_medium_statusbar_ioshome_button');
  }

  Future<void> assertMediumDeviceStatusBarIOSHomeButtonKeyboard() {
    return takeSnapshot('Device_medium_statusbar_ioshome_button_keyboard');
  }

  Future<void> assertMediumDeviceStatusBarDark() {
    return takeSnapshot('Device_medium_statusbar_dark');
  }

  Future<void> assertSmallDeviceStatusBarIOSHomeButton() {
    return takeSnapshot('Device_small_statusbar_ioshome_button');
  }

  Future<void> assertLargeDeviceStatusBarIOSHomeButton() {
    return takeSnapshot('Device_large_statusbar_ioshome_button');
  }
}
