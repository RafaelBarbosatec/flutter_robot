import 'package:flutter_robot_example/src/data/model/weather_response.dart';
import 'package:flutter_robot_example/src/infra/adapters/http/http_client.dart';

abstract class WeatherDatasource {
  Future<WeatherResponse> getCurrentWeather({
    required String location,
    String lang = 'pt',
  });
}

class WeatherDatasourceImpl implements WeatherDatasource {
  final HttpClient client;

  WeatherDatasourceImpl({required this.client});

  @override
  Future<WeatherResponse> getCurrentWeather({
    required String location,
    String lang = 'pt',
  }) {
    return client.get(
      path: 'current.json',
      queryParams: {
        'q': location,
        'lang': lang,
      },
    ).then((resp) {
      return WeatherResponse.fromJson(resp.body);
    });
  }
}
