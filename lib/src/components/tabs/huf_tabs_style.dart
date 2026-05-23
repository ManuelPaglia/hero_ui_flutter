import 'package:flutter/material.dart';

import '../../theme/huf_theme.dart';
import 'huf_tab_variant.dart';

/// Metriche condivise per [HUFTabs].
class HUFTabsMetrics {
  const HUFTabsMetrics({
    required this.containerPadding,
    required this.tabHorizontalPadding,
    required this.tabVerticalPadding,
    required this.fontSize,
    required this.pillRadius,
    required this.trackThickness,
    required this.indicatorThickness,
    required this.trackGap,
  });

  final double containerPadding;
  final double tabHorizontalPadding;
  final double tabVerticalPadding;
  final double fontSize;
  final double pillRadius;
  final double trackThickness;
  final double indicatorThickness;
  final double trackGap;
}

/// Colori risolti per [HUFTabs].
class HUFTabsColors {
  const HUFTabsColors({
    required this.containerColor,
    required this.containerBorder,
    required this.indicatorColor,
    required this.activeTextColor,
    required this.inactiveTextColor,
    required this.disabledTextColor,
    required this.trackColor,
  });

  final Color containerColor;
  final BorderSide? containerBorder;
  final Color indicatorColor;
  final Color activeTextColor;
  final Color inactiveTextColor;
  final Color disabledTextColor;
  final Color trackColor;
}

const HUFTabsMetrics kHufTabsMetrics = HUFTabsMetrics(
  containerPadding: 4,
  tabHorizontalPadding: 16,
  tabVerticalPadding: 10,
  fontSize: 14,
  pillRadius: 9999,
  trackThickness: 1,
  indicatorThickness: 3,
  trackGap: 8,
);

/// Altezza stimata di una voce tab (testo + padding verticale).
double hufTabsTabHeight(HUFTabsMetrics metrics, [double? measuredHeight]) {
  if (measuredHeight != null && measuredHeight > 0) return measuredHeight;
  return metrics.tabVerticalPadding * 2 + metrics.fontSize * 1.2;
}

/// Radius della chip attiva (pill = metà altezza voce).
double hufTabsChipRadius(HUFTabsMetrics metrics, [double? measuredTabHeight]) {
  return hufTabsTabHeight(metrics, measuredTabHeight) / 2;
}

/// Radius degli angoli del container primary orizzontale.
double hufTabsHorizontalContainerRadius(
  HUFTabsMetrics metrics, [
  double? measuredTabHeight,
]) {
  return hufTabsChipRadius(metrics, measuredTabHeight) + metrics.containerPadding;
}

/// Angoli del container primary verticale (solo sopra/sotto, come la chip).
BorderRadius hufTabsVerticalContainerBorderRadius(
  HUFTabsMetrics metrics, [
  double? measuredTabHeight,
]) {
  final chipRadius = hufTabsChipRadius(metrics, measuredTabHeight);
  return BorderRadius.vertical(
    top: Radius.circular(chipRadius),
    bottom: Radius.circular(chipRadius),
  );
}

Color hufTabsPrimaryIndicatorColor(HUFThemeColors palette) {
  return Color.lerp(
    palette.cardSecondary,
    palette.cardForeground,
    palette.cardForeground.computeLuminance() > 0.5 ? 0.18 : 0.22,
  )!;
}

Color hufTabsDisabledTextColor(HUFThemeColors palette) {
  return Color.lerp(
    palette.cardMutedForeground,
    palette.cardSecondary,
    palette.cardForeground.computeLuminance() > 0.5 ? 0.45 : 0.55,
  )!;
}

HUFTabsColors hufTabsColorsFor(
  HUFThemeColors palette,
  HUFTabVariant variant, {
  Color? containerColor,
  Color? containerBorderColor,
  Color? indicatorColor,
  Color? activeTextColor,
  Color? inactiveTextColor,
  Color? disabledTextColor,
  Color? trackColor,
}) {
  final resolvedIndicator = indicatorColor ?? palette.primary;
  final resolvedActiveText = activeTextColor ?? palette.cardForeground;
  final resolvedInactiveText =
      inactiveTextColor ?? palette.cardMutedForeground;
  final resolvedDisabledText =
      disabledTextColor ?? hufTabsDisabledTextColor(palette);
  final resolvedTrack = trackColor ?? palette.border;

  return switch (variant) {
    HUFTabVariant.primary => HUFTabsColors(
        containerColor: containerColor ?? palette.cardSecondary,
        containerBorder: BorderSide(
          color: containerBorderColor ?? palette.border,
          width: 1,
        ),
        indicatorColor:
            indicatorColor ?? hufTabsPrimaryIndicatorColor(palette),
        activeTextColor: resolvedActiveText,
        inactiveTextColor: resolvedInactiveText,
        disabledTextColor: resolvedDisabledText,
        trackColor: resolvedTrack,
      ),
    HUFTabVariant.secondary => HUFTabsColors(
        containerColor: containerColor ?? palette.transparent,
        containerBorder: containerBorderColor != null
            ? BorderSide(color: containerBorderColor, width: 1)
            : null,
        indicatorColor: resolvedIndicator,
        activeTextColor: resolvedActiveText,
        inactiveTextColor: resolvedInactiveText,
        disabledTextColor: resolvedDisabledText,
        trackColor: resolvedTrack,
      ),
  };
}
