import 'package:flutter/material.dart';

/// Intensità del glow per componenti con ombra (es. [HUFCheckbox], [HUFButton]).
enum HUFGlowSize {
  none,
  small,
  medium,
  large,
}

/// Metriche glow: ombra e padding layout associato.
@immutable
class HUFGlowMetrics {
  const HUFGlowMetrics({
    required this.layoutPadding,
    required this.primaryBlur,
    required this.secondaryBlur,
    required this.offsetY,
    required this.spreadRadius,
    required this.primaryAlpha,
    required this.secondaryAlpha,
    required this.iconOnlyGlowReserve,
  });

  final EdgeInsets layoutPadding;
  final double primaryBlur;
  final double secondaryBlur;
  final double offsetY;
  final double spreadRadius;
  final double primaryAlpha;
  final double secondaryAlpha;

  /// Spazio verticale extra per [HUFButton.iconOnly] con glow.
  final double iconOnlyGlowReserve;
}

HUFGlowMetrics hufGlowMetricsFor(HUFGlowSize size) {
  return switch (size) {
    HUFGlowSize.none => const HUFGlowMetrics(
        layoutPadding: EdgeInsets.zero,
        primaryBlur: 0,
        secondaryBlur: 0,
        offsetY: 0,
        spreadRadius: 0,
        primaryAlpha: 0,
        secondaryAlpha: 0,
        iconOnlyGlowReserve: 0,
      ),
    HUFGlowSize.small => const HUFGlowMetrics(
        layoutPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 2),
        primaryBlur: 8,
        secondaryBlur: 14,
        offsetY: 2,
        spreadRadius: 0,
        primaryAlpha: 0.32,
        secondaryAlpha: 0.18,
        iconOnlyGlowReserve: 8,
      ),
    HUFGlowSize.medium => const HUFGlowMetrics(
        layoutPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 2),
        primaryBlur: 12,
        secondaryBlur: 22,
        offsetY: 4,
        spreadRadius: 1,
        primaryAlpha: 0.38,
        secondaryAlpha: 0.22,
        iconOnlyGlowReserve: 12,
      ),
    HUFGlowSize.large => const HUFGlowMetrics(
        layoutPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 3),
        primaryBlur: 16,
        secondaryBlur: 30,
        offsetY: 6,
        spreadRadius: 2,
        primaryAlpha: 0.42,
        secondaryAlpha: 0.26,
        iconOnlyGlowReserve: 16,
      ),
  };
}

EdgeInsets hufGlowLayoutPaddingFor(HUFGlowSize size) {
  return hufGlowMetricsFor(size).layoutPadding;
}

double hufIconOnlyGlowReserveFor(HUFGlowSize size) {
  return hufGlowMetricsFor(size).iconOnlyGlowReserve;
}

List<BoxShadow> hufGlowShadowFor(HUFGlowSize size, Color color) {
  final metrics = hufGlowMetricsFor(size);
  return [
    BoxShadow(
      color: color.withValues(alpha: metrics.primaryAlpha),
      blurRadius: metrics.primaryBlur,
      offset: Offset(0, metrics.offsetY),
    ),
    BoxShadow(
      color: color.withValues(alpha: metrics.secondaryAlpha),
      blurRadius: metrics.secondaryBlur,
      spreadRadius: metrics.spreadRadius,
    ),
  ];
}
