import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/huf_theme.dart';

/// Larghezza stimata di una riga di testo per lo skeleton.
double hufSkeletonEstimatedTextWidth(
  String text,
  double fontSize, {
  double minWidth = 40,
  double maxWidth = 320,
}) {
  if (text.isEmpty) {
    return minWidth;
  }
  final estimated = text.length * fontSize * 0.52;
  return math.min(maxWidth, math.max(minWidth, estimated));
}

/// Colori base dello skeleton derivati dal tema.
class HUFSkeletonColors {
  const HUFSkeletonColors({
    required this.base,
    required this.highlight,
  });

  final Color base;
  final Color highlight;

  factory HUFSkeletonColors.fromTheme(HUFTheme theme) {
    final colors = theme.colors;
    final base = colors.secondary;
    final highlight = Color.lerp(
      base,
      theme.isDark ? colors.cardForeground : colors.background,
      theme.isDark ? 0.22 : 0.55,
    )!;
    return HUFSkeletonColors(base: base, highlight: highlight);
  }
}
