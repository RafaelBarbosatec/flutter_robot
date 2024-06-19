import 'package:flutter_robot_example/src/data/model/weather_response.dart';
import 'package:flutter_robot_example/src/domain/entities/weather_entity.dart';

abstract class WeatherEntityMapper {
  static WeatherEntity toEntity(WeatherResponse model) {
    return WeatherEntity(
      isDay: model.current.isDay == 1,
      tempC: model.current.tempC,
      tempF: model.current.tempF,
      location: WeatherLocationEntity(
        region: model.location.region,
        country: model.location.country,
        lat: model.location.lat,
        lon: model.location.lon,
      ),
      condition: WeatherConditionEntity(
        text: model.current.condition.text,
        code: model.current.condition.code,
      ),
      lastUpdated: DateTime.parse(model.current.lastUpdated),
    );
  }
}
