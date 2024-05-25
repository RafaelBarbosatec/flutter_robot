# Flutter Robot 🤖📱

Create a widget testes using the Robot Pattern!

| Progress | Feature |
|----------|----------|
| ✅    | Simulate multi device screen sizes   |
| ✅    | Simulate home IOS button  |
| ✅    | Simulate status bar   |
| ✅    | Simulate keyboard open   |

## Creating your firt Robot test

Basically we need create a 2 files `{page_name}_robot.dart` and `{page_name}_test.dart`. When we need mock multi scenarios we will need create a `{page_name}_scenarios.dart`.

```
my_project
│      
└───lib
│   ...
└───test
    │
    └───feature
        │   feature_robot.dart
        │   feature_scenarios.dart
        │   feature_test.dart
```

#### Fist step - Creating a robot

In this first example willnot use scenarios. So, we setted fixed scenario to 'RobotScenario.none()'.

`my_feature_page_robot.dart`

```dart

class MyFeaturePageRobot extends Robot {
  DevicesRobot({
    required super.tester,
  }) : super(
          scenario: RobotScenario.none(),
        );

  @override
  Widget build() {
    // return here your widget/page to test
    return const MyFeaturePage();
  }

  Future<void> assertScreen() {
    return takeSnapshot('MyFeaturePage_screen');
  }

  // Create here others methods to interact with 'WidgetTester' API like a `tap`, `enterText`, etc.

}

```

#### Second step - Creating a test

`my_feature_page_test.dart`

```dart

import 'package:flutter_robot/flutter_robot.dart';
import 'package:flutter_test/flutter_test.dart';

import 'my_feature_page_robot.dart';

void main() {
  testWidgets(
    'Should show page correctly',
    (tester) async {
      final robot = MyFeaturePageRobot(tester: tester);
      await robot.setup();
      await robot.assertScreen();
    },
  );
}
```

### Creating a golden files

Now just run the command `flutter test --update-goldens`. If averything is ok your test will pass and create a folder named 'golden_files' and inside that the file `MyFeaturePage_screen.png`.
Ready! When you run `flutter test` your test will validate the golden.
