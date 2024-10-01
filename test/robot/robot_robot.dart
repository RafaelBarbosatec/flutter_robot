import 'package:flutter/material.dart';
import 'package:flutter_robot/flutter_robot.dart';
import 'package:flutter_test/flutter_test.dart';

class RobotRobot extends Robot {
  RobotRobot({required super.tester})
      : super(
          scenario: RobotScenarioNone(),
          routes: {
            '/details': (context) => Scaffold(
                  appBar: AppBar(
                    title: const Text('Details'),
                  ),
                ),
          },
        );

  @override
  Widget build() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Builder(builder: (context) {
        return Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/details');
            },
            child: const Text('Button'),
          ),
        );
      }),
    );
  }

  Future<void> tapButton() async {
    await tester.tap(find.text('Button'));
    await tester.pumpAndSettle();
  }

  Future<void> assetHomeGonden() async {
    return takeSnapshot('Robot_routes_home');
  }

  Future<void> assetNavigationGonden() async {
    return takeSnapshot('Robot_routes_detail');
  }
}
