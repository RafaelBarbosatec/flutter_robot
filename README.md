[![Pub Version](https://img.shields.io/pub/v/flutter_robot?color=blueviolet)](https://pub.dev/packages/flutter_robot)
[![Code Quality](https://github.com/RafaelBarbosatec/flutter_robot/actions/workflows/code_quality.yml/badge.svg)](https://github.com/RafaelBarbosatec/flutter_robot/actions/workflows/code_quality.yml)
[![Example Code Quality](https://github.com/RafaelBarbosatec/flutter_robot/actions/workflows/example_code_quality%20.yml/badge.svg)](https://github.com/RafaelBarbosatec/flutter_robot/actions/workflows/example_code_quality%20.yml)

# Flutter Robot 🤖📱

Create a widget testes using the Robot Pattern!

It is a good option to create testes to your `page` validating the correct interaction between (controller) <-> (widget). This way you can validate if your view show/do exactly you expected in each state of controller(cubit/bloc/mobx/etc).

| Progress | Feature |
|----------|----------|
| ✅    | Simulate multi device screen sizes   |
| ✅    | Simulate home IOS button  |
| ✅    | Simulate status bar   |
| ✅    | Simulate keyboard open   |

## Installation

Add it to your `pubspec.yaml`
as a `dev_dependencies` by running the following command.

```console
$ dart pub add dev:flutter_robot
```

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

In this first example will not use scenarios. So, we setted fixed scenario to 'RobotScenario.none()'.

`my_feature_page_robot.dart`

```dart

class MyFeaturePageRobot extends Robot {
  DevicesRobot({
    required super.tester,
  });

  @override
  Widget build() {
    // return here your widget/page to test
    return const MyFeaturePage();
  }

  Future<void> assertScreen() {
    return takeSnapshot('MyFeaturePage_screen');
  }

  // Create here others methods to interact with 'WidgetTester' API like a `tap`, `enterText`, etc.
  // Or use RobotElement to find a widget and interact with it.

}

```

#### Second step - Creating a test

`my_feature_page_test.dart`

```dart

import 'package:flutter_robot/flutter_robot.dart';
import 'package:flutter_test/flutter_test.dart';

import 'my_feature_page_robot.dart';

void main() {

  setUpRobot(
    (tester) => MyFeaturePageRobot(tester: tester),
  );

  testRobot<MyFeaturePageRobot>(
    'Should show page correctly',
    (robot) async {
      await robot.assertScreen();
    },
  );
}
```

### Creating a golden files

Now just run the command `flutter test --update-goldens`. If averything is ok your test will pass and create a folder named `golden_files` and inside that the file `MyFeaturePage_screen.png`.

Ready! When you run `flutter test` your test will validate the golden test.

## Creating test using scenarios

First of all, What is `scenarios` here?
`Scenarios` is a group of mocks that help you to arrive in especific state of your controller to validate it.

In this kind of test we don't do mock the controller, we mock the controller dependencies.

The idea here is testing the controller and the view.

So, let's keep going!

The first step is create a `scenarios` file. Just create a class and extending of `RobotScenario`:


`example_page_scenarios.dart`

```dart

abstract class ExamplePageScenarios extends RobotScenario{
  @override
  FutureOr<void> injectDependencies() {}

  @override
  FutureOr<void> mockScenario() {}

}

```

We not go do anything here in the moment. But you already can know that in `injectDependencies` method you will insert the code of inject the page dependencies and the `mockScenario` method you will insert the code of do mock of dependencies.

After then lets implements a base of your robot file.

`example_page_robot.dart`

```dart

class ExamplePageRobot extends Robot<ExamplePageScenarios> {
  ExamplePageRobot({
    required super.tester,
    required super.scenario,
  });

  @override
  Widget build() {
    return const ExamplePage();
  }
}

```

Great, you have da base! Now just adds your interactions and validations.

Lets go create a test with golden validation to success scenario:

1. Create a success scenario in `example_page_scenarios.dart`:

```dart

class GetExampleInfoUsecaseMock extends Mock implements GetExampleInfoUsecase {}

abstract class ExamplePageScenarios extends RobotScenario {
  late GetExampleInfoUsecase usecase;
  late ExampleCubit cubit;

  ExamplePageScenarions() {
    usecase = GetExampleInfoUsecaseMock();
    cubit = ExampleCubit(usecase: usecase);
  }

  @override
  FutureOr<void> injectDependencies() {
    servideLocator.registerFactory(() => cubit);
  }

  @override
  FutureOr<void> mockScenario() {}
}

class ExamplePageSuccess extends ExamplePageScenarios {
  @override
  FutureOr<void> mockScenario() async {
    await super.mockScenario();
    when(() => usecase.call()).thenAnswer((_) async => 'Example Info');
  }
}

```

2. Create a method to validate the golden files in your 'Robot' file.


```dart

class ExamplePageRobot extends Robot<ExamplePageScenarios> {
  ExamplePageRobot({
    required super.tester,
  });

  @override
  Widget build() {
    return const ExamplePage();
  }

  Future<void> assertSuccessScreenGolden(){
    return takeSnapshot('ExamplePage_success');
  }
}


```

If you are providing the cubit by provider you can wrap the widget with BlocProvider in the build method:


```dart

  @override
  Widget build() {
    return BlocProvider(
      create: (context) => scenario.cubit,
      child: const ExamplePage(),
    );
  }

```

3. Create a test

`example_page_test.dart`

``` dart

import 'package:flutter_test/flutter_test.dart';

import 'example_page_robot.dart';
import 'example_page_scenarios.dart';

void main() {

  setUpRobot(
    (tester) => ExamplePageRobot(
      tester: tester,
    ),
  );

  testRobot<ExamplePageRobot>(
    'Should show the success case correctly',
    (robot) async {
      await robot.assertSuccessScreenGolden();
    },
    scenario: ExamplePageSuccess(),
  );
}

```

That is it. Now just run command to create a golden files if you using the golden test.

## Runing test in multi devices

To run your `Robot` test in multi devices simulating `statusBar`,`Keyboard opened` or `ios home button` you can pass the `devices` param in `testRobot` method.

```dart

void main() {

  setUpRobot(
    (tester) => ExamplePageRobot(
      tester: tester,
    ),
  );

  testRobot<ExamplePageRobot>(
    'Should run in all devices',
    (robot) async {
      await robot.assertScreen();
    },
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
  );
}

```


## Using RobotElement

The `RobotElement` is a class that help you to find a widget in the widget tree and interact with it.

Here's an example of how to use `RobotElement` in your tests:


```dart
class MyFeaturePageRobot extends Robot {
  MyFeaturePageRobot({
    required super.tester,
  });

  @override
  Widget build() {
    return const MyFeaturePage();
  }

  // Get a specific element by key
  RobotElement get submitButton => RobotElement.byKey(Key('submit_button'), tester);

  // Get an element by type
  RobotElement get textField => RobotElement.byType(TextField, tester);

  // Get an element by text
  RobotElement get welcomeText => RobotElement.byText('Welcome!', tester);

  // Get an element by icon
  RobotElement get settingsIcon => RobotElement.byIcon(Icons.settings, tester);

}
```

Using in test:

```dart
void main() {
  setUpRobot(
    (tester) => MyFeaturePageRobot(tester: tester),
  );

  testRobot<MyFeaturePageRobot>(
    'Should interact with the elements',
    (robot) async {
      await robot.submitButton.scrollTo();
      await robot.submitButton.tap();
      await robot.welcomeText.assertIsVisible();
      await robot.settingsIcon.longPress();
      await robot.textField.enterText('Test input');
    },
  );
}
```


## Loading fonts

To load fonts to show the text and icons in your golden files you can use the `RobotFontLoaderManager`.
By default the robot will load the material icons and the fonts defined in your `pubspec.yml`. (`MaterialIconsFontLoader` and `PubspecFontLoader`)

If you need load a font different of the default you can create a custom `RobotFontLoader` and add in the `RobotFontLoaderManager`. Like this:

```dart

import 'package:flutter_robot/flutter_robot.dart';

class MyCustomIconFontLoader extends RobotFontLoader{

  @override
  Future<void> load() async {
    // Load here your font
  }
}


```

Create a file in your `test` folder named `flutter_test_config.dart`.

```dart

import 'dart:async';

import 'package:flutter_robot/flutter_robot.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  RobotFontLoaderManager().add(MyCustomIconFontLoader());
  return testMain();
}


```

Or just override the method `fontLoaders` in your `Robot` class.

```dart

import 'dart:async';

import 'package:flutter_robot/flutter_robot.dart';

class MyRobot extends Robot {
  
  List<RobotFontLoader> get fontLoaders => [
    MyCustomIconFontLoader(),
  ];

}

```

## Loading Assets

The robot will try load all ImageProvider present in the widget tree.

If you need load a asset diferrent of ImageProvider you can do override of method `onLoadAssets` and do it there using `loadImageProvider`.

To load assets manually during the test you can call `loadAsyncImageProvider`;

## Golden diff threshold

Is common we work in the OS different than CI. In this cases could get breaked tests by little difference of pixels in your golden test when running in CI.

To try avoid this failures you could set a `threshold`. The `threshold` default is 1%, tha is, if the golden test failure with 0.5% of diff your test will pass.

To change this default value you can set it in `RobotFileComparator`.

Using the file `flutter_test_config.dart`:

```dart

import 'dart:async';

import 'package:flutter_robot/flutter_robot.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  RobotFileComparator.thresholdDefault = 0.05; // 5%
  return testMain();
}


```

You also can setting a specific `threshold` to a Robot, just pass the param `goldenThreshold` in your super. This way just in this Robot test will use this `threshold`:

```dart

class ExamplePageRobot extends Robot {
  ExamplePageRobot({
    required super.tester,
    required super.scenario,
  }):super(goldenThreshold:0.05);

  ...
}

```

If necessary you can customize the functions `compare`, `udpdate`, or `getTestUri` of `RobotFileComparator`.

Using the file `flutter_test_config.dart`:

```dart

import 'dart:async';

import 'package:flutter_robot/flutter_robot.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  RobotFileComparator.customGetTestUri = // set here your function
  RobotFileComparator.customCompare = // set here your function
  RobotFileComparator.customUpdate = // set here your function
  return testMain();
}


```


## Golden files of example tests

| Sunny |  Night   |  Sunny cloudy   |
| :---:   | :---: | :---: |
| ![](https://raw.githubusercontent.com/RafaelBarbosatec/flutter_robot/refs/heads/main/example/test/presentation/home/golden_files/HomePage_sunny.png) | ![](https://raw.githubusercontent.com/RafaelBarbosatec/flutter_robot/refs/heads/main/example/test/presentation/home/golden_files/HomePage_night_clear.png)   | ![](https://raw.githubusercontent.com/RafaelBarbosatec/flutter_robot/refs/heads/main/example/test/presentation/home/golden_files/HomePage_sunny_cloudy.png)   |


You can see a example [here](https://github.com/RafaelBarbosatec/flutter_robot/blob/main/example)
