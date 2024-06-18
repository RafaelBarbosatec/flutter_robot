import 'package:flutter_robot_example/src/data/weather_datasource.dart';
import 'package:flutter_robot_example/src/domain/usercases/get_weather_usecase.dart';
import 'package:flutter_robot_example/src/infra/adapters/http/http_adapter.dart';
import 'package:flutter_robot_example/src/infra/adapters/http/http_client.dart';
import 'package:flutter_robot_example/src/infra/di/service_locator.dart';
import 'package:flutter_robot_example/src/presentation/home/home_controller.dart';

abstract class Bootstrap {
  static const ipAPIStanceName = 'ip-api';
  static const weatherAPIStanceName = 'weather-api';
  static Future<void> run() async {
    ServiceLocator.putLazySingleton<HttpClient>(
      () => HttpAdapter(baseUrl: 'http://ip-api.com/'),
      instanceName: ipAPIStanceName,
    );

    ServiceLocator.putLazySingleton<HttpClient>(
      () => HttpAdapter(
        baseUrl: 'https://api.weatherapi.com/v1/',
        
      ),
      instanceName: weatherAPIStanceName,
    );

    ServiceLocator.putFactory<WeatherDatasource>(() {
      return WeatherDatasourceImpl(
        client: ServiceLocator.get(
          instanceName: weatherAPIStanceName,
        ),
      );
    });

    ServiceLocator.putFactory<GetWeatherUsecase>(() {
      return GetWeatherUsecaseImpl(
        weatherDatasource: ServiceLocator.get(),
      );
    });

    ServiceLocator.putFactory(() {
      return HomeController(
        usecase: ServiceLocator.get(),
      );
    });
  }
}
