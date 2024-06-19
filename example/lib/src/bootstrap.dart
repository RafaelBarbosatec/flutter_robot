import 'package:flutter_robot_example/src/data/ip_location_datasource.dart';
import 'package:flutter_robot_example/src/data/weather_datasource.dart';
import 'package:flutter_robot_example/src/domain/usercases/get_string_location_usecase.dart';
import 'package:flutter_robot_example/src/domain/usercases/get_weather_routine.dart';
import 'package:flutter_robot_example/src/domain/usercases/get_weather_usecase.dart';
import 'package:flutter_robot_example/src/infra/adapters/http/http_adapter.dart';
import 'package:flutter_robot_example/src/infra/adapters/http/http_client.dart';
import 'package:flutter_robot_example/src/infra/di/service_locator.dart';
import 'package:flutter_robot_example/src/presentation/home/controller/home_controller.dart';

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
        queryParams: {
          'key': '549c54d6794f4e3f8c0223533241706',
        },
      ),
      instanceName: weatherAPIStanceName,
    );

    ServiceLocator.putLazySingleton<IpLocationDatasource>(() {
      return IpLocationDatasourceImpl(
          client: ServiceLocator.get(
        instanceName: ipAPIStanceName,
      ));
    });

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
    ServiceLocator.putFactory<GetStringLocationUsecase>(() {
      return GetStringLocationUsecaseImpl(
        ipLocationDatasource: ServiceLocator.get(),
      );
    });
    ServiceLocator.putFactory<GetWeatherRoutine>(() {
      return GetWeatherRoutineImpl(
        getStringLocationUsecase: ServiceLocator.get(),
        getWeatherUsecase: ServiceLocator.get(),
      );
    });

    ServiceLocator.putFactory(() {
      return HomeController(
        routine: ServiceLocator.get(),
      );
    });
  }
}
