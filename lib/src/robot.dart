import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_robot/src/assets/assets_loader.dart';
import 'package:flutter_robot/src/assets/test_asset_bundle.dart';
import 'package:flutter_robot/src/font_loader/robot_font_loader.dart';
import 'package:flutter_robot/src/robot_scenario.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'device/robot_device.dart';

export 'device/multi_device_robot.dart';
export 'device/robot_device.dart';

class NavigatorObserverMock extends Mock implements NavigatorObserver {}

typedef WidgetWrapper = Widget Function(Widget);

abstract class Robot<S extends RobotScenario> {
  String _currentRouteName = '/';
  Object? _currentRouteArguments;
  final WidgetTester tester;
  late NavigatorObserver navigatorObserver;
  final S scenario;
  RobotDevice? _device;

  final List<LocalizationsDelegate>? localizationDelegate;
  final Locale locale;
  final RobotDevice? device;
  final RouteFactory? onGenerateRoute;
  final List<NavigatorObserver> navigatorObservers;
  final ThemeData? theme;
  final WidgetWrapper? wrapper;
  final Map<String, WidgetBuilder> routes;

  Widget build();

  Robot({
    required this.tester,
    required this.scenario,
    this.localizationDelegate,
    this.device,
    this.onGenerateRoute,
    this.navigatorObservers = const [],
    this.theme,
    this.wrapper,
    this.routes = const {},
    this.locale = const Locale('pt', 'BR'),
  }) {
    registerFallbackValue(
      MaterialPageRoute<Widget>(builder: (_) => Container()),
    );
    navigatorObserver = NavigatorObserverMock();
  }

  Future<void> setup() async {
    await scenario.injectDependencies();
    await scenario.mockScenario();
    await _widgetSetup(build());
  }

  void setDevice(RobotDevice device) {
    _device = device;
  }

  Future<void> onLoadAssets() async {
    final result = await AssetsLoader.defaultPrimeAssets(tester);
    if (result) {
      await tester.pumpAndSettle();
    }
  }

  void _applyDevice(RobotDevice device) {
    tester.view.physicalSize = device.sizeScreen;
    tester.view.devicePixelRatio = device.pixelRatio;
    tester.platformDispatcher.textScaleFactorTestValue = device.textScale;
  }

  Future<void> _widgetSetup(Widget widget) async {
    final deviceSelected = _device ?? device ?? RobotDevice.medium();
    _applyDevice(deviceSelected);

    await RobotFontLoaderManager.instance.load();

    final widgetToTest = DeviceSimulator(
      widget: widget,
      device: deviceSelected,
    );

    await tester.pumpWidget(
      DefaultAssetBundle(
        bundle: TestAssetBundle(),
        child: wrapper?.call(widgetToTest) ??
            MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: theme,
              navigatorObservers: [
                navigatorObserver,
                ...navigatorObservers,
              ],
              localizationsDelegates: [
                if (localizationDelegate != null) ...localizationDelegate!,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              locale: locale,
              supportedLocales: [locale],
              routes: {
                '/': (_) => widgetToTest,
                ..._mapRoutes(),
              },
              onGenerateRoute: (settings) {
                _currentRouteName = settings.name ?? '';
                _currentRouteArguments = settings.arguments;
                return onGenerateRoute?.call(settings);
              },
            ),
      ),
    );

    await tester.pumpAndSettle();

    await onLoadAssets();
  }

  NavigatorState? get navigator => navigatorObserver.navigator;

  Future<void> awaitForAnimations({Duration? duration}) async {
    try {
      await tester.pumpAndSettle(duration ?? const Duration(milliseconds: 300));
    } catch (e) {
      await tester.pump(duration);
    }
  }

  Future takeSnapshot(String filename) {
    String fileName = './golden_files/$filename.png';
    if (_device != null) {
      fileName = './golden_files/${filename}_${_device!.name}.png';
    }
    return expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile(fileName),
    );
  }

  Future<void> tap(FinderBase<Element> finder) async {
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> tapByKey(Key key) {
    return tap(find.byKey(key));
  }

  Future<void> tapByText(String text) {
    return tap(find.text(text));
  }

  Future<void> enterText(FinderBase<Element> finder, String text) async {
    await tester.enterText(finder, text);
    await tester.pumpAndSettle();
  }

  Future<void> enterTextByKey(Key key, String text) {
    return enterText(find.byKey(key), text);
  }

  void assertNavigatorRoute(String routeName) {
    expect(_currentRouteName, routeName);
  }

  void assertNavigatorArguments(dynamic matcher) {
    expect(_currentRouteArguments, matcher);
  }

  Map<String, WidgetBuilder> _mapRoutes() {
    return routes.map(
      (key, value) {
        return MapEntry(
          key,
          (BuildContext context) {
            return DeviceSimulator(
              widget: value(context),
              device: _device ?? RobotDevice.medium(),
            );
          },
        );
      },
    );
  }
}
