import 'package:flutter/material.dart';

import '../../theme/huf_theme.dart';
import 'huf_chip_size.dart';
import 'huf_chip_variant.dart';

/// Metriche di [HUFChip], più compatte rispetto a [HUFButton].
class HUFChipMetrics {
  const HUFChipMetrics({
    required this.height,
    required this.horizontalPadding,
    required this.fontSize,
    required this.borderRadius,
    required this.iconSize,
    required this.gap,
  });

  final double height;
  final double horizontalPadding;
  final double fontSize;
  final double borderRadius;
  final double iconSize;
  final double gap;
}

/// Colori per chip del design system.
class HUFChipColors {
  const HUFChipColors({
    required this.background,
    required this.foreground,
    this.border,
  });

  final Color background;
  final Color foreground;
  final Border? border;
}

const double hufChipOutlinedBorderWidth = 1;

HUFChipMetrics hufChipMetricsFor(
  HUFChipSize size,
  HUFBorderRadius borderRadius,
) {
  return switch (size) {
    HUFChipSize.small => HUFChipMetrics(
        height: 24,
        horizontalPadding: 8,
        fontSize: 11,
        borderRadius: borderRadius.sm,
        iconSize: 12,
        gap: 4,
      ),
    HUFChipSize.medium => HUFChipMetrics(
        height: 28,
        horizontalPadding: 10,
        fontSize: 12,
        borderRadius: borderRadius.md,
        iconSize: 14,
        gap: 5,
      ),
    HUFChipSize.large => HUFChipMetrics(
        height: 32,
        horizontalPadding: 12,
        fontSize: 13,
        borderRadius: borderRadius.lg,
        iconSize: 16,
        gap: 6,
      ),
  };
}

HUFChipColors hufChipColorsFor(
  HUFThemeColors palette,
  HUFChipVariant variant,
  bool isDisabled,
) {
  Border? outlinedBorder(Color color) {
    if (variant != HUFChipVariant.outlined) return null;
    return Border.all(color: color, width: hufChipOutlinedBorderWidth);
  }

  if (isDisabled) {
    return switch (variant) {
      HUFChipVariant.outlined => HUFChipColors(
          background: palette.transparent,
          foreground: palette.disabled,
          border: outlinedBorder(palette.disabled),
        ),
      HUFChipVariant.ghost => HUFChipColors(
          background: palette.transparent,
          foreground: palette.disabled,
        ),
      HUFChipVariant.primary => HUFChipColors(
          background: palette.disabled,
          foreground: palette.disabledForeground,
        ),
    };
  }

  return switch (variant) {
    HUFChipVariant.primary => HUFChipColors(
        background: palette.primary,
        foreground: palette.primaryForeground,
      ),
    HUFChipVariant.outlined => HUFChipColors(
        background: palette.transparent,
        foreground: palette.primary,
        border: outlinedBorder(palette.primary),
      ),
    HUFChipVariant.ghost => HUFChipColors(
        background: palette.transparent,
        foreground: palette.primary,
      ),
  };
}
