import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

abstract class ServiceLocator {
  static T get<T extends Object>({String? instanceName}) {
    return getIt.get<T>(instanceName: instanceName);
  }

  static void putLazySingleton<T extends Object>(
    FactoryFunc<T> factoryFunc, {
    String? instanceName,
  }) {
    getIt.registerLazySingleton<T>(
      factoryFunc,
      instanceName: instanceName,
    );
  }

  static void putFactory<T extends Object>(
    FactoryFunc<T> factoryFunc, {
    String? instanceName,
  }) {
    getIt.registerFactory<T>(
      factoryFunc,
      instanceName: instanceName,
    );
  }
}
