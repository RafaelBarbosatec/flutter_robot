import 'package:flutter/material.dart';
import 'package:flutter_robot_example/src/infra/base/controller.dart';

typedef ControllerBuilderCallback<T> = Widget Function(
  BuildContext context,
  T state,
);

class ControllerBuilder<T> extends StatelessWidget {
  final Controller<T> controller;
  final ControllerBuilderCallback<T> builder;
  const ControllerBuilder({
    super.key,
    required this.controller,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller.notifier,
      builder: (context, child) {
        return builder(context, controller.state);
      },
    );
  }
}
