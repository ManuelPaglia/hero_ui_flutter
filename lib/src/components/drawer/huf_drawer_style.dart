import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/huf_theme.dart';
import 'huf_drawer_open_from.dart';

/// Metriche di [HUFDrawer].
class HUFDrawerMetrics {
  const HUFDrawerMetrics({
    required this.padding,
    required this.contentGap,
    required this.closeHeaderGap,
    required this.borderRadius,
    required this.maxSideWidth,
    required this.sideWidthFactor,
    required this.maxBottomHeight,
    required this.bottomHeightFactor,
    required this.barrierColor,
  });

  final EdgeInsets padding;
  final double contentGap;
  final double closeHeaderGap;
  final double borderRadius;
  final double maxSideWidth;
  final double sideWidthFactor;
  final double maxBottomHeight;
  final double bottomHeightFactor;
  final Color barrierColor;
}

HUFDrawerMetrics hufDrawerMetricsFor(
  HUFTheme theme, {
  Color? barrierColor,
}) {
  final radius = (theme.borderRadius.value * 1.5).clamp(12.0, 24.0);

  return HUFDrawerMetrics(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
    contentGap: 12,
    closeHeaderGap: 8,
    borderRadius: radius,
    maxSideWidth: 400,
    sideWidthFactor: 0.85,
    maxBottomHeight: 480,
    bottomHeightFactor: 0.55,
    barrierColor: barrierColor ??
        Colors.black.withValues(alpha: theme.isDark ? 0.55 : 0.45),
  );
}

/// Larghezza del pannello per drawer laterale.
double hufDrawerSideExtent(
  double viewportWidth, {
  required bool isFullWidth,
  required HUFDrawerMetrics metrics,
  double? width,
}) {
  if (isFullWidth) return viewportWidth;
  if (width != null) return math.min(width, viewportWidth);
  return math.min(
    viewportWidth * metrics.sideWidthFactor,
    metrics.maxSideWidth,
  );
}

/// Altezza del pannello per drawer dal basso.
///
/// Restituisce `null` se l'altezza segue il contenuto (default senza [height]).
double? hufDrawerBottomExtent(
  double viewportHeight, {
  required bool isFullWidth,
  required HUFDrawerMetrics metrics,
  double? height,
}) {
  if (isFullWidth) return viewportHeight;
  if (height != null) return math.min(height, viewportHeight);
  return null;
}

/// Tetto massimo per drawer dal basso a altezza intrinseca.
double hufDrawerBottomMaxHeight(
  double viewportHeight,
  HUFDrawerMetrics metrics,
) {
  return math.min(
    viewportHeight * metrics.bottomHeightFactor,
    metrics.maxBottomHeight,
  );
}

BorderRadius hufDrawerPanelBorderRadius(
  HUFDrawerOpenFrom openFrom,
  double radius, {
  required bool isFullWidth,
}) {
  if (isFullWidth) return BorderRadius.zero;

  return switch (openFrom) {
    HUFDrawerOpenFrom.left => BorderRadius.only(
        topRight: Radius.circular(radius),
        bottomRight: Radius.circular(radius),
      ),
    HUFDrawerOpenFrom.right => BorderRadius.only(
        topLeft: Radius.circular(radius),
        bottomLeft: Radius.circular(radius),
      ),
    HUFDrawerOpenFrom.bottom => BorderRadius.only(
        topLeft: Radius.circular(radius),
        topRight: Radius.circular(radius),
      ),
  };
}

Offset hufDrawerSlideOffset(
  HUFDrawerOpenFrom openFrom,
  double progress,
) {
  final delta = 1 - progress;
  return switch (openFrom) {
    HUFDrawerOpenFrom.left => Offset(-delta, 0),
    HUFDrawerOpenFrom.right => Offset(delta, 0),
    HUFDrawerOpenFrom.bottom => Offset(0, delta),
  };
}
