import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/huf_theme.dart';
import 'huf_progress_size.dart';

/// Metriche conmotionate per [HUFProgress].
class HUFProgressMetrics {
  const HUFProgressMetrics({
    required this.trackHeight,
    required this.borderRadius,
    required this.headerGap,
    required this.labelFontSize,
    required this.valueFontSize,
  });

  final double trackHeight;

  /// Token radius del tema per la size corrente (sm / md / lg).
  final double borderRadius;

  final double headerGap;
  final double labelFontSize;
  final double valueFontSize;
}

/// Colori risolti per progress del design system.
class HUFProgressColors {
  const HUFProgressColors({
    required this.fillColor,
    required this.trackColor,
    required this.labelColor,
    required this.valueColor,
  });

  final Color fillColor;
  final Color trackColor;
  final Color labelColor;
  final Color valueColor;
}

HUFProgressMetrics hufProgressMetricsFor(
  HUFProgressSize size,
  HUFBorderRadius borderRadius,
) {
  final themeRadius = switch (size) {
    HUFProgressSize.small => borderRadius.sm,
    HUFProgressSize.medium => borderRadius.md,
    HUFProgressSize.large => borderRadius.lg,
  };

  return switch (size) {
    HUFProgressSize.small => HUFProgressMetrics(
        trackHeight: 6,
        borderRadius: themeRadius,
        headerGap: 8,
        labelFontSize: 13,
        valueFontSize: 13,
      ),
    HUFProgressSize.medium => HUFProgressMetrics(
        trackHeight: 10,
        borderRadius: themeRadius,
        headerGap: 10,
        labelFontSize: 15,
        valueFontSize: 15,
      ),
    HUFProgressSize.large => HUFProgressMetrics(
        trackHeight: 16,
        borderRadius: themeRadius,
        headerGap: 12,
        labelFontSize: 16,
        valueFontSize: 16,
      ),
  };
}

/// Radius del track e del fill, derivato dal token del tema.
double hufProgressTrackRadius(HUFProgressMetrics metrics) {
  return math.min(metrics.borderRadius, metrics.trackHeight / 2);
}

HUFProgressColors hufProgressColorsFor(
  HUFThemeColors palette, {
  Color? fillColor,
  Color? trackColor,
}) {
  return HUFProgressColors(
    fillColor: fillColor ?? palette.warning,
    trackColor: trackColor ?? palette.secondary,
    labelColor: palette.secondaryForeground,
    valueColor: palette.secondaryForeground,
  );
}

/// Formatta il valore mostrato sopra la barra.
String hufProgressFormatValue({
  required double value,
  required double maxValue,
  String valueSuffix = '%',
}) {
  if (maxValue <= 0) {
    return valueSuffix == '%' ? '0%' : '0$valueSuffix';
  }

  if (valueSuffix == '%') {
    final percent = (value / maxValue * 100).round();
    return '$percent%';
  }

  final normalized = value == value.roundToDouble()
      ? value.round().toString()
      : value.toStringAsFixed(1);
  return '$normalized$valueSuffix';
}

/// Larghezza del segmento indeterminato rispetto al track.
const double hufProgressIndeterminateSegmentRatio = 0.35;
