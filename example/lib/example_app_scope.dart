import 'package:flutter/material.dart';
import 'package:hero_ui_flutter/hero_ui_flutter.dart';

import 'pages/showcase_shared.dart';

/// Stato condiviso dell'app di esempio (tema colore, radius globale, toggle light/dark).
class ExampleAppScope extends InheritedWidget {
  const ExampleAppScope({
    required this.colorTheme,
    required this.onColorThemeChanged,
    required this.borderRadius,
    required this.onBorderRadiusChanged,
    required this.onToggleTheme,
    required super.child,
    super.key,
  });

  final HUFThemePreset colorTheme;
  final ValueChanged<HUFThemePreset> onColorThemeChanged;
  final HUFBorderRadius borderRadius;
  final ValueChanged<HUFBorderRadius> onBorderRadiusChanged;
  final VoidCallback onToggleTheme;

  static ExampleAppScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ExampleAppScope>();
    assert(scope != null, 'ExampleAppScope non trovato sopra il widget.');
    return scope!;
  }

  @override
  bool updateShouldNotify(ExampleAppScope oldWidget) {
    return colorTheme != oldWidget.colorTheme ||
        borderRadius != oldWidget.borderRadius;
  }
}

/// AppBar condivisa con selettore tema colore, radius e toggle light/dark.
class ShowcaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ShowcaseAppBar({
    required this.title,
    super.key,
  });

  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final scope = ExampleAppScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      title: Text(title),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<HUFThemePreset>(
              value: scope.colorTheme,
              isDense: true,
              borderRadius: BorderRadius.circular(8),
              items: [
                for (final theme in HUFThemePreset.values)
                  DropdownMenuItem(
                    value: theme,
                    child: Text(theme.label),
                  ),
              ],
              onChanged: (value) {
                if (value != null) {
                  scope.onColorThemeChanged(value);
                }
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<HUFBorderRadius>(
              value: scope.borderRadius,
              isDense: true,
              borderRadius: BorderRadius.circular(8),
              items: [
                for (final entry in showcaseRadiusPresets.entries)
                  DropdownMenuItem(
                    value: entry.value,
                    child: Text(entry.key),
                  ),
              ],
              onChanged: (value) {
                if (value != null) {
                  scope.onBorderRadiusChanged(value);
                }
              },
            ),
          ),
        ),
        IconButton(
          onPressed: scope.onToggleTheme,
          icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
          tooltip: isDark ? 'Light mode' : 'Dark mode',
        ),
      ],
    );
  }
}
