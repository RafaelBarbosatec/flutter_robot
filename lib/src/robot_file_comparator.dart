import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

class RobotFileComparator extends LocalFileComparator {
  static Uri Function(Uri key, int? version)? customgetTestUri;
  static Future<bool> Function(Uint8List imageBytes, Uri golden)? customCompare;
  static Future<void> Function(Uri golden, Uint8List imageBytes)? customUpdate;
  static double thresholdDefault = 0.01;

  /// Threshold above which tests will be marked as failing.
  /// Ranges from 0 to 1, both inclusive.
  double threshold;

  RobotFileComparator(super.testFile, this.threshold)
      : assert(threshold >= 0 && threshold <= 1);

  /// Copy of [LocalFileComparator]'s [compare] method, except for the fact that
  /// it checks if the [ComparisonResult.diffPercent] is not greater than
  /// [threshold] to decide whether this test is successful or a failure.
  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    if (customCompare != null) {
      return customCompare!(imageBytes, golden);
    }
    final result = await GoldenFileComparator.compareLists(
      imageBytes,
      await getGoldenBytes(golden),
    );

    if (!result.passed && result.diffPercent <= threshold) {
      // ignore: avoid_print
      print(
        'A difference of ${result.diffPercent * 100}% was found, but it is '
        'acceptable since it is not greater than the threshold of '
        '${threshold * 100}%',
      );

      return true;
    }

    if (!result.passed) {
      final error = await generateFailureOutput(result, golden, basedir);
      throw FlutterError(error);
    }
    return result.passed;
  }

  @override
  Uri getTestUri(Uri key, int? version) {
    return customgetTestUri?.call(key, version) ??
        super.getTestUri(key, version);
  }

  @override
  Future<void> update(Uri golden, Uint8List imageBytes) {
    return customUpdate?.call(golden, imageBytes) ??
        super.update(golden, imageBytes);
  }
}
