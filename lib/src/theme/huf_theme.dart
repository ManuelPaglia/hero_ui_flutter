import 'package:flutter/material.dart';

import 'huf_border_radius.dart';
import 'huf_glow.dart';
import 'huf_theme_colors.dart';
import 'huf_theme_data.dart';

export 'huf_border_radius.dart';
export 'huf_glow.dart';
export 'huf_theme_colors.dart';
export 'huf_theme_data.dart';

/// Tema Hero UI Flutter: colori, border radius e supporto light/dark.
///
/// Registra il tema nell'app con [toThemeData] o tramite [HUFThemeData]:
///
/// ```dart
/// const themeData = MyBrandTheme();
/// MaterialApp(
///   theme: HUFTheme.light(data: themeData).toThemeData(),
///   darkTheme: HUFTheme.dark(data: themeData).toThemeData(),
/// );
/// ```
@immutable
class HUFTheme extends ThemeExtension<HUFTheme> {
  const HUFTheme({
    required this.brightness,
    required this.colors,
    required this.borderRadius,
    required this.glowSize,
  });

  final Brightness brightness;
  final HUFThemeColors colors;
  final HUFBorderRadius borderRadius;
  final HUFGlowSize glowSize;

  bool get isDark => brightness == Brightness.dark;

  factory HUFTheme.light({
    HUFThemeData data = HUFThemeData.defaults,
    HUFThemeColors? colors,
    HUFBorderRadius? borderRadius,
    HUFGlowSize? glowSize,
  }) {
    return HUFTheme(
      brightness: Brightness.light,
      colors: colors ?? data.resolveColors(Brightness.light),
      borderRadius: borderRadius ?? data.resolveBorderRadius(Brightness.light),
      glowSize: glowSize ?? data.resolveGlowSize(Brightness.light),
    );
  }

  factory HUFTheme.dark({
    HUFThemeData data = HUFThemeData.defaults,
    HUFThemeColors? colors,
    HUFBorderRadius? borderRadius,
    HUFGlowSize? glowSize,
  }) {
    return HUFTheme(
      brightness: Brightness.dark,
      colors: colors ?? data.resolveColors(Brightness.dark),
      borderRadius: borderRadius ?? data.resolveBorderRadius(Brightness.dark),
      glowSize: glowSize ?? data.resolveGlowSize(Brightness.dark),
    );
  }

  /// Crea il tema per la [brightness] a partire da [HUFThemeData].
  factory HUFTheme.fromData(
    HUFThemeData data, {
    required Brightness brightness,
    HUFThemeColors? colors,
    HUFBorderRadius? borderRadius,
    HUFGlowSize? glowSize,
  }) {
    return HUFTheme(
      brightness: brightness,
      colors: colors ?? data.resolveColors(brightness),
      borderRadius: borderRadius ?? data.resolveBorderRadius(brightness),
      glowSize: glowSize ?? data.resolveGlowSize(brightness),
    );
  }

  /// Tema HUF dal [BuildContext]; fallback su [HUFTheme.light] se non registrato.
  static HUFTheme of(BuildContext context) {
    return Theme.of(context).extension<HUFTheme>() ?? HUFTheme.light();
  }

  /// [ThemeData] Material con estensione HUF già collegata.
  ThemeData toThemeData({ThemeData? base}) {
    final seed = base ?? ThemeData(useMaterial3: true, brightness: brightness);
    return seed.copyWith(
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: colors.primary,
        brightness: brightness,
      ),
      extensions: <ThemeExtension<dynamic>>[this],
    );
  }

  @override
  HUFTheme copyWith({
    Brightness? brightness,
    HUFThemeColors? colors,
    HUFBorderRadius? borderRadius,
    HUFGlowSize? glowSize,
  }) {
    return HUFTheme(
      brightness: brightness ?? this.brightness,
      colors: colors ?? this.colors,
      borderRadius: borderRadius ?? this.borderRadius,
      glowSize: glowSize ?? this.glowSize,
    );
  }

  @override
  HUFTheme lerp(ThemeExtension<HUFTheme>? other, double t) {
    if (other is! HUFTheme) return this;
    return HUFTheme(
      brightness: t < 0.5 ? brightness : other.brightness,
      colors: colors.lerp(other.colors, t),
      borderRadius: borderRadius.lerp(other.borderRadius, t),
      glowSize: t < 0.5 ? glowSize : other.glowSize,
    );
  }
}

/// Accesso rapido a [HUFTheme] dal [BuildContext].
extension HUFThemeContext on BuildContext {
  HUFTheme get hufTheme => HUFTheme.of(this);
}
