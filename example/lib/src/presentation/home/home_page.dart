import 'package:flutter/material.dart';
import 'package:flutter_robot_example/src/domain/entities/weather_entity.dart';
import 'package:flutter_robot_example/src/infra/base/controller_builder.dart';
import 'package:flutter_robot_example/src/infra/constants/weather_gradients.dart';
import 'package:flutter_robot_example/src/infra/di/service_locator.dart';
import 'package:flutter_robot_example/src/presentation/home/controller/home_controller.dart';
import 'package:flutter_robot_example/src/presentation/home/controller/home_state.dart';
import 'package:flutter_robot_example/src/presentation/home/weather_img_mapper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeController controller;

  @override
  void initState() {
    controller = ServiceLocator.get();
    controller.load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ControllerBuilder<HomeState>(
        controller: controller,
        builder: (context, state) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: state.whenOr(
              loading: (text) {
                return Center(
                  child: Text(text),
                );
              },
              loaded: (weather) {
                return _Content(
                  weather: weather,
                );
              },
              or: SizedBox.new,
            ),
          );
        },
      ),
    );
  }
}

class _Content extends StatelessWidget {
  static const imgSize = 200.0;
  final WeatherEntity weather;
  const _Content({required this.weather});

  @override
  Widget build(BuildContext context) {
    Brightness textBrightess =
        weather.condition.isCLoudy ? Brightness.light : Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: _getGradient(weather.isDay, weather.condition.isCLoudy),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${weather.location.region} - ${weather.location.country}',
                  style: TextStyle(
                    color: _getTextColor(textBrightess),
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Text(
                  _getTime(weather.lastUpdated),
                  style: TextStyle(
                    color: _getTextColor(textBrightess),
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Center(
                      child: Container(
                        constraints: const BoxConstraints(
                          maxWidth: imgSize,
                          maxHeight: imgSize,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: [
                              Colors.white.withOpacity(0.4),
                              Colors.white.withOpacity(0.0),
                            ],
                          ),
                        ),
                        child: Image.asset(
                          WeatherImgMapper.mapWeatherConditionToImage(
                            weather.condition,
                            weather.isDay,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        weather.condition.text,
                        style: TextStyle(
                          color: _getTextColor(textBrightess),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Center(
                      child: Text(
                        '${weather.tempC.toInt()}º',
                        style: TextStyle(
                          color: _getTextColor(textBrightess),
                          fontWeight: FontWeight.bold,
                          fontSize: 43,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Color _getTextColor(Brightness textBrightess) {
    return textBrightess == Brightness.dark ? Colors.white : Colors.black;
  }

  String _getTime(DateTime lastUpdated) {
    return '${lastUpdated.hour.toString().padLeft(2, '0')}:${lastUpdated.minute.toString().padLeft(2, '0')}';
  }

  LinearGradient _getGradient(bool isDay, bool isCLoudy) {
    if (isDay) {
      return isCLoudy ? WeatherGradients.dayCloudy : WeatherGradients.day;
    } else {
      return WeatherGradients.night;
    }
  }
}
