import 'package:flutter_robot_example/src/domain/usercases/get_weather_routine.dart';
import 'package:flutter_robot_example/src/infra/base/controller.dart';

import 'home_state.dart';

class HomeController extends Controller<HomeState> {
  final GetWeatherRoutine routine;

  HomeController({required this.routine})
      : super(initialState: HomeStateInitial());

  Future<void> load() async {
    setState(HomeStateLoading(text: 'Obtendo tempo...'));
    try {
      final resp = await routine();
      setState(HomeStateLoaded(weather: resp));
    } catch (e) {
      setState(HomeStateError());
    }
  }
}
