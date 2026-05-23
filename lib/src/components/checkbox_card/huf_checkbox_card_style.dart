import 'package:flutter/material.dart';

import '../../theme/huf_theme.dart';
import '../box_item/huf_box_item_style.dart';
import '../checkbox/huf_checkbox_size.dart';
import '../checkbox/huf_checkbox_style.dart';

/// Metriche indicatore per [HUFCheckboxCard].
class HUFCheckboxCardIndicatorMetrics {
  const HUFCheckboxCardIndicatorMetrics({
    required this.indicatorSize,
    required this.indicatorIconSize,
    required this.indicatorBorderRadius,
  });

  final double indicatorSize;
  final double indicatorIconSize;
  final double indicatorBorderRadius;
}

/// Colori indicatore per [HUFCheckboxCard].
class HUFCheckboxCardIndicatorColors {
  const HUFCheckboxCardIndicatorColors({
    required this.checkedBackground,
    required this.checkedIconColor,
    required this.uncheckedBackground,
    required this.uncheckedBorder,
  });

  final Color checkedBackground;
  final Color checkedIconColor;
  final Color uncheckedBackground;
  final Color uncheckedBorder;
}

HUFCheckboxCardIndicatorMetrics hufCheckboxCardIndicatorMetricsFor(
  HUFCheckboxSize size,
  HUFBorderRadius borderRadius,
) {
  final indicatorBorderRadius =
      hufCheckboxMetricsFor(size, borderRadius).borderRadius;

  return switch (size) {
    HUFCheckboxSize.small => HUFCheckboxCardIndicatorMetrics(
        indicatorSize: 22,
        indicatorIconSize: 14,
        indicatorBorderRadius: indicatorBorderRadius,
      ),
    HUFCheckboxSize.medium => HUFCheckboxCardIndicatorMetrics(
        indicatorSize: 26,
        indicatorIconSize: 16,
        indicatorBorderRadius: indicatorBorderRadius,
      ),
    HUFCheckboxSize.large => HUFCheckboxCardIndicatorMetrics(
        indicatorSize: 30,
        indicatorIconSize: 18,
        indicatorBorderRadius: indicatorBorderRadius,
      ),
  };
}

HUFCheckboxCardIndicatorColors hufCheckboxCardIndicatorColorsFor(
  HUFThemeColors palette,
  bool isChecked,
  bool isDisabled, {
  Color? activeColor,
  Color? checkColor,
  Color? borderColor,
}) {
  final border = borderColor ?? activeColor ?? palette.primary;

  if (isDisabled) {
    return HUFCheckboxCardIndicatorColors(
      checkedBackground: palette.disabled,
      checkedIconColor: palette.disabledForeground,
      uncheckedBackground: palette.secondary.withValues(alpha: 0.5),
      uncheckedBorder: palette.disabled,
    );
  }

  final indicatorColors = hufCheckboxColorsFor(
    palette,
    isChecked,
    isDisabled,
    glowSize: HUFGlowSize.none,
    activeColor: activeColor,
    checkColor: checkColor,
    borderColor: borderColor,
  );

  return HUFCheckboxCardIndicatorColors(
    checkedBackground: indicatorColors.activeBackground,
    checkedIconColor: indicatorColors.checkColor,
    uncheckedBackground: palette.secondary.withValues(alpha: 0.85),
    uncheckedBorder: border.withValues(alpha: 0.35),
  );
}
