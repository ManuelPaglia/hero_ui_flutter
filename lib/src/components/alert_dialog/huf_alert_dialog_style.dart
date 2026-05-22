import 'package:flutter/material.dart';

import '../../theme/huf_theme.dart';
import '../alert/huf_alert_color.dart';

/// Metriche di [HUFAlertDialog].
class HUFAlertDialogMetrics {
  const HUFAlertDialogMetrics({
    required this.padding,
    required this.headerGap,
    required this.contentGap,
    required this.actionsGap,
    required this.borderRadius,
    required this.maxWidth,
    required this.viewportMargin,
    required this.statusIconOuterSize,
    required this.statusIconInnerSize,
    required this.statusIconGlyphSize,
    required this.titleFontSize,
    required this.descriptionFontSize,
    required this.dismissButtonSize,
  });

  final EdgeInsets padding;
  final double headerGap;
  final double contentGap;
  final double actionsGap;
  final double borderRadius;
  final double maxWidth;
  final EdgeInsets viewportMargin;
  final double statusIconOuterSize;
  final double statusIconInnerSize;
  final double statusIconGlyphSize;
  final double titleFontSize;
  final double descriptionFontSize;
  final double dismissButtonSize;
}

/// Colori della superficie di [HUFAlertDialog].
class HUFAlertDialogSurfaceColors {
  const HUFAlertDialogSurfaceColors({
    required this.background,
    required this.titleColor,
    required this.descriptionColor,
    required this.borderColor,
  });

  final Color background;
  final Color titleColor;
  final Color descriptionColor;
  final Color borderColor;
}

/// Colori di accento per icona di stato in [HUFAlertDialog].
class HUFAlertDialogAccentColors {
  const HUFAlertDialogAccentColors({
    required this.accent,
    required this.iconBackground,
  });

  final Color accent;
  final Color iconBackground;
}

HUFAlertDialogMetrics hufAlertDialogMetricsFor(HUFBorderRadius borderRadius) {
  final radius = (borderRadius.value * 2).clamp(20.0, 32.0);

  return HUFAlertDialogMetrics(
    padding: const EdgeInsets.fromLTRB(24, 24, 20, 24),
    headerGap: 16,
    contentGap: 8,
    actionsGap: 12,
    borderRadius: radius,
    maxWidth: 440,
    viewportMargin: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
    statusIconOuterSize: 48,
    statusIconInnerSize: 40,
    statusIconGlyphSize: 22,
    titleFontSize: 18,
    descriptionFontSize: 14,
    dismissButtonSize: 36,
  );
}

HUFAlertDialogSurfaceColors hufAlertDialogSurfaceColorsFor(
  HUFThemeColors palette,
) {
  return HUFAlertDialogSurfaceColors(
    background: palette.card,
    titleColor: palette.cardForeground,
    descriptionColor: palette.cardMutedForeground,
    borderColor: palette.border,
  );
}

HUFAlertDialogAccentColors hufAlertDialogAccentColorsFor(
  HUFThemeColors palette,
  HUFAlertColor color,
) {
  final (Color accent, Color iconBackground) = switch (color) {
    HUFAlertColor.defaultColor => (
        palette.cardForeground,
        palette.cardTertiary,
      ),
    HUFAlertColor.accent => (
        palette.primary,
        _softBackground(palette.primary, palette.background),
      ),
    HUFAlertColor.success => (
        palette.success,
        _softBackground(palette.success, palette.background),
      ),
    HUFAlertColor.warning => (
        palette.warning,
        _softBackground(palette.warning, palette.background),
      ),
    HUFAlertColor.danger => (
        palette.danger,
        palette.dangerSoft,
      ),
  };

  return HUFAlertDialogAccentColors(
    accent: accent,
    iconBackground: iconBackground,
  );
}

Color _softBackground(Color accent, Color pageBackground) {
  return Color.alphaBlend(accent.withValues(alpha: 0.15), pageBackground);
}
