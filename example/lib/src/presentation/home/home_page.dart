import 'package:flutter/material.dart';
import 'package:flutter_robot_example/src/infra/constants/weather_gradients.dart';
import 'package:flutter_robot_example/src/infra/constants/weather_images.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Brightness textBrightess = Brightness.dark;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: WeatherGradients.day,
        ),
        child: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'São Paulo/SP BR',
                    style: TextStyle(
                      color: _getTextColor(textBrightess),
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Text(
                    '23:13',
                    style: TextStyle(
                      color: _getTextColor(textBrightess),
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Image.asset(
                          WeatherImages.sunny,
                          width: MediaQuery.of(context).size.width * 0.4,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        'Sunny',
                        style: TextStyle(
                          color: _getTextColor(textBrightess),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        '25º',
                        style: TextStyle(
                          color: _getTextColor(textBrightess),
                          fontWeight: FontWeight.bold,
                          fontSize: 43,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
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
