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

In this first example will not use scenarios. So, we setted fixed scenario to 'RobotScenario.none()'.

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

We not go do anything here in the moment. But you already can know that in `injectDependencies` method you will insert the code of inject the page dependencies and the `mockScenario` method you will insert the code of mock the specific scenarios.

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
    required super.scenario,
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
  testWidgets('Should show the success case correctly', (tester) async {
    final robot = ExamplePageRobot(
      tester: tester,
      scenario: ExamplePageSuccess(),
    );
    await robot.configure();
    await robot.assertSuccessScreenGolden();
  });
}

```

That is it. Now just run command to create a golden files if you using the golden test.

## Runing test in multi devices

To run your `Robot` test in multi devices simulating `statusBar`,`Keyboard opened` or `ios home button` you can use `MultiDeviceRobot`.

```dart

void main() {
  testWidgets('Should run in all devices', (tester) async {
    await MultiDeviceRobot<MyFeaturePageRobot>(
      robot: MyFeaturePageRobot(tester: tester),
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

## Loading Assets

If your test need load some assets like a image to show in golden just pass it in the 'assets' get in your 'Robot' class.

```dart

class MyFeaturePageRobot extends Robot {
  DevicesRobot({
    required super.tester,
  }) : super(
          scenario: RobotScenario.none(),
        );

  @override
  List<ImageProvider<Object>> get assets => [
        const AssetImage('my/path/image.png'),
      ];

  @override
  Widget build() {
    return const MyFeaturePage();
  }

}

```

If you need load a asset diferrent of ImageProvider you can do override of method `onLoadAssets` and do it there.
