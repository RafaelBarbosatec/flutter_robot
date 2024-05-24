import 'dart:developer';

import '../robot.dart';

class MultiDeviceRobot<T extends Robot> {
  final List<RobotDevice> devices;
  final T robot;
  final Future<void> Function(T robot, RobotDevice device) test;

  MultiDeviceRobot({
    required this.devices,
    required this.robot,
    required this.test,
  });

  Future<void> run() async {
    for (final device in devices) {
      robot.setDevice(device);
      try {
        await test(robot, device);
      } catch (e) {
        log('\x1B[31m------------------------------\x1B[0m');
        log('\x1B[31mError on device ${device.name}\x1B[0m');
        log('\x1B[31m------------------------------\x1B[0m');
        rethrow;
      }
    }
  }
}
