import 'package:flutter/material.dart';

import '../../theme/huf_theme.dart';
import '../alert/huf_alert_color.dart';
import '../alert/huf_alert_style.dart';

/// Metriche di [HUFToast].
class HUFToastMetrics {
  const HUFToastMetrics({
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
  final double maxWidth;
}

/// Colori della superficie di [HUFToast].
class HUFToastSurfaceColors {
  const HUFToastSurfaceColors({
    required this.background,
    required this.descriptionColor,
    required this.borderColor,
  });

  final Color background;
  final Color descriptionColor;
  final Color borderColor;
}

HUFToastMetrics hufToastMetricsFor(HUFBorderRadius borderRadius) {
  return HUFToastMetrics(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    gap: 12,
    contentGap: 2,
    borderRadius: borderRadius.full,
    iconSize: 20,
    titleFontSize: 14,
    descriptionFontSize: 13,
    actionHeight: 32,
    actionHorizontalPadding: 14,
    actionFontSize: 13,
    maxWidth: 480,
  );
}

HUFToastSurfaceColors hufToastSurfaceColorsFor(HUFThemeColors palette) {
  return HUFToastSurfaceColors(
    background: palette.card,
    descriptionColor: palette.cardMutedForeground,
    borderColor: palette.border,
  );
}

/// Colori di accento per icona, titolo e azione in [HUFToast].
HUFAlertAccentColors hufToastAccentColorsFor(
  HUFThemeColors palette,
  HUFAlertColor color,
) {
  return hufAlertAccentColorsFor(palette, color);
}
