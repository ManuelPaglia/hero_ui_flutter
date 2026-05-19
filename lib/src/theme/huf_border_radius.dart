import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// Token border radius condiviso da tutti i componenti Hero UI Flutter.
///
/// Ogni preset espone un unico [value] applicato ovunque (card, bottoni, input, …).
/// [full] resta disponibile per elementi circolari (es. chip pill).
@immutable
class HUFBorderRadius {
  const HUFBorderRadius({
    required this.value,
    this.full = 999,
  });

  /// Radius condiviso da tutti i componenti.
  final double value;

  /// Radius pill / circolare (es. chip, badge).
  final double full;

  /// Alias per compatibilità con la scala sm / md / lg dei componenti.
  double get sm => value;

  /// Alias per compatibilità con la scala sm / md / lg dei componenti.
  double get md => value;

  /// Alias per compatibilità con la scala sm / md / lg dei componenti.
  double get lg => value;

  static const HUFBorderRadius none = HUFBorderRadius(value: 0, full: 0);

  static const HUFBorderRadius extraSmall = HUFBorderRadius(value: 2);

  static const HUFBorderRadius small = HUFBorderRadius(value: 4);

  /// Valore predefinito del design system (HeroUI `--field-radius`, 0.75rem).
  static const HUFBorderRadius medium = HUFBorderRadius(value: 12);

  static const HUFBorderRadius large = HUFBorderRadius(value: 16);

  BorderRadius circular() => BorderRadius.circular(value);

  BorderRadius circularFull() => BorderRadius.circular(full);

  HUFBorderRadius copyWith({
    double? value,
    double? full,
  }) {
    return HUFBorderRadius(
      value: value ?? this.value,
      full: full ?? this.full,
    );
  }

  HUFBorderRadius lerp(HUFBorderRadius other, double t) {
    return HUFBorderRadius(
      value: lerpDouble(value, other.value, t)!,
      full: lerpDouble(full, other.full, t)!,
    );
  }
}
