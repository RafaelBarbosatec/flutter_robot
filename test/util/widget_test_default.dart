import 'package:flutter/material.dart';

class WidgetTestDefault extends StatelessWidget {
  const WidgetTestDefault({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {},
              child: const Text('Primary button'),
            ),
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.account_box_outlined),
                    SizedBox(height: 16),
                    FlutterLogo(
                      size: 100,
                    ),
                    SizedBox(height: 16),
                    Icon(Icons.ac_unit_outlined),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Primary button'),
            ),
          ],
        ),
      ),
    );
  }
}
