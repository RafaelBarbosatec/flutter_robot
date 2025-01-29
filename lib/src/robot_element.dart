import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

class RobotElement {
  final Finder finder;
  final WidgetTester tester;

  const RobotElement({required this.finder, required this.tester});

  factory RobotElement.byKey(Key key, WidgetTester tester) {
    return RobotElement(finder: find.byKey(key), tester: tester);
  }

  factory RobotElement.byType(Type type, WidgetTester tester) {
    return RobotElement(finder: find.byType(type), tester: tester);
  }

  factory RobotElement.byText(String text, WidgetTester tester) {
    return RobotElement(finder: find.text(text), tester: tester);
  }

  factory RobotElement.byIcon(IconData icon, WidgetTester tester) {
    return RobotElement(finder: find.byIcon(icon), tester: tester);
  }

  bool isVisible() {
    return tester.any(finder);
  }

  void assertIsVisible() {
    expect(finder, findsOne);
  }

  void assertIsNotVisible() {
    expect(finder, findsNothing);
  }

  Future<void> tap() async {
    await tester.tap(finder);
    await _awaitForAnimations();
  }

  Future<void> enterText(String text) async {
    await tester.enterText(finder, text);
    await _awaitForAnimations();
  }

  Future<void> scrollTo({
    double delta = 100,
    FinderBase<Element>? scrollable,
    Duration duration = const Duration(milliseconds: 50),
    int maxScrolls = 50,
  }) async {
    await tester.scrollUntilVisible(
      finder,
      delta,
      duration: duration,
      scrollable: scrollable,
      maxScrolls: maxScrolls,
    );
    await _awaitForAnimations();
  }

  Future<void> longPress() async {
    await tester.longPress(finder);
    await _awaitForAnimations();
  }

  String? get text {
    final widget = tester.widget<Text>(finder);
    return widget.data;
  }

  Future<void> waitUntilVisible({
    Duration timeout = const Duration(seconds: 10),
  }) async {
    bool foundElement = false;
    int counter = 0;
    int maxCounter = timeout.inMilliseconds ~/ 100;

    while (!foundElement && counter < maxCounter) {
      await tester.pump();

      foundElement = tester.any(finder);

      await tester.runAsync(() async {
        await Future.delayed(const Duration(milliseconds: 100));
      });
      counter++;
    }

    if (!foundElement) {
      throw Exception('waitUntilVisible timeout -> $finder');
    }
  }

  Future<void> _awaitForAnimations() async {
    try {
      await tester.pumpAndSettle();
    } catch (e) {
      await tester.pump();
    }
  }
}
