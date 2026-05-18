import 'package:flutter/material.dart';
import 'package:hero_ui_flutter/hero_ui_flutter.dart';

import 'app_brand_theme.dart';

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
      home: _ButtonShowcasePage(
        isDark: _themeMode == ThemeMode.dark,
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

class _ButtonShowcasePage extends StatelessWidget {
  const _ButtonShowcasePage({
    required this.isDark,
    required this.onToggleTheme,
  });

  final bool isDark;
  final VoidCallback onToggleTheme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HUFButton'),
        actions: [
          IconButton(
            onPressed: onToggleTheme,
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            tooltip: isDark ? 'Light mode' : 'Dark mode',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          HUFButton(label: 'Primary', onPressed: () {}),
          const SizedBox(height: 12),
          HUFButton(
            label: 'Secondary',
            variant: HUFButtonVariant.secondary,
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          HUFButton(
            label: 'Outlined',
            variant: HUFButtonVariant.outlined,
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          HUFButton(
            label: 'Ghost',
            variant: HUFButtonVariant.ghost,
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          HUFButton(
            label: 'Danger',
            variant: HUFButtonVariant.danger,
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          HUFButton(
            label: 'Danger soft',
            variant: HUFButtonVariant.dangerSoft,
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          HUFButton(
            label: 'Con icona',
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          HUFButton(
            label: 'Full width',
            isFullWidth: true,
            onPressed: () {},
          ),
          const SizedBox(height: 24),
          const Text('Icon only', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              HUFButton.iconOnly(
                icon: const Icon(Icons.add),
                onPressed: () {},
              ),
              HUFButton.iconOnly(
                icon: const Icon(Icons.delete_outline),
                variant: HUFButtonVariant.danger,
                onPressed: () {},
              ),
              HUFButton.iconOnly(
                icon: const Icon(Icons.favorite_border),
                variant: HUFButtonVariant.dangerSoft,
                onPressed: () {},
              ),
              HUFButton.iconOnly(
                icon: const Icon(Icons.settings_outlined),
                variant: HUFButtonVariant.outlined,
                onPressed: () {},
              ),
              const HUFButton.iconOnly(
                icon: Icon(Icons.lock_outline),
                onPressed: null,
              ),
            ],
          ),
          const SizedBox(height: 24),
          const HUFButton(label: 'Disabilitato', onPressed: null),
          const SizedBox(height: 12),
          const HUFButton(
            label: 'Loading',
            isLoading: true,
            onPressed: _noop,
          ),
        ],
      ),
    );
  }
}

void _noop() {}
