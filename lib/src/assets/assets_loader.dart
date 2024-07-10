import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

abstract class AssetsLoader {
  static Future defaultPrimeAssets(WidgetTester tester) async {
    final imageElements = find.byType(Image, skipOffstage: false).evaluate();
    final containerElements = find
        .byType(
          DecoratedBox,
          skipOffstage: false,
        )
        .evaluate();
    for (final imageElement in imageElements) {
      final widget = imageElement.widget;
      if (widget is Image) {
        await precacheImage(widget.image, imageElement);
      }
    }
    for (final container in containerElements) {
      final widget = container.widget as DecoratedBox;
      final decoration = widget.decoration;
      if (decoration is BoxDecoration) {
        if (decoration.image != null) {
          await precacheImage(decoration.image!.image, container);
        }
      }
    }
  }
}
