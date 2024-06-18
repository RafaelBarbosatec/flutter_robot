// ignore_for_file: type_literal_in_constant_pattern

import 'package:flutter_robot_example/src/domain/entities/weather_entity.dart';

abstract class HomeState {
  T whenOr<T>({
    T Function()? initial,
    T Function(String text)? loading,
    T Function(WeatherEntity eather)? loaded,
    required T Function() or,
  }) {
    switch (runtimeType) {
      case HomeStateInitial:
        return initial?.call() ?? or();
      case HomeStateLoading:
        return loading?.call((this as HomeStateLoading).text) ?? or();
      case HomeStateLoaded:
        return loaded?.call((this as HomeStateLoaded).weather) ?? or();
      default:
        return or();
    }
  }
}

class HomeStateInitial extends HomeState {}

class HomeStateLoading extends HomeState {
  final String text;

  HomeStateLoading({required this.text});
}

class HomeStateLoaded extends HomeState {
  final WeatherEntity weather;

  HomeStateLoaded({required this.weather});
}
