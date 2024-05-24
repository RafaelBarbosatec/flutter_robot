import 'dart:async';

abstract class RobotScenario {
  static RobotScenario none() => RobotScenarioNone();
  FutureOr<void> mockScenario();
  FutureOr<void> injectDependencies();
}

class RobotScenarioNone extends RobotScenario {
  @override
  Future<void> injectDependencies() async {}

  @override
  Future<void> mockScenario() async {}
}
