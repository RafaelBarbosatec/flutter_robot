import 'package:flutter/material.dart';

class MyWidgetTest extends StatefulWidget {
  final bool isSunny;
  const MyWidgetTest({super.key, required this.isSunny});

  @override
  State<MyWidgetTest> createState() => _MyWidgetTestState();
}

class _MyWidgetTestState extends State<MyWidgetTest> {
  late bool isSunny;

  @override
  void initState() {
    isSunny = widget.isSunny;
    super.initState();
  }

  void toggle() {
    setState(() {
      isSunny = !isSunny;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
          onTap: toggle,
          child: isSunny ? const Icon(Icons.sunny) : const Icon(Icons.cloud),
        ),
      ),
    );
  }
}
