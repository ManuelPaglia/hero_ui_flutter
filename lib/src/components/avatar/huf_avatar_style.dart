import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/huf_theme.dart';
import 'huf_avatar_badge_color.dart';
import 'huf_avatar_badge_placement.dart';
import 'huf_avatar_color.dart';
import 'huf_avatar_size.dart';
import 'huf_avatar_variant.dart';

/// Metriche di [HUFAvatar].
class HUFAvatarMetrics {
  const HUFAvatarMetrics({
    required this.diameter,
    required this.borderRadius,
    required this.fontSize,
    required this.iconSize,
    required this.defaultOverlap,
    required this.defaultRingWidth,
  });

  final double diameter;
  final double borderRadius;
  final double fontSize;
  final double iconSize;

  /// Overlap predefinito tra avatar in [HUFAvatarGroup] (~25% del diametro).
  final double defaultOverlap;

  /// Spessore predefinito del ring in [HUFAvatarGroup].
  final double defaultRingWidth;
}

/// Metriche del badge di [HUFAvatar].
class HUFAvatarBadgeMetrics {
  const HUFAvatarBadgeMetrics({
    required this.size,
    required this.fontSize,
    required this.iconSize,
    required this.horizontalPadding,
    required this.borderWidth,
    required this.outwardOffset,
  });

  /// Lato del badge compatto (dot, icona, numero).
  final double size;

  final double fontSize;
  final double iconSize;
  final double horizontalPadding;
  final double borderWidth;

  /// Quanto il badge sporge oltre il bordo dell'avatar (~ metà lato).
  final double outwardOffset;
}

/// Colori del badge di [HUFAvatar].
class HUFAvatarBadgeColors {
  const HUFAvatarBadgeColors({
    required this.background,
    required this.foreground,
  });

  final Color background;
  final Color foreground;
}

/// Colori del fallback di [HUFAvatar] (iniziali o icona).
class HUFAvatarFallbackColors {
  const HUFAvatarFallbackColors({
    required this.background,
    required this.foreground,
  });

  final Color background;
  final Color foreground;
}

HUFAvatarMetrics hufAvatarMetricsFor(
  HUFAvatarSize size,
  HUFBorderRadius borderRadius,
) {
  final diameter = switch (size) {
    HUFAvatarSize.small => 32.0,
    HUFAvatarSize.medium => 40.0,
    HUFAvatarSize.large => 48.0,
  };
  final radius = math.min(borderRadius.value, diameter / 2);

  return switch (size) {
    HUFAvatarSize.small => HUFAvatarMetrics(
        diameter: diameter,
        borderRadius: radius,
        fontSize: 12,
        iconSize: 16,
        defaultOverlap: 8,
        defaultRingWidth: 2,
      ),
    HUFAvatarSize.medium => HUFAvatarMetrics(
        diameter: diameter,
        borderRadius: radius,
        fontSize: 14,
        iconSize: 20,
        defaultOverlap: 10,
        defaultRingWidth: 2,
      ),
    HUFAvatarSize.large => HUFAvatarMetrics(
        diameter: diameter,
        borderRadius: radius,
        fontSize: 16,
        iconSize: 24,
        defaultOverlap: 12,
        defaultRingWidth: 2,
      ),
  };
}

HUFAvatarBadgeMetrics hufAvatarBadgeMetricsFor(HUFAvatarSize size) {
  return switch (size) {
    HUFAvatarSize.small => const HUFAvatarBadgeMetrics(
        size: 16,
        fontSize: 10,
        iconSize: 10,
        horizontalPadding: 5,
        borderWidth: 2,
        outwardOffset: 8,
      ),
    HUFAvatarSize.medium => const HUFAvatarBadgeMetrics(
        size: 18,
        fontSize: 11,
        iconSize: 11,
        horizontalPadding: 6,
        borderWidth: 2,
        outwardOffset: 9,
      ),
    HUFAvatarSize.large => const HUFAvatarBadgeMetrics(
        size: 20,
        fontSize: 12,
        iconSize: 12,
        horizontalPadding: 7,
        borderWidth: 2,
        outwardOffset: 10,
      ),
  };
}

HUFAvatarBadgeColors hufAvatarBadgeColorsFor(
  HUFThemeColors palette,
  HUFAvatarBadgeColor color,
) {
  return switch (color) {
    HUFAvatarBadgeColor.defaultColor => HUFAvatarBadgeColors(
        background: palette.secondary,
        foreground: palette.secondaryForeground,
      ),
    HUFAvatarBadgeColor.accent => HUFAvatarBadgeColors(
        background: palette.primary,
        foreground: palette.primaryForeground,
      ),
    HUFAvatarBadgeColor.success => HUFAvatarBadgeColors(
        background: palette.success,
        foreground: palette.successForeground,
      ),
    HUFAvatarBadgeColor.warning => HUFAvatarBadgeColors(
        background: palette.warning,
        foreground: palette.warningForeground,
      ),
    HUFAvatarBadgeColor.danger => HUFAvatarBadgeColors(
        background: palette.danger,
        foreground: palette.dangerForeground,
      ),
  };
}

EdgeInsets hufAvatarBadgePaddingFor(
  HUFAvatarBadgePlacement placement,
  double outwardOffset,
) {
  return switch (placement) {
    HUFAvatarBadgePlacement.topRight =>
      EdgeInsets.only(top: outwardOffset, right: outwardOffset),
    HUFAvatarBadgePlacement.topLeft =>
      EdgeInsets.only(top: outwardOffset, left: outwardOffset),
    HUFAvatarBadgePlacement.bottomRight =>
      EdgeInsets.only(bottom: outwardOffset, right: outwardOffset),
    HUFAvatarBadgePlacement.bottomLeft =>
      EdgeInsets.only(bottom: outwardOffset, left: outwardOffset),
  };
}

HUFAvatarFallbackColors hufAvatarFallbackColorsFor(
  HUFThemeColors palette,
  HUFAvatarColor color,
  HUFAvatarVariant variant,
) {
  final (Color semantic, Color semanticForeground, Color semanticSoft) =
      switch (color) {
    HUFAvatarColor.defaultColor => (
        palette.primary,
        palette.primary,
        palette.cardTertiary,
      ),
    HUFAvatarColor.accent => (
        palette.primary,
        palette.primary,
        _softBackground(palette.primary, palette.background),
      ),
    HUFAvatarColor.success => (
        palette.success,
        palette.success,
        _softBackground(palette.success, palette.background),
      ),
    HUFAvatarColor.warning => (
        palette.warning,
        palette.warning,
        _softBackground(palette.warning, palette.background),
      ),
    HUFAvatarColor.danger => (
        palette.danger,
        palette.danger,
        palette.dangerSoft,
      ),
  };

  return switch (variant) {
    HUFAvatarVariant.defaultVariant => HUFAvatarFallbackColors(
        background: palette.secondary,
        foreground: semantic,
      ),
    HUFAvatarVariant.soft => HUFAvatarFallbackColors(
        background: semanticSoft,
        foreground: color == HUFAvatarColor.danger
            ? palette.dangerSoftForeground
            : semanticForeground,
      ),
  };
}

Color _softBackground(Color accent, Color pageBackground) {
  return Color.alphaBlend(accent.withValues(alpha: 0.15), pageBackground);
}

/// Colori del contatore overflow in [HUFAvatarGroup].
HUFAvatarFallbackColors hufAvatarOverflowColorsFor(HUFThemeColors palette) {
  return HUFAvatarFallbackColors(
    background: palette.secondary,
    foreground: palette.secondaryForeground,
  );
}
