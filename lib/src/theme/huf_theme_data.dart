import 'package:flutter/foundation.dart';

import 'huf_border_radius.dart';
import 'huf_glow.dart';
import 'huf_theme_colors.dart';
import 'huf_theme_palette.dart';
import 'huf_theme_preset.dart';
import 'presets/huf_theme_presets.dart';

/// Configurazione completa del tema Hero UI Flutter.
///
/// Usa un preset built-in con [theme] oppure override manuali:
///
/// ```dart
/// MaterialApp(
///   theme: HUFTheme.light(
///     data: const HUFThemeData(theme: HUFThemePreset.sky),
///   ).toThemeData(),
///   darkTheme: HUFTheme.dark(
///     data: const HUFThemeData(theme: HUFThemePreset.sky),
///   ).toThemeData(),
/// );
/// ```
///
/// Override puntuali (es. solo il radius):
///
/// ```dart
/// const HUFThemeData(
///   theme: HUFThemePreset.coinbase,
///   borderRadius: HUFBorderRadius.large,
/// );
/// ```
@immutable
class HUFThemeData {
  const HUFThemeData({
    this.theme,
    this.light,
    this.dark,
    this.borderRadius,
    this.glowSize,
  });

  /// Preset HeroUI integrato nel package ([HUFThemePreset.sky], [HUFThemePreset.spotify], …).
  final HUFThemePreset? theme;

  /// Palette dedicata alla modalità chiara (sovrascrive il preset).
  final HUFThemePalette? light;

  /// Palette dedicata alla modalità scura (sovrascrive il preset).
  final HUFThemePalette? dark;

  /// Border radius conmotionato per entrambe le modalità (se non sovrascritto per palette).
  final HUFBorderRadius? borderRadius;

  /// Intensità glow per entrambe le modalità (se non sovrascritto per palette).
  final HUFGlowSize? glowSize;

  /// Valori predefiniti del design system (equivale a [HUFThemePreset.defaultTheme]).
  static const HUFThemeData defaults =
      HUFThemeData(theme: HUFThemePreset.defaultTheme);

  /// Shortcut per un preset senza altri override.
  const HUFThemeData.preset(HUFThemePreset preset) : this(theme: preset);

  /// Stessi override per light e dark.
  factory HUFThemeData.shared({
    HUFThemePreset? theme,
    HUFThemeColors? colors,
    HUFBorderRadius? borderRadius,
    HUFGlowSize? glowSize,
  }) {
    final palette = (colors != null || glowSize != null)
        ? HUFThemePalette(colors: colors, glowSize: glowSize)
        : null;
    return HUFThemeData(
      theme: theme,
      light: palette,
      dark: palette,
      borderRadius: borderRadius,
      glowSize: glowSize,
    );
  }

  HUFThemePresetBundle get _bundle =>
      theme != null ? HUFThemePresets.forPreset(theme!) : HUFThemePresets.defaultTheme;

  HUFThemePalette? _palette(Brightness brightness) {
    final explicit =
        brightness == Brightness.dark ? dark : light;
    if (explicit != null) return explicit;
    return brightness == Brightness.dark ? _bundle.dark : _bundle.light;
  }

  HUFThemeColors resolveColors(Brightness brightness) {
    final palette = _palette(brightness);
    final base =
        brightness == Brightness.dark ? HUFThemeColors.dark : HUFThemeColors.light;
    return palette?.colors ?? base;
  }

  HUFBorderRadius resolveBorderRadius(Brightness brightness) {
    final palette = _palette(brightness);
    return palette?.borderRadius ??
        borderRadius ??
        _bundle.borderRadius ??
        HUFBorderRadius.medium;
  }

  HUFGlowSize resolveGlowSize(Brightness brightness) {
    final palette = _palette(brightness);
    return palette?.glowSize ?? glowSize ?? _bundle.glowSize ?? HUFGlowSize.medium;
  }
}

/// Risolve un preset in [HUFThemeData] pronto per [HUFTheme].
extension HUFThemePresetData on HUFThemePreset {
  HUFThemeData get data => HUFThemeData(theme: this);

  HUFThemePresetBundle get bundle => HUFThemePresets.forPreset(this);
}
