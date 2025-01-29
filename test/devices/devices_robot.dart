import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_robot/flutter_robot.dart';

import '../util/widget_test_default.dart';

class DevicesRobot extends Robot {
  DevicesRobot({
    required super.tester,
    super.device,
    SystemUiOverlayStyle? sytemUi,
  }) : super(
          theme: ThemeData.light().copyWith(
            appBarTheme: const AppBarTheme().copyWith(
              systemOverlayStyle: sytemUi,
            ),
          ),
        );

  RobotElement get secondaryButton => RobotElement.byText('Secondary', tester);

  @override
  Widget build() {
    return const WidgetTestDefault();
  }

  void assertNavigateToSecondPage() {
    assertNavigatorRoute(WidgetTestDefault.secondRoute);
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
