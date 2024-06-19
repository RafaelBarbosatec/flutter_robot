import 'package:flutter_robot_example/src/domain/entities/weather_entity.dart';
import 'package:flutter_robot_example/src/domain/usercases/get_string_location_usecase.dart';
import 'package:flutter_robot_example/src/domain/usercases/get_weather_usecase.dart';

abstract class GetWeatherRoutine {
  Future<WeatherEntity> call();
}

class GetWeatherRoutineImpl implements GetWeatherRoutine {
  final GetWeatherUsecase getWeatherUsecase;
  final GetStringLocationUsecase getStringLocationUsecase;

  GetWeatherRoutineImpl({
    required this.getWeatherUsecase,
    required this.getStringLocationUsecase,
  });

  @override
  Future<WeatherEntity> call() async {
    final location = await getStringLocationUsecase();
    return getWeatherUsecase(location);
  }
}
