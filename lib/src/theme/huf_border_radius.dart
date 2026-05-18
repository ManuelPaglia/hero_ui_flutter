import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// Token border radius conmotionati per tutti i componenti Hero UI Flutter.
@immutable
class HUFBorderRadius {
  const HUFBorderRadius({
    required this.sm,
    required this.md,
    required this.lg,
    required this.full,
  });

  final double sm;
  final double md;
  final double lg;

  /// Radius pill / circolare (es. chip, badge).
  final double full;

  static const HUFBorderRadius standard = HUFBorderRadius(
    sm: 8,
    md: 10,
    lg: 12,
    full: 999,
  );

  static const HUFBorderRadius sharp = HUFBorderRadius(
    sm: 4,
    md: 6,
    lg: 8,
    full: 999,
  );

  static const HUFBorderRadius rounded = HUFBorderRadius(
    sm: 12,
    md: 16,
    lg: 20,
    full: 999,
  );

  static const HUFBorderRadius pill = HUFBorderRadius(
    sm: 999,
    md: 999,
    lg: 999,
    full: 999,
  );

  BorderRadius circularSm() => BorderRadius.circular(sm);
  BorderRadius circularMd() => BorderRadius.circular(md);
  BorderRadius circularLg() => BorderRadius.circular(lg);
  BorderRadius circularFull() => BorderRadius.circular(full);

  HUFBorderRadius copyWith({
    double? sm,
    double? md,
    double? lg,
    double? full,
  }) {
    return HUFBorderRadius(
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      full: full ?? this.full,
    );
  }

  HUFBorderRadius lerp(HUFBorderRadius other, double t) {
    return HUFBorderRadius(
      sm: lerpDouble(sm, other.sm, t)!,
      md: lerpDouble(md, other.md, t)!,
      lg: lerpDouble(lg, other.lg, t)!,
      full: lerpDouble(full, other.full, t)!,
    );
  }
}
