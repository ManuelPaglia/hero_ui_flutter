import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hero_ui_flutter/hero_ui_flutter.dart';

import 'example_app_scope.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const HeroUIExampleApp());
}

class HeroUIExampleApp extends StatefulWidget {
  const HeroUIExampleApp({super.key});

  @override
  State<HeroUIExampleApp> createState() => _HeroUIExampleAppState();
}

class _HeroUIExampleAppState extends State<HeroUIExampleApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  ThemeMode _themeMode = ThemeMode.light;
  HUFThemePreset _colorTheme = HUFThemePreset.defaultTheme;
  HUFBorderRadius _borderRadius = HUFBorderRadius.medium;

  ThemeData _buildTheme(Brightness brightness) {
    final themeData = HUFThemeData(
      theme: _colorTheme,
      borderRadius: _borderRadius,
    );
    final hufTheme = HUFTheme.fromData(
      themeData,
      brightness: brightness,
    );
    final inter = GoogleFonts.interTextTheme();

    return hufTheme.toThemeData(
      base: ThemeData(
        useMaterial3: true,
        brightness: brightness,
        textTheme: inter,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExampleAppScope(
      colorTheme: _colorTheme,
      onColorThemeChanged: (theme) {
        setState(() => _colorTheme = theme);
      },
      borderRadius: _borderRadius,
      onBorderRadiusChanged: (radius) {
        setState(() => _borderRadius = radius);
      },
      onToggleTheme: () {
        setState(() {
          _themeMode =
              _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
        });
      },
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        title: 'Hero UI Flutter',
        themeMode: _themeMode,
        theme: _buildTheme(Brightness.light),
        darkTheme: _buildTheme(Brightness.dark),
        builder: (context, child) => HUFAlertOverlay(child: child!),
        home: const HomePage(),
      ),
    );
  }
}
