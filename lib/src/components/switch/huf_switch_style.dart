import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/huf_theme.dart';
import 'huf_switch_size.dart';

/// Rapporto larghezza/altezza del thumb (pillola orizzontale).
const double hufSwitchThumbWidthRatio = 1.7;

/// Metriche conmotionate per [HUFSwitch].
class HUFSwitchMetrics {
  const HUFSwitchMetrics({
    required this.trackWidth,
    required this.trackHeight,
    required this.thumbWidth,
    required this.thumbHeight,
    required this.thumbInset,
    required this.iconSize,
    required this.borderRadius,
    required this.labelGap,
  });

  final double trackWidth;
  final double trackHeight;
  final double thumbWidth;
  final double thumbHeight;
  final double thumbInset;
  final double iconSize;
  final double borderRadius;
  final double labelGap;
}

/// Colori risolti per [HUFSwitch].
class HUFSwitchColors {
  const HUFSwitchColors({
    required this.trackColor,
    required this.thumbColor,
    required this.iconColor,
    this.boxShadow,
  });

  final Color trackColor;
  final Color thumbColor;
  final Color iconColor;
  final List<BoxShadow>? boxShadow;
}

HUFSwitchMetrics hufSwitchMetricsFor(
  HUFSwitchSize size,
  HUFBorderRadius borderRadius,
) {
  final themeRadius = switch (size) {
    HUFSwitchSize.small => borderRadius.sm,
    HUFSwitchSize.medium => borderRadius.md,
    HUFSwitchSize.large => borderRadius.lg,
  };

  return switch (size) {
    HUFSwitchSize.small => _hufSwitchMetrics(
        trackHeight: 24,
        iconSize: 12,
        labelGap: 8,
        borderRadius: themeRadius,
      ),
    HUFSwitchSize.medium => _hufSwitchMetrics(
        trackHeight: 28,
        iconSize: 14,
        labelGap: 10,
        borderRadius: themeRadius,
      ),
    HUFSwitchSize.large => _hufSwitchMetrics(
        trackHeight: 32,
        iconSize: 16,
        labelGap: 12,
        borderRadius: themeRadius,
      ),
  };
}

HUFSwitchMetrics _hufSwitchMetrics({
  required double trackHeight,
  required double iconSize,
  required double labelGap,
  required double borderRadius,
}) {
  const thumbInset = 2.0;
  const thumbTravel = 18.0;
  final thumbHeight = trackHeight - 2 * thumbInset;
  final thumbWidth = thumbHeight * hufSwitchThumbWidthRatio;

  return HUFSwitchMetrics(
    trackWidth: thumbWidth + 2 * thumbInset + thumbTravel,
    trackHeight: trackHeight,
    thumbWidth: thumbWidth,
    thumbHeight: thumbHeight,
    thumbInset: thumbInset,
    iconSize: iconSize,
    borderRadius: borderRadius,
    labelGap: labelGap,
  );
}

double hufSwitchTrackRadius(HUFSwitchMetrics metrics) {
  return math.min(metrics.borderRadius, metrics.trackHeight / 2);
}

/// Radius del thumb pillola, derivato dal token del tema (come il track).
double hufSwitchThumbRadius(HUFSwitchMetrics metrics) {
  return math.min(metrics.borderRadius, metrics.thumbHeight / 2);
}

HUFSwitchColors hufSwitchColorsFor(
  HUFThemeColors palette,
  bool value,
  bool isDisabled, {
  required HUFGlowSize glowSize,
  Color? activeColor,
  Color? thumbColor,
  Color? inactiveTrackColor,
  Color? iconColor,
}) {
  final active = activeColor ?? palette.primary;
  final thumb = thumbColor ?? const Color(0xFFFFFFFF);
  final inactiveTrack = inactiveTrackColor ?? palette.secondary;

  if (isDisabled) {
    return HUFSwitchColors(
      trackColor: value ? palette.disabled : inactiveTrack.withValues(alpha: 0.6),
      thumbColor: thumb,
      iconColor: palette.disabledForeground,
    );
  }

  if (value) {
    return HUFSwitchColors(
      trackColor: active,
      thumbColor: thumb,
      iconColor: iconColor ?? active,
      boxShadow: hufGlowShadowFor(glowSize, active),
    );
  }

  return HUFSwitchColors(
    trackColor: inactiveTrack,
    thumbColor: thumb,
    iconColor: iconColor ?? palette.secondaryForeground.withValues(alpha: 0.55),
  );
}
