import 'package:flutter/material.dart';
import 'package:flutter_robot_example/src/bootstrap.dart';
import 'package:flutter_robot_example/src/presentation/home/home_page.dart';

void main() async {
  await Bootstrap.run();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
