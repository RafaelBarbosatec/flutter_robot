[![Pub Version](https://img.shields.io/pub/v/flutter_robot?color=blueviolet)](https://pub.dev/packages/flutter_robot)
[![Code Quality](https://github.com/RafaelBarbosatec/flutter_robot/actions/workflows/code_quality.yml/badge.svg)](https://github.com/RafaelBarbosatec/flutter_robot/actions/workflows/code_quality.yml)

# Flutter Robot 🤖📱

Create a widget testes using the Robot Pattern!

| Progress | Feature |
|----------|----------|
| ✅    | Simulate multi device screen sizes   |
| ✅    | Simulate home IOS button  |
| ✅    | Simulate status bar   |
| ✅    | Simulate keyboard open   |

## Creating your first Robot test

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

#### First step - Creating a robot

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

Now just run the command `flutter test --update-goldens`. If averything is ok your test will pass and create a folder named `golden_files` and inside that the file `MyFeaturePage_screen.png`.

Ready! When you run `flutter test` your test will validate the golden test.

## Creating test using scenarios

...

## Runing test in multi devices

To run your `Robot` test in multi devices simulating `statusBar`,`Keyboard opened` or `ios home button` you can use `MultiDeviceRobot`.

```dart

void main() {
  testWidgets('Should run in all devices', (tester) async {
    await MultiDeviceRobot<MultiDevicesRobot>(
      robot: MultiDevicesRobot(tester: tester),
      devices: [
        RobotDevice.small(),
        RobotDevice.medium(),
        RobotDevice.large(),
        RobotDevice(
          name: 'custom',
          sizeScreen: const Size(800, 800),
          withStatusBar: true,
          withKeyboard: true,
          withIOSHomeButton: true,
        ),
      ],
      test: (robot, device) async {
        final robot = MyFeaturePageRobot(tester: tester);
        await robot.setup();
        await robot.assertScreen();
      },
    ).run();
  });
}

```


## Loading fonts

To load fonts to show the text and icons in your golden files you can use the `RobotFontLoaderManager`.

Create a file in your `test` folder named `flutter_test_config.dart`.

```dart

import 'dart:async';

import 'package:flutter_robot/flutter_robot.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  // This load the material icons.
  RobotFontLoaderManager().add(MaterialIconsFontLoader());
  // This load the fonts definned in your pubspec.yml
  RobotFontLoaderManager().add(PubspecFontLoader());
  return testMain();
}


```

If is need you can create your custom FontLoader. Just create a class and extends by `RobotFontLoader`.

```dart

import 'package:flutter_robot/flutter_robot.dart';

class MyCustomIconFontLoader extends RobotFontLoader{

  @override
  Future<void> load() async {
    // Load here your font
  }
}


```

Now adds in the `RobotFontLoaderManager`.

```dart

RobotFontLoaderManager().add(MyCustomIconFontLoader());

```
