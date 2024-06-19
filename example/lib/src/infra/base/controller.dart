import 'package:flutter/widgets.dart';

abstract class Controller<T> {
  late ValueNotifier<T> notifier;
  Controller({required T initialState}) {
    notifier = ValueNotifier(initialState);
  }

  T get state => notifier.value;
  void setState(T newState) {
    notifier.value = newState;
  }
}
