import 'package:flutter/material.dart';
import 'package:flutter_robot/src/robot.dart';
import 'package:flutter_robot/src/robot_scenario.dart';

class DevicesRobot extends Robot {
  DevicesRobot({required super.tester, RobotDevice? device})
      : super(
          scenario: RobotScenario.none(),
          overrideDevice: device,
        );

  @override
  Widget build() {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {},
              child: const Text('Primary button'),
            ),
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.account_box_outlined),
                    FlutterLogo(
                      size: 100,
                    ),
                    Icon(Icons.ac_unit_outlined),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Primary button'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> assertMediumDeviceStatusBarIOSHomeButton() {
    return takeSnapshot('Device_medium_statusbar_ioshome_button');
  }

  Future<void> assertMediumDeviceStatusBarIOSHomeButtonKeyboard() {
    return takeSnapshot('Device_medium_statusbar_ioshome_button_keyboard');
  }

  Future<void> assertSmallDeviceStatusBarIOSHomeButton() {
    return takeSnapshot('Device_small_statusbar_ioshome_button');
  }

  Future<void> assertLargeDeviceStatusBarIOSHomeButton() {
    return takeSnapshot('Device_large_statusbar_ioshome_button');
  }
}
