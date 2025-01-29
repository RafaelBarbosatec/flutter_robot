import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

class RobotDevice {
  final String name;
  final Size sizeScreen;
  final double pixelRatio;
  final double textScale;
  final EdgeInsets viewPadding;
  final bool withIOSHomeButton;
  final bool withStatusBar;
  final bool withKeyboard;

  RobotDevice({
    required this.name,
    required this.sizeScreen,
    this.pixelRatio = 1.0,
    this.textScale = 1.0,
    this.viewPadding = EdgeInsets.zero,
    this.withIOSHomeButton = false,
    this.withStatusBar = false,
    this.withKeyboard = false,
  });

  // Font of device sizes and pixel ratio:
  // https://mediag.com/blog/popular-screen-resolutions-designing-for-all/
  // https://www.oxyplug.com/optimization/device-pixel-ratio/

  RobotDevice.small({
    this.withIOSHomeButton = true,
    this.withStatusBar = true,
    this.withKeyboard = false,
  })  : name = 'small',
        sizeScreen = const Size(640, 1136),
        pixelRatio = 2.0,
        textScale = 1.0,
        viewPadding = EdgeInsets.zero;

  RobotDevice.medium({
    this.withIOSHomeButton = true,
    this.withStatusBar = true,
    this.withKeyboard = false,
  })  : name = 'medium',
        sizeScreen = const Size(1440, 2960),
        pixelRatio = 4.0,
        textScale = 1.0,
        viewPadding = EdgeInsets.zero;

  RobotDevice.large({
    this.withIOSHomeButton = true,
    this.withStatusBar = true,
    this.withKeyboard = false,
  })  : name = 'large',
        sizeScreen = const Size(1440, 2560),
        pixelRatio = 3.0,
        textScale = 1.0,
        viewPadding = EdgeInsets.zero;

  @override
  // ignore: hash_and_equals
  bool operator ==(Object other) {
    if (other is! RobotDevice) {
      return false;
    }
    RobotDevice o = other;
    return o.sizeScreen == sizeScreen &&
        o.pixelRatio == pixelRatio &&
        o.textScale == textScale;
  }
}

class DeviceSimulator extends StatelessWidget {
  final Widget widget;
  final RobotDevice device;
  final ThemeData theme;
  static const iosHomeButonHeight = 34.0;
  static const statusBarHeight = 24.0;
  static const keyboardHeight = 282.0;

  const DeviceSimulator({
    super.key,
    required this.widget,
    required this.device,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context);

    return Stack(
      children: [
        MediaQuery(
          data: mediaquery.copyWith(
            padding: EdgeInsets.only(
              bottom: device.withIOSHomeButton ? iosHomeButonHeight : 0,
              top: device.withStatusBar ? statusBarHeight : 0,
            ),
            viewInsets: device.withKeyboard
                ? const EdgeInsets.only(
                    bottom: keyboardHeight,
                  )
                : null,
          ),
          child: widget,
        ),
        if (device.withStatusBar)
          Align(
            alignment: Alignment.topCenter,
            child: _StatusBar(
              systemOverlayStyle: theme.appBarTheme.systemOverlayStyle,
            ),
          ),
        if (device.withIOSHomeButton)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: iosHomeButonHeight,
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                width: mediaquery.size.width / 2,
                height: 5,
              ),
            ),
          ),
        if (device.withKeyboard)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: keyboardHeight,
              width: double.maxFinite,
              color: Colors.black,
              child: const Center(
                child: Icon(
                  Icons.keyboard_alt_outlined,
                  size: keyboardHeight * 0.8,
                  color: Color(0xFFFFFFFF),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _StatusBar extends StatefulWidget {
  final SystemUiOverlayStyle? systemOverlayStyle;
  const _StatusBar({this.systemOverlayStyle});

  @override
  State<_StatusBar> createState() => StatusBarState();
}

class StatusBarState extends State<_StatusBar> {
  SystemUiOverlayStyle? style;

  SystemUiOverlayStyle? _getSystemOverlayStyle() {
    try {
      final appBar = find.byType(AnnotatedRegion<SystemUiOverlayStyle>);
      return (appBar.evaluate().single.widget
              as AnnotatedRegion<SystemUiOverlayStyle>)
          .value;
    } catch (e) {
      return null;
    }
  }

  void updateStyle() {
    setState(() {
      style = _getSystemOverlayStyle() ?? widget.systemOverlayStyle;
    });
  }

  @override
  void initState() {
    style = widget.systemOverlayStyle;
    WidgetsBinding.instance.addPostFrameCallback((_) => updateStyle());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final statusBarBrightness = style?.statusBarBrightness;
    final statusBarColor = style?.statusBarColor;
    final iconBrightness = style?.statusBarIconBrightness;
    final iconColor = _getIconColor(iconBrightness);
    return Container(
      height: DeviceSimulator.statusBarHeight,
      width: double.maxFinite,
      color: _getStatusBarColor(statusBarBrightness, statusBarColor),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Icon(
              Icons.abc,
              color: iconColor,
              size: DeviceSimulator.statusBarHeight,
            ),
            Expanded(child: Container()),
            Icon(
              Icons.signal_cellular_alt_rounded,
              color: iconColor,
              size: DeviceSimulator.statusBarHeight,
            ),
            const SizedBox(
              width: 8,
            ),
            Transform.rotate(
              angle: 1.5708,
              child: Icon(
                Icons.battery_5_bar_rounded,
                color: iconColor,
                size: DeviceSimulator.statusBarHeight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusBarColor(
    Brightness? statusBarBrightness,
    Color? statusBarColor,
  ) {
    if (statusBarColor != null) {
      return statusBarColor;
    }
    switch (statusBarBrightness ?? Brightness.dark) {
      case Brightness.dark:
        return const Color(0xFF000000).withOpacity(0.4);
      case Brightness.light:
        return const Color(0xFFFFFFFF).withOpacity(0.4);
    }
  }

  Color _getIconColor(Brightness? iconBrightness) {
    switch (iconBrightness ?? Brightness.light) {
      case Brightness.dark:
        return const Color(0xFF000000);
      case Brightness.light:
        return const Color(0xFFFFFFFF);
    }
  }
}
