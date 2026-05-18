import 'package:flutter/material.dart';

import '../../theme/huf_theme.dart';
import '../switch/huf_switch_style.dart';
import 'huf_slider_size.dart';

/// Metriche conmotionate per [HUFSlider] e [HUFRangeSlider].
class HUFSliderMetrics {
  const HUFSliderMetrics({
    required this.trackHeight,
    required this.thumbWidth,
    required this.headerGap,
    required this.labelFontSize,
    required this.valueFontSize,
    required this.thumbBorderWidth,
    required this.touchHeight,
  });

  /// Altezza visiva della barra a pillola.
  final double trackHeight;

  /// Larghezza della pillola orizzontale, contenuta nel track.
  final double thumbWidth;

  final double headerGap;
  final double labelFontSize;
  final double valueFontSize;
  final double thumbBorderWidth;

  /// Area di tocco verticale (≥ track).
  final double touchHeight;
}

/// Colori risolti per slider del design system.
class HUFSliderColors {
  const HUFSliderColors({
    required this.activeColor,
    required this.inactiveTrackColor,
    required this.thumbColor,
    required this.labelColor,
    required this.valueColor,
    required this.thumbBorderColor,
  });

  final Color activeColor;
  final Color inactiveTrackColor;
  final Color thumbColor;
  final Color labelColor;
  final Color valueColor;
  final Color thumbBorderColor;
}

HUFSliderMetrics hufSliderMetricsFor(
  HUFSliderSize size,
  HUFBorderRadius _,
) {
  return switch (size) {
    HUFSliderSize.small => _hufSliderMetrics(
        trackHeight: 16,
        headerGap: 8,
        labelFontSize: 13,
        valueFontSize: 13,
        thumbBorderWidth: 1.5,
        touchHeight: 40,
      ),
    HUFSliderSize.medium => _hufSliderMetrics(
        trackHeight: 20,
        headerGap: 10,
        labelFontSize: 15,
        valueFontSize: 15,
        thumbBorderWidth: 1.5,
        touchHeight: 44,
      ),
    HUFSliderSize.large => _hufSliderMetrics(
        trackHeight: 24,
        headerGap: 12,
        labelFontSize: 16,
        valueFontSize: 16,
        thumbBorderWidth: 2,
        touchHeight: 48,
      ),
  };
}

HUFSliderMetrics _hufSliderMetrics({
  required double trackHeight,
  required double headerGap,
  required double labelFontSize,
  required double valueFontSize,
  required double thumbBorderWidth,
  required double touchHeight,
}) {
  final thumbWidth = trackHeight * hufSwitchThumbWidthRatio;

  return HUFSliderMetrics(
    trackHeight: trackHeight,
    thumbWidth: thumbWidth,
    headerGap: headerGap,
    labelFontSize: labelFontSize,
    valueFontSize: valueFontSize,
    thumbBorderWidth: thumbBorderWidth,
    touchHeight: touchHeight,
  );
}

/// Track sempre a capsula (estremità completamente arrotondate).
double hufSliderTrackRadius(HUFSliderMetrics metrics) {
  return metrics.trackHeight / 2;
}

/// Pillola orizzontale: raggio = metà altezza track.
double hufSliderThumbRadius(HUFSliderMetrics metrics) {
  return metrics.trackHeight / 2;
}

HUFSliderColors hufSliderColorsFor(
  HUFThemeColors palette,
  bool isDisabled, {
  Color? activeColor,
  Color? inactiveTrackColor,
  Color? thumbColor,
}) {
  final active = activeColor ?? palette.primary;
  final inactive = inactiveTrackColor ?? palette.secondary;
  final thumb = thumbColor ?? const Color(0xFFFFFFFF);

  if (isDisabled) {
    return HUFSliderColors(
      activeColor: palette.disabled,
      inactiveTrackColor: inactive.withValues(alpha: 0.5),
      thumbColor: thumb.withValues(alpha: 0.7),
      labelColor: palette.disabled,
      valueColor: palette.disabled,
      thumbBorderColor: palette.disabled,
    );
  }

  return HUFSliderColors(
    activeColor: active,
    inactiveTrackColor: inactive,
    thumbColor: thumb,
    labelColor: palette.secondaryForeground,
    valueColor: palette.secondaryForeground,
    thumbBorderColor: active,
  );
}

/// Arrotonda [value] allo [step] più vicino nell'intervallo [min]–[max].
double hufSliderSnapToStep(
  double value, {
  required double min,
  required double max,
  double? step,
}) {
  if (step == null || step <= 0) {
    return value.clamp(min, max);
  }
  final steps = ((value - min) / step).round();
  return (min + steps * step).clamp(min, max);
}
