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

/// AppBar condivisa con [HUFSelect] per tema colore, radius e toggle light/dark.
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
    final brightness = isDark ? Brightness.dark : Brightness.light;

    final themeSelect = _ShowcaseThemeSelect(
      value: scope.colorTheme,
      brightness: brightness,
      onChanged: scope.onColorThemeChanged,
    );
    final radiusSelect = _ShowcaseRadiusSelect(
      value: scope.borderRadius,
      onChanged: scope.onBorderRadiusChanged,
    );
    final themeToggle = IconButton(
      onPressed: scope.onToggleTheme,
      icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
      tooltip: isDark ? 'Light mode' : 'Dark mode',
    );

    if (title.isEmpty) {
      return AppBar(
        titleSpacing: 16,
        title: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 6),
                child: themeSelect,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 6),
                child: radiusSelect,
              ),
            ),
          ],
        ),
        actions: [themeToggle],
      );
    }

    return AppBar(
      title: Text(title),
      actions: [
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 4),
          child: SizedBox(width: 148, child: themeSelect),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: SizedBox(width: 120, child: radiusSelect),
        ),
        themeToggle,
      ],
    );
  }
}

class _ShowcaseThemeSelect extends StatelessWidget {
  const _ShowcaseThemeSelect({
    required this.value,
    required this.brightness,
    required this.onChanged,
  });

  final HUFThemePreset value;
  final Brightness brightness;
  final ValueChanged<HUFThemePreset> onChanged;

  @override
  Widget build(BuildContext context) {
    return HUFSelect<HUFThemePreset>(
      value: value,
      isFullWidth: true,
      closeOnSelect: true,
      displayStringForValue: (preset) => preset.label,
      items: [
        for (final preset in HUFThemePreset.values)
          HUFSelectItem(
            value: preset,
            label: preset.label,
            leading: _ThemePresetSwatch(
              preset: preset,
              brightness: brightness,
            ),
          ),
      ],
      itemBuilder: (context, item, isSelected, onTap) {
        return _ThemePresetSelectItem(
          preset: item.value,
          label: item.label,
          brightness: brightness,
          isSelected: isSelected,
          onTap: onTap,
        );
      },
      onChanged: (selected) {
        if (selected != null) onChanged(selected);
      },
    );
  }
}

class _ShowcaseRadiusSelect extends StatelessWidget {
  const _ShowcaseRadiusSelect({
    required this.value,
    required this.onChanged,
  });

  final HUFBorderRadius value;
  final ValueChanged<HUFBorderRadius> onChanged;

  @override
  Widget build(BuildContext context) {
    return HUFSelect<HUFBorderRadius>(
      value: value,
      isFullWidth: true,
      displayStringForValue: _borderRadiusLabelFor,
      items: [
        for (final entry in showcaseRadiusPresets.entries)
          HUFSelectItem(
            value: entry.value,
            label: entry.key,
          ),
      ],
      onChanged: (selected) {
        if (selected != null) onChanged(selected);
      },
    );
  }
}

String _borderRadiusLabelFor(HUFBorderRadius radius) {
  for (final entry in showcaseRadiusPresets.entries) {
    if (entry.value.value == radius.value &&
        entry.value.full == radius.full) {
      return entry.key;
    }
  }
  return radius.value.toStringAsFixed(0);
}

/// Campione monocolore del primary del preset (per il menu tema).
class _ThemePresetSwatch extends StatelessWidget {
  const _ThemePresetSwatch({
    required this.preset,
    required this.brightness,
  });

  final HUFThemePreset preset;
  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    final primary = HUFThemeData(theme: preset)
        .resolveColors(brightness)
        .primary;

    return HUFAvatar(
      size: HUFAvatarSize.small,
      icon: const SizedBox.shrink(),
      backgroundColor: primary,
      foregroundColor: primary,
    );
  }
}

/// Voce custom del select tema (swatch + nome + check in multi — qui singola).
class _ThemePresetSelectItem extends StatefulWidget {
  const _ThemePresetSelectItem({
    required this.preset,
    required this.label,
    required this.brightness,
    required this.isSelected,
    required this.onTap,
  });

  final HUFThemePreset preset;
  final String label;
  final Brightness brightness;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  State<_ThemePresetSelectItem> createState() => _ThemePresetSelectItemState();
}

class _ThemePresetSelectItemState extends State<_ThemePresetSelectItem> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.hufTheme;
    final metrics = hufSelectMetricsFor(theme.borderRadius);
    final colors = hufSelectColorsFor(theme.colors);
    final radius = BorderRadius.circular(metrics.borderRadius);
    final highlight = widget.isSelected || _pressed;
    final enabled = widget.onTap != null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          onHighlightChanged: enabled
              ? (value) => setState(() => _pressed = value)
              : null,
          borderRadius: radius,
          child: Ink(
            decoration: BoxDecoration(
              color: highlight ? colors.itemHighlight : null,
              borderRadius: radius,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: metrics.itemVerticalPadding,
                horizontal: metrics.itemHorizontalPadding,
              ),
              child: Row(
                children: [
                  _ThemePresetSwatch(
                    preset: widget.preset,
                    brightness: widget.brightness,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.label,
                      style: hufSelectTextStyle(
                        fontSize: metrics.itemFontSize,
                        fontWeight: FontWeight.w500,
                        color: enabled
                            ? colors.itemForeground
                            : colors.disabledForeground,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
