import 'package:flutter_robot_example/src/domain/entities/weather_entity.dart';
import 'package:flutter_robot_example/src/infra/constants/weather_images.dart';

abstract class WeatherImgMapper {
  static String mapWeatherConditionToImage(
      WeatherConditionEntity weatherCondition, bool isDay) {
    switch (weatherCondition.code) {
      case 1000:
        return isDay ? WeatherImages.sunny : WeatherImages.moonStars;
      case 1003:
      case 1006:
      case 1009:
        return isDay ? WeatherImages.sunnyCloudy : WeatherImages.moonCloudy;
      case 1087:
      case 1273:
      case 1276:
      case 1279:
      case 1282:
        return WeatherImages.storm;
      case 1183:
      case 1186:
      case 1189:
      case 1192:
      case 1195:
      case 1198:
      case 1201:
      case 1240:
      case 1243:
      case 1246:
        return WeatherImages.raining;
    }
    return WeatherImages.sunny;
  }
}
