import 'package:flutter_robot_example/src/data/ip_location_datasource.dart';
import 'package:flutter_robot_example/src/data/weather_datasource.dart';
import 'package:flutter_robot_example/src/domain/entities/weather_entity.dart';
import 'package:flutter_robot_example/src/domain/mappers/weather_entity_mapper.dart';

abstract class GetWeatherUsecase {
  Future<WeatherEntity> call();
}

class GetWeatherUsecaseImpl implements GetWeatherUsecase {
  final WeatherDatasource weatherDatasource;
  final IpLocationDatasource ipLocationDatasource;

  GetWeatherUsecaseImpl({
    required this.weatherDatasource,
    required this.ipLocationDatasource,
  });

  @override
  Future<WeatherEntity> call() async {
    final location = await ipLocationDatasource.getLocation();
    String loc =
        '${location.city}/${location.region} - ${location.countryCode}';
    return weatherDatasource
        .getCurrentWeather(location: loc)
        .then(WeatherEntityMapper.toEntity);
  }
}
