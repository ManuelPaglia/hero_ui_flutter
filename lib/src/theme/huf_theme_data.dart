import 'package:flutter/material.dart';

import 'huf_border_radius.dart';
import 'huf_theme_colors.dart';

/// Override per una singola modalità (light o dark).
@immutable
class HUFThemePalette {
  const HUFThemePalette({
    this.colors,
    this.borderRadius,
  });

  final HUFThemeColors? colors;
  final HUFBorderRadius? borderRadius;
}

/// Configurazione completa del tema Hero UI Flutter.
///
/// Passa un'istanza (anche tramite sottoclasse) a [HUFTheme.light] o [HUFTheme.dark]:
///
/// ```dart
/// class BrandTheme extends HUFThemeData {
///   const BrandTheme() : super(
///     light: HUFThemePalette(
///       colors: HUFThemeColors(
///         primary: Color(0xFF7C3AED),
///         // ... tutti i token richiesti
///       ),
///     ),
///   );
/// }
///
/// void main() {
///   const themeData = BrandTheme();
///   runApp(MyApp(themeData: themeData));
/// }
/// ```
@immutable
class HUFThemeData {
  const HUFThemeData({
    this.light,
    this.dark,
    this.borderRadius,
  });

  /// Palette dedicata alla modalità chiara.
  final HUFThemePalette? light;

  /// Palette dedicata alla modalità scura.
  final HUFThemePalette? dark;

  /// Border radius conmotionato per entrambe le modalità (se non sovrascritto per palette).
  final HUFBorderRadius? borderRadius;

  /// Valori predefiniti del design system (nessun override).
  static const HUFThemeData defaults = HUFThemeData();

  /// Stessi override per light e dark.
  factory HUFThemeData.shared({
    HUFThemeColors? colors,
    HUFBorderRadius? borderRadius,
  }) {
    final palette =
        colors != null ? HUFThemePalette(colors: colors) : null;
    return HUFThemeData(
      light: palette,
      dark: palette,
      borderRadius: borderRadius,
    );
  }

  HUFThemeColors resolveColors(Brightness brightness) {
    final palette = brightness == Brightness.dark ? dark : light;
    final base =
        brightness == Brightness.dark ? HUFThemeColors.dark : HUFThemeColors.light;
    return palette?.colors ?? base;
  }

  HUFBorderRadius resolveBorderRadius(Brightness brightness) {
    final palette = brightness == Brightness.dark ? dark : light;
    return palette?.borderRadius ?? borderRadius ?? HUFBorderRadius.standard;
  }
}
