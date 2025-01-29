import 'package:flutter_robot/src/robot_scenario.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leak_tracker_flutter_testing/leak_tracker_flutter_testing.dart';
import 'package:meta/meta.dart';
import 'package:test_api/scaffolding.dart' as test_package;

import 'robot.dart';

Robot Function(WidgetTester)? _blocBuilder;

void setUpRobot<T extends RobotScenario>(Robot<T> Function(WidgetTester) callback) {
  _blocBuilder = callback;
}

/// A test helper that makes it easy to write widget tests with robots.
///
/// The [testRobot] function is used to write widget tests that use robots to interact with the UI.
/// It requires setting up the robot first using [setupRobot].
///
/// Example usage:
/// ```dart
/// void main() {
///   // Setup the robot builder
///   setupRobot(
///     (tester) => MyRobot(tester: tester),
///   );
///
///   // Write tests using testRobot
///   testRobot<MyRobot>(
///     'should show sunny icon and toggle to cloudy',
///     (robot) async {
///       await robot.assertPageSunnyGolden();
///       await robot.sunIcon.tap();
///       await robot.assertPageCloudyGolden();
///     },
///     scenario: MyScenario(), // Optional scenario configuration
///   );
///
///   // Test on multiple device sizes
///   testRobot<MyRobot>(
///     'should display correctly on different devices',
///     (robot) async {
///       await robot.assertPageLayout();
///     },
///     devices: [
///       RobotDevice.large(),
///       RobotDevice.small(),
///       RobotDevice.medium(),
///     ],
///     scenario: MyScenario(),
///   );
/// }
/// ```
///
/// Parameters:
/// - [description]: Test description
/// - [body]: Test body that receives the robot instance
/// - [scenario]: Optional scenario configuration
/// - [devices]: List of device configurations for multi-device testing
/// - [skip]: Whether to skip this test
/// - [timeout]: Custom timeout duration
/// - [semanticsEnabled]: Whether semantics are enabled
/// - [variant]: Test variants configuration
/// - [tags]: Test tags
/// - [retry]: Number of retry attempts
/// - [experimentalLeakTesting]: Leak testing configuration
@isTest
void testRobot<R extends Robot>(
  String description,
  Future<void> Function(R) body, {
  RobotScenario? scenario,
  List<RobotDevice> devices = const [],
  bool? skip,
  test_package.Timeout? timeout,
  bool semanticsEnabled = true,
  TestVariant<Object?> variant = const DefaultTestVariant(),
  dynamic tags,
  int? retry,
  LeakTesting? experimentalLeakTesting,
}) {
  testWidgets(
    description,
    (tester) async {
      if (_blocBuilder == null) {
        throw Exception('Robot not initialized, pls call setupRobot first');
      }
      if (devices.isEmpty) {
        final robot = _blocBuilder!(tester) as R;
        await robot.setup(scenario: scenario);
        await body(robot);
      }
      await MultiDeviceRobot<R>(
        robot: _blocBuilder!(tester) as R,
        devices: devices,
        test: (robot, device) async {
          await robot.setup(scenario: scenario);
          await body(robot);
        },
      ).run();
    },
    skip: skip,
    timeout: timeout,
    semanticsEnabled: semanticsEnabled,
    variant: variant,
    tags: tags,
    retry: retry,
    experimentalLeakTesting: experimentalLeakTesting,
  );
}
