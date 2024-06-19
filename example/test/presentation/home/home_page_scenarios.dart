import 'dart:async';

import 'package:flutter_robot/flutter_robot.dart';
import 'package:flutter_robot_example/src/domain/entities/weather_entity.dart';
import 'package:flutter_robot_example/src/domain/usercases/get_weather_routine.dart';
import 'package:flutter_robot_example/src/infra/di/service_locator.dart';
import 'package:flutter_robot_example/src/presentation/home/controller/home_controller.dart';
import 'package:mocktail/mocktail.dart';

class GetWeatherRoutineMock extends Mock implements GetWeatherRoutine {}

abstract class HomePageScenarios extends RobotScenario {
  late GetWeatherRoutine routine;

  HomePageScenarios() {
    routine = GetWeatherRoutineMock();
  }

  @override
  FutureOr<void> injectDependencies() async {
    await ServiceLocator.reset();
    ServiceLocator.putLazySingleton(() => HomeController(routine: routine));
  }

  @override
  FutureOr<void> mockScenario() {}
}

class HomePageScenariosClear extends HomePageScenarios {
  final bool isDay;

  HomePageScenariosClear({required this.isDay});
  @override
  FutureOr<void> mockScenario() {
    when(
      () => routine(),
    ).thenAnswer(
      (_) async => WeatherEntity(
        tempC: 25,
        tempF: 25,
        location: WeatherLocationEntity(
          region: 'São Paulo',
          country: 'Brasil',
          lat: 0,
          lon: 0,
        ),
        condition: WeatherConditionEntity(
          text: isDay ? 'Sol' : 'Ceu limpo',
          code: 1000,
        ),
        isDay: isDay,
        lastUpdated: DateTime(2024),
      ),
    );
  }
}

class HomePageScenariosCloudy extends HomePageScenarios {
  final bool isDay;

  HomePageScenariosCloudy({required this.isDay});
  @override
  FutureOr<void> mockScenario() {
    when(
      () => routine(),
    ).thenAnswer(
      (_) async => WeatherEntity(
        tempC: 20,
        tempF: 20,
        location: WeatherLocationEntity(
          region: 'São Paulo',
          country: 'Brasil',
          lat: 0,
          lon: 0,
        ),
        condition:
            WeatherConditionEntity(text: 'Parcialmente Nublado', code: 1006),
        isDay: isDay,
        lastUpdated: DateTime(2024),
      ),
    );
  }
}
