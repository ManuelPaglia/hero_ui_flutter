import 'package:flutter/material.dart';

import '../../theme/huf_glow.dart';
import '../../theme/huf_theme.dart';
import 'huf_button_size.dart';
import 'huf_button_variant.dart';

/// Metriche condivise tra [HUFButton] e [HUFButtonGroup].
class HUFButtonMetrics {
  const HUFButtonMetrics({
    required this.height,
    required this.horizontalPadding,
    required this.fontSize,
    required this.borderRadius,
    required this.iconSize,
    required this.gap,
    required this.iconOnlySize,
  });

  final double height;
  final double horizontalPadding;
  final double fontSize;
  final double borderRadius;
  final double iconSize;
  final double gap;

  /// Lato del quadrato icon-only (include compensazione bordo).
  final double iconOnlySize;
}

/// Padding layout glow predefinito ([HUFGlowSize.medium]).
const EdgeInsets hufButtonGlowLayoutPadding = EdgeInsets.symmetric(
  vertical: 6,
  horizontal: 2,
);

/// Colori conmotionati per pulsanti del design system.
class HUFButtonColors {
  const HUFButtonColors({
    required this.background,
    required this.foreground,
    this.border,
    this.boxShadow,
  });

  final Color background;
  final Color foreground;
  final Border? border;
  final List<BoxShadow>? boxShadow;
}

List<BoxShadow> hufButtonGlowShadow(
  Color color, {
  HUFGlowSize glowSize = HUFGlowSize.medium,
}) {
  return hufGlowShadowFor(glowSize, color);
}

HUFButtonMetrics hufButtonMetricsFor(
  HUFButtonSize size,
  bool isIconOnly,
  HUFBorderRadius borderRadius,
) {
  return switch (size) {
    HUFButtonSize.small => HUFButtonMetrics(
        height: 36,
        horizontalPadding: 14,
        fontSize: 13,
        borderRadius: borderRadius.sm,
        iconSize: isIconOnly ? 18 : 16,
        gap: 6,
        iconOnlySize: 36,
      ),
    HUFButtonSize.medium => HUFButtonMetrics(
        height: 44,
        horizontalPadding: 18,
        fontSize: 15,
        borderRadius: borderRadius.md,
        iconSize: isIconOnly ? 20 : 18,
        gap: 8,
        iconOnlySize: 44,
      ),
    HUFButtonSize.large => HUFButtonMetrics(
        height: 52,
        horizontalPadding: 22,
        fontSize: 16,
        borderRadius: borderRadius.lg,
        iconSize: isIconOnly ? 22 : 20,
        gap: 10,
        iconOnlySize: 52,
      ),
  };
}

const double hufButtonLabeledOutlinedBorderWidth = 1;
const double hufButtonIconOnlyOutlinedBorderWidth = 1.5;

HUFButtonColors hufButtonColorsFor(
  HUFThemeColors palette,
  HUFButtonVariant variant,
  bool isDisabled, {
  bool isIconOnly = false,
  HUFGlowSize glowSize = HUFGlowSize.medium,
}) {
  Border? outlinedBorder(Color color) {
    if (variant != HUFButtonVariant.outlined) return null;
    final width = isIconOnly
        ? hufButtonIconOnlyOutlinedBorderWidth
        : hufButtonLabeledOutlinedBorderWidth;
    return Border.all(color: color, width: width);
  }

  if (isDisabled) {
    return switch (variant) {
      HUFButtonVariant.outlined => HUFButtonColors(
          background: palette.transparent,
          foreground: palette.disabled,
          border: outlinedBorder(palette.disabled),
        ),
      HUFButtonVariant.ghost => HUFButtonColors(
          background: palette.transparent,
          foreground: palette.disabled,
        ),
      HUFButtonVariant.dangerSoft => HUFButtonColors(
          background: palette.disabled.withValues(alpha: 0.35),
          foreground: palette.disabled,
        ),
      HUFButtonVariant.primary ||
      HUFButtonVariant.secondary ||
      HUFButtonVariant.danger =>
        HUFButtonColors(
          background: palette.disabled,
          foreground: palette.disabledForeground,
        ),
    };
  }

  return switch (variant) {
    HUFButtonVariant.primary => HUFButtonColors(
        background: palette.primary,
        foreground: palette.primaryForeground,
        boxShadow: hufButtonGlowShadow(palette.primary, glowSize: glowSize),
      ),
    HUFButtonVariant.secondary => HUFButtonColors(
        background: palette.secondary,
        foreground: palette.secondaryForeground,
      ),
    HUFButtonVariant.outlined => HUFButtonColors(
        background: isIconOnly
            ? palette.primary.withValues(alpha: 0.1)
            : palette.transparent,
        foreground: palette.primary,
        border: outlinedBorder(palette.primary),
      ),
    HUFButtonVariant.ghost => HUFButtonColors(
        background: palette.transparent,
        foreground: palette.primary,
      ),
    HUFButtonVariant.danger => HUFButtonColors(
        background: palette.danger,
        foreground: palette.dangerForeground,
        boxShadow: hufButtonGlowShadow(palette.danger, glowSize: glowSize),
      ),
    HUFButtonVariant.dangerSoft => HUFButtonColors(
        background: palette.dangerSoft,
        foreground: palette.dangerSoftForeground,
      ),
  };
}

/// Radius per segmento in un [HUFButtonGroup]: solo gli angoli esterni.
BorderRadius hufButtonGroupSegmentRadius({
  required double radius,
  required bool isFirst,
  required bool isLast,
}) {
  return BorderRadius.only(
    topLeft: Radius.circular(isFirst ? radius : 0),
    bottomLeft: Radius.circular(isFirst ? radius : 0),
    topRight: Radius.circular(isLast ? radius : 0),
    bottomRight: Radius.circular(isLast ? radius : 0),
  );
}
