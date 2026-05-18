import 'package:flutter/material.dart';
import 'package:hero_ui_flutter/hero_ui_flutter.dart';

import 'app_brand_theme.dart';
import 'pages/home_page.dart';

void main() {
  final themeData = AppBrandTheme();
  runApp(HeroUIExampleApp(themeData: themeData));
}

class HeroUIExampleApp extends StatefulWidget {
  const HeroUIExampleApp({required this.themeData, super.key});

  final HUFThemeData themeData;

  @override
  State<HeroUIExampleApp> createState() => _HeroUIExampleAppState();
}

class _HeroUIExampleAppState extends State<HeroUIExampleApp> {
  ThemeMode _themeMode = ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hero UI Flutter',
      themeMode: _themeMode,
      theme: HUFTheme.light(data: widget.themeData).toThemeData(),
      darkTheme: HUFTheme.dark(data: widget.themeData).toThemeData(),
      home: HomePage(
        onToggleTheme: () {
          setState(() {
            _themeMode = _themeMode == ThemeMode.light
                ? ThemeMode.dark
                : ThemeMode.light;
          });
        },
      ),
    );
  }
}
