import 'package:flutter/material.dart';
import 'package:flutter_robot_example/src/domain/entities/weather_entity.dart';
import 'package:flutter_robot_example/src/infra/constants/weather_gradients.dart';
import 'package:flutter_robot_example/src/infra/constants/weather_images.dart';
import 'package:flutter_robot_example/src/infra/di/service_locator.dart';
import 'package:flutter_robot_example/src/presentation/home/home_controller.dart';

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
      body: ListenableBuilder(
        listenable: controller.state,
        builder: (context, snapshot) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: controller.state.value.whenOr(
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
  final WeatherEntity weather;
  const _Content({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    Brightness textBrightess =
        weather.isDay ? Brightness.dark : Brightness.light;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: weather.isDay ? WeatherGradients.day : WeatherGradients.night,
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
                  '${weather.lastUpdated.hour}:${weather.lastUpdated.minute}',
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        child: Image.asset(
                          WeatherImages.sunny,
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
    return switch (textBrightess) {
      Brightness.dark => Colors.white,
      Brightness.light => Colors.black,
    };
  }
}
