import 'package:flutter_test/flutter_test.dart';

import 'robot_robot.dart';

void main() {
  testWidgets('Should navigate to detail', (tester) async {
    final robot = RobotRobot(tester: tester);
    await robot.setup();
    await robot.assetHomeGonden();
    await robot.tapButton();
    await robot.assetNavigationGonden();
  });
}
