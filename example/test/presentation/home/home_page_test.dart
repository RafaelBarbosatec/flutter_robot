import 'package:flutter_test/flutter_test.dart';

import 'home_page_robot.dart';

void main() {
  testWidgets('Should show sunny', (tester) async {
    final robot = HomePageRobot(tester: tester);
    await robot.setup();
    await robot.assertSunnyGolden();
  });
}
