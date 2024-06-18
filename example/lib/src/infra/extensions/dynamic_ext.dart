extension DynamicExt on dynamic {
  double toDouble() {
    if (this == null) {
      return 0.0;
    }
    return double.parse(toString());
  }
}
