import 'dart:io';

import 'package:flutter_robot_example/src/data/weather_datasource.dart';
import 'package:flutter_robot_example/src/domain/entities/weather_entity.dart';
import 'package:flutter_robot_example/src/domain/mappers/weather_entity_mapper.dart';

abstract class GetWeatherUsecase {
  Future<WeatherEntity> call(String location);
}

class GetWeatherUsecaseImpl implements GetWeatherUsecase {
  final WeatherDatasource weatherDatasource;

  GetWeatherUsecaseImpl({
    required this.weatherDatasource,
  });

  @override
  Future<WeatherEntity> call(String location) async {
    return weatherDatasource
        .getCurrentWeather(
          location: location,
          lang: Platform.localeName.substring(0, 2),
        )
        .then(WeatherEntityMapper.toEntity);
  }
}
