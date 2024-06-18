import 'package:flutter_robot_example/src/data/model/weather_response.dart';
import 'package:flutter_robot_example/src/infra/adapters/http/http_client.dart';

abstract class WeatherDatasource {
  Future<WeatherResponse> getCurrentWeather({required String location});
}

class WeatherDatasourceImpl implements WeatherDatasource {
  final HttpClient client;

  WeatherDatasourceImpl({required this.client});

  @override
  Future<WeatherResponse> getCurrentWeather({required String location}) {
    return client.get(
      path: 'current.json',
      queryParams: {
        'q': location,
      },
    ).then((resp) {
      return WeatherResponse.fromJson(resp.body);
    });
  }
}
