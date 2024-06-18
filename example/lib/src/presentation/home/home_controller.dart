import 'package:flutter/foundation.dart';
import 'package:flutter_robot_example/src/domain/usercases/get_weather_usecase.dart';

import 'home_state.dart';

class HomeController {
  final GetWeatherUsecase usecase;
  ValueNotifier<HomeState> state = ValueNotifier(HomeStateInitial());

  HomeController({required this.usecase});

  Future<void> load() async {
    state.value = HomeStateLoading(text: 'Obtendo tempo...');
    final resp = await usecase('São Paulo');
    state.value = HomeStateLoaded(weather: resp);
  }
}
