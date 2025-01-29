import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_robot/src/assets/assets_loader.dart';
import 'package:flutter_robot/src/assets/test_asset_bundle.dart';
import 'package:flutter_robot/src/font_loader/robot_font_loader.dart';
import 'package:flutter_robot/src/robot_scenario.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'device/robot_device.dart';
import 'robot_file_comparator.dart';

export 'device/multi_device_robot.dart';
export 'device/robot_device.dart';

class NavigatorObserverMock extends Mock implements NavigatorObserver {}

typedef WidgetWrapper = Widget Function(Widget);

abstract class Robot<S extends RobotScenario> {
  String _currentRouteName = '/';
  Object? _currentRouteArguments;
  final WidgetTester tester;
  late NavigatorObserver navigatorObserver;
  S? _scenario;
  S get scenario {
    if (_scenario == null) {
      throw Exception('Scenario is not set');
    }
    return _scenario!;
  }

  RobotDevice? _device;

  final List<LocalizationsDelegate>? localizationDelegate;
  final Locale locale;
  final RobotDevice? device;
  final RouteFactory? onGenerateRoute;
  final List<NavigatorObserver> navigatorObservers;
  final ThemeData? theme;
  final WidgetWrapper? wrapper;
  final Map<String, WidgetBuilder> routes;
  final double? goldenThreshold;

  List<RobotFontLoader> get fontLoaders => [];
  final List<RobotFontLoader> _fontLoadersDefault = [
    MaterialIconsFontLoader(),
    PubspecFontLoader(),
  ];

  List<ImageProvider> get assets => [];

  Widget build();

  Robot({
    required this.tester,
    S? scenario,
    this.localizationDelegate,
    this.device,
    this.onGenerateRoute,
    this.navigatorObservers = const [],
    this.theme,
    this.wrapper,
    this.routes = const {},
    this.locale = const Locale('pt', 'BR'),
    this.goldenThreshold,
  }) : _scenario = scenario {
    if (goldenThreshold != null) {
      assert(goldenThreshold! >= 0 && goldenThreshold! <= 1);
    }
    registerFallbackValue(
      MaterialPageRoute<Widget>(builder: (_) => Container()),
    );
    navigatorObserver = NavigatorObserverMock();
  }

  Future<void> setup({S? scenario}) async {
    _scenario = scenario ?? _scenario;
    await injectDependencies();
    await mockScenario();
    await loadFonts();
    _configFileComparator();
    await _widgetSetup(build());
  }

  Future<void> injectDependencies() async {
    await _scenario?.injectDependencies();
  }

  Future<void> mockScenario() async {
    await _scenario?.mockScenario();
  }

  Future<void> loadFonts() async {
    RobotFontLoaderManager.instance.addAll(
      [
        ..._fontLoadersDefault,
        ...fontLoaders,
      ],
    );

    await RobotFontLoaderManager.instance.load();
  }

  void setDevice(RobotDevice device) {
    _device = device;
  }

  Future<void> onLoadAssets() async {
    await AssetsLoader.defaultPrimeAssets(tester);
    if (assets.isNotEmpty) {
      Element element = tester.element(find.byType(MaterialApp));
      for (var asset in assets) {
        await precacheImage(asset, element);
      }
    }
    await tester.pump();
  }

  void _applyDevice(RobotDevice device) {
    tester.view.physicalSize = device.sizeScreen;
    tester.view.devicePixelRatio = device.pixelRatio;
    tester.platformDispatcher.textScaleFactorTestValue = device.textScale;
  }

  Future<void> _widgetSetup(Widget widget) async {
    final deviceSelected = _device ?? device ?? RobotDevice.medium();
    _applyDevice(deviceSelected);

    final themeToUse = theme ?? ThemeData.light();

    await tester.pumpWidget(
      DefaultAssetBundle(
        bundle: TestAssetBundle(),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: MediaQuery(
            data: const MediaQueryData(),
            child: DeviceSimulator(
              device: deviceSelected,
              theme: themeToUse,
              widget: wrapper?.call(widget) ??
                  MaterialApp(
                    debugShowCheckedModeBanner: false,
                    theme: themeToUse,
                    navigatorObservers: [
                      navigatorObserver,
                      ...navigatorObservers,
                    ],
                    localizationsDelegates: [
                      if (localizationDelegate != null)
                        ...localizationDelegate!,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    locale: locale,
                    supportedLocales: [locale],
                    routes: {
                      '/': (_) => widget,
                      ...routes,
                    },
                    onGenerateRoute: (settings) {
                      _currentRouteName = settings.name ?? '';
                      _currentRouteArguments = settings.arguments;
                      return onGenerateRoute?.call(settings) ??
                          MaterialPageRoute<Widget>(
                            builder: (_) => Container(),
                            settings: settings,
                          );
                    },
                  ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.runAsync(onLoadAssets);
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

  @Deprecated("Use RobotElement")
  Future<void> tap(FinderBase<Element> finder) async {
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  @Deprecated("Use RobotElement")
  Future<void> tapByKey(Key key) {
    return tap(find.byKey(key));
  }

  @Deprecated("Use RobotElement")
  Future<void> tapByText(String text) {
    return tap(find.text(text));
  }

  @Deprecated("Use RobotElement")
  Future<void> enterText(FinderBase<Element> finder, String text) async {
    await tester.enterText(finder, text);
    await tester.pumpAndSettle();
  }

  @Deprecated("Use RobotElement")
  Future<void> enterTextByKey(Key key, String text) {
    return enterText(find.byKey(key), text);
  }

  @Deprecated("Use RobotElement")
  Future<void> pumpUntilFound(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    bool timerDone = false;
    final timer = Timer(timeout, () => timerDone = true);
    while (timerDone != true) {
      await tester.pump();

      final found = tester.any(finder);
      if (found) {
        timerDone = true;
      }
    }
    timer.cancel();
  }

  Future<void> loadAsyncImageProvider(ImageProvider provider) async {
    await tester.runAsync(() async {
      await loadImageProvider(provider);
    });
  }

  Future<void> loadImageProvider(ImageProvider provider) async {
    Element element = tester.element(find.byType(MaterialApp));
    await precacheImage(provider, element);
    await tester.pumpAndSettle();
  }

  void assertNavigatorRoute(String routeName, {dynamic argumentMatcher}) {
    expect(_currentRouteName, routeName);
    if (argumentMatcher != null) {
      expect(_currentRouteArguments, argumentMatcher);
    }
  }

  void assertNavigatorPop({dynamic matcher = 1}) {
    verify(() => navigatorObserver.didPop(any(), any())).called(matcher);
  }

  void _configFileComparator() {
    if (goldenFileComparator is LocalFileComparator) {
      if (goldenFileComparator is RobotFileComparator) {
        (goldenFileComparator as RobotFileComparator).threshold =
            goldenThreshold ?? RobotFileComparator.thresholdDefault;
        return;
      }

      final testUrl = (goldenFileComparator as LocalFileComparator).basedir;

      goldenFileComparator = RobotFileComparator(
        Uri.parse('$testUrl/test. dart'),
        goldenThreshold ?? RobotFileComparator.thresholdDefault,
      );
    }
  }
}
