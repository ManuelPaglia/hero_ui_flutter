import 'package:flutter/material.dart';

import '../../theme/huf_theme.dart';
import 'huf_alert_color.dart';
import 'huf_alert_size.dart';

/// Metriche di [HUFAlert].
class HUFAlertMetrics {
  const HUFAlertMetrics({
    required this.padding,
    required this.gap,
    required this.contentGap,
    required this.borderRadius,
    required this.iconSize,
    required this.titleFontSize,
    required this.descriptionFontSize,
    required this.actionHeight,
    required this.actionHorizontalPadding,
    required this.actionFontSize,
    required this.actionBorderRadius,
    required this.dismissButtonSize,
    required this.maxWidth,
  });

  final EdgeInsets padding;
  final double gap;
  final double contentGap;
  final double borderRadius;
  final double iconSize;
  final double titleFontSize;
  final double descriptionFontSize;
  final double actionHeight;
  final double actionHorizontalPadding;
  final double actionFontSize;
  final double actionBorderRadius;
  final double dismissButtonSize;
  final double maxWidth;
}

/// Colori della card di [HUFAlert] (dal tema principale).
class HUFAlertSurfaceColors {
  const HUFAlertSurfaceColors({
    required this.background,
    required this.titleColor,
    required this.descriptionColor,
  });

  final Color background;
  final Color titleColor;
  final Color descriptionColor;
}

/// Colori di accento di [HUFAlert] (icona, titolo, azione).
class HUFAlertAccentColors {
  const HUFAlertAccentColors({
    required this.accent,
    required this.onAccent,
  });

  final Color accent;
  final Color onAccent;
}

HUFAlertMetrics hufAlertMetricsFor(
  HUFAlertSize size,
  HUFBorderRadius borderRadius,
) {
  return switch (size) {
    HUFAlertSize.small => HUFAlertMetrics(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        gap: 10,
        contentGap: 2,
        borderRadius: borderRadius.value,
        iconSize: 18,
        titleFontSize: 13,
        descriptionFontSize: 12,
        actionHeight: 32,
        actionHorizontalPadding: 12,
        actionFontSize: 12,
        actionBorderRadius: borderRadius.full,
        dismissButtonSize: 32,
        maxWidth: 360,
      ),
    HUFAlertSize.medium => HUFAlertMetrics(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        gap: 12,
        contentGap: 4,
        borderRadius: borderRadius.value,
        iconSize: 20,
        titleFontSize: 14,
        descriptionFontSize: 13,
        actionHeight: 36,
        actionHorizontalPadding: 14,
        actionFontSize: 13,
        actionBorderRadius: borderRadius.full,
        dismissButtonSize: 36,
        maxWidth: 420,
      ),
    HUFAlertSize.large => HUFAlertMetrics(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        gap: 14,
        contentGap: 4,
        borderRadius: borderRadius.value,
        iconSize: 22,
        titleFontSize: 15,
        descriptionFontSize: 14,
        actionHeight: 40,
        actionHorizontalPadding: 16,
        actionFontSize: 14,
        actionBorderRadius: borderRadius.full,
        dismissButtonSize: 40,
        maxWidth: 480,
      ),
  };
}

HUFAlertSurfaceColors hufAlertSurfaceColorsFor(HUFThemeColors palette) {
  return HUFAlertSurfaceColors(
    background: palette.card,
    titleColor: palette.cardForeground,
    descriptionColor: palette.cardMutedForeground,
  );
}

HUFAlertAccentColors hufAlertAccentColorsFor(
  HUFThemeColors palette,
  HUFAlertColor color,
) {
  return switch (color) {
    HUFAlertColor.defaultColor => HUFAlertAccentColors(
        accent: palette.cardForeground,
        onAccent: palette.card,
      ),
    HUFAlertColor.accent => HUFAlertAccentColors(
        accent: palette.primary,
        onAccent: palette.primaryForeground,
      ),
    HUFAlertColor.success => HUFAlertAccentColors(
        accent: palette.success,
        onAccent: palette.successForeground,
      ),
    HUFAlertColor.warning => HUFAlertAccentColors(
        accent: palette.warning,
        onAccent: palette.warningForeground,
      ),
    HUFAlertColor.danger => HUFAlertAccentColors(
        accent: palette.danger,
        onAccent: palette.dangerForeground,
      ),
  };
}
