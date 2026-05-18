import 'package:flutter/material.dart';

/// Token colore semantici del design system Hero UI Flutter.
@immutable
class HUFThemeColors {
  const HUFThemeColors({
    required this.primary,
    required this.primaryForeground,
    required this.secondary,
    required this.secondaryForeground,
    required this.danger,
    required this.dangerForeground,
    required this.dangerSoft,
    required this.dangerSoftForeground,
    required this.disabled,
    required this.disabledForeground,
    required this.transparent,
  });

  final Color primary;
  final Color primaryForeground;
  final Color secondary;
  final Color secondaryForeground;
  final Color danger;
  final Color dangerForeground;
  final Color dangerSoft;
  final Color dangerSoftForeground;
  final Color disabled;
  final Color disabledForeground;
  final Color transparent;

  static const HUFThemeColors light = HUFThemeColors(
    primary: Color(0xFF2563EB),
    primaryForeground: Color(0xFFFFFFFF),
    secondary: Color(0xFFE2E8F0),
    secondaryForeground: Color(0xFF0F172A),
    danger: Color(0xFFDC2626),
    dangerForeground: Color(0xFFFFFFFF),
    dangerSoft: Color(0xFFFEE2E2),
    dangerSoftForeground: Color(0xFFB91C1C),
    disabled: Color(0xFF94A3B8),
    disabledForeground: Color(0xFFFFFFFF),
    transparent: Colors.transparent,
  );

  static const HUFThemeColors dark = HUFThemeColors(
    primary: Color(0xFF3B82F6),
    primaryForeground: Color(0xFF0F172A),
    secondary: Color(0xFF334155),
    secondaryForeground: Color(0xFFF8FAFC),
    danger: Color(0xFFEF4444),
    dangerForeground: Color(0xFF0F172A),
    dangerSoft: Color(0xFF450A0A),
    dangerSoftForeground: Color(0xFFFECACA),
    disabled: Color(0xFF64748B),
    disabledForeground: Color(0xFFCBD5E1),
    transparent: Colors.transparent,
  );

  HUFThemeColors copyWith({
    Color? primary,
    Color? primaryForeground,
    Color? secondary,
    Color? secondaryForeground,
    Color? danger,
    Color? dangerForeground,
    Color? dangerSoft,
    Color? dangerSoftForeground,
    Color? disabled,
    Color? disabledForeground,
    Color? transparent,
  }) {
    return HUFThemeColors(
      primary: primary ?? this.primary,
      primaryForeground: primaryForeground ?? this.primaryForeground,
      secondary: secondary ?? this.secondary,
      secondaryForeground: secondaryForeground ?? this.secondaryForeground,
      danger: danger ?? this.danger,
      dangerForeground: dangerForeground ?? this.dangerForeground,
      dangerSoft: dangerSoft ?? this.dangerSoft,
      dangerSoftForeground: dangerSoftForeground ?? this.dangerSoftForeground,
      disabled: disabled ?? this.disabled,
      disabledForeground: disabledForeground ?? this.disabledForeground,
      transparent: transparent ?? this.transparent,
    );
  }

  HUFThemeColors lerp(HUFThemeColors other, double t) {
    return HUFThemeColors(
      primary: Color.lerp(primary, other.primary, t)!,
      primaryForeground: Color.lerp(primaryForeground, other.primaryForeground, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      secondaryForeground: Color.lerp(secondaryForeground, other.secondaryForeground, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      dangerForeground: Color.lerp(dangerForeground, other.dangerForeground, t)!,
      dangerSoft: Color.lerp(dangerSoft, other.dangerSoft, t)!,
      dangerSoftForeground: Color.lerp(dangerSoftForeground, other.dangerSoftForeground, t)!,
      disabled: Color.lerp(disabled, other.disabled, t)!,
      disabledForeground: Color.lerp(disabledForeground, other.disabledForeground, t)!,
      transparent: Color.lerp(transparent, other.transparent, t)!,
    );
  }
}
