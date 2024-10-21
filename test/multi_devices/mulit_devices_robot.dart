import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_robot/src/robot.dart';

import '../util/widget_test_default.dart';

class MultiDevicesRobot extends Robot {
  MultiDevicesRobot({required super.tester}) : super();

  @override
  Widget build() {
    return const WidgetTestDefault();
  }

  Future<void> assertScreen() {
    return takeSnapshot('WidgetTest_screen');
  }
}
