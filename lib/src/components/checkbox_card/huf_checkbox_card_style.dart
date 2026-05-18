import 'package:flutter/material.dart';

import '../../theme/huf_theme.dart';
import '../checkbox/huf_checkbox_size.dart';
import '../checkbox/huf_checkbox_style.dart';

/// Metriche condivise per [HUFCheckboxCard].
class HUFCheckboxCardMetrics {
  const HUFCheckboxCardMetrics({
    required this.padding,
    required this.borderRadius,
    required this.iconGap,
    required this.indicatorGap,
    required this.titleSubtitleGap,
    required this.leadingIconSize,
    required this.titleFontSize,
    required this.subtitleFontSize,
    required this.indicatorSize,
    required this.indicatorIconSize,
  });

  final EdgeInsets padding;
  final double borderRadius;
  final double iconGap;
  final double indicatorGap;
  final double titleSubtitleGap;
  final double leadingIconSize;
  final double titleFontSize;
  final double subtitleFontSize;
  final double indicatorSize;
  final double indicatorIconSize;
}

/// Colori risolti per [HUFCheckboxCard].
class HUFCheckboxCardColors {
  const HUFCheckboxCardColors({
    required this.activeBackground,
    required this.inactiveBackground,
    required this.titleColor,
    required this.subtitleColor,
    required this.leadingIconColor,
    required this.indicatorCheckedBackground,
    required this.indicatorCheckedIconColor,
    required this.indicatorUncheckedBackground,
    required this.indicatorUncheckedBorder,
  });

  final Color activeBackground;
  final Color inactiveBackground;
  final Color titleColor;
  final Color subtitleColor;
  final Color leadingIconColor;
  final Color indicatorCheckedBackground;
  final Color indicatorCheckedIconColor;
  final Color indicatorUncheckedBackground;
  final Color indicatorUncheckedBorder;
}

HUFCheckboxCardMetrics hufCheckboxCardMetricsFor(
  HUFCheckboxSize size,
  HUFBorderRadius borderRadius,
) {
  return switch (size) {
    HUFCheckboxSize.small => HUFCheckboxCardMetrics(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        borderRadius: borderRadius.lg,
        iconGap: 12,
        indicatorGap: 12,
        titleSubtitleGap: 2,
        leadingIconSize: 20,
        titleFontSize: 14,
        subtitleFontSize: 12,
        indicatorSize: 22,
        indicatorIconSize: 14,
      ),
    HUFCheckboxSize.medium => HUFCheckboxCardMetrics(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        borderRadius: borderRadius.lg,
        iconGap: 14,
        indicatorGap: 14,
        titleSubtitleGap: 4,
        leadingIconSize: 24,
        titleFontSize: 15,
        subtitleFontSize: 13,
        indicatorSize: 26,
        indicatorIconSize: 16,
      ),
    HUFCheckboxSize.large => HUFCheckboxCardMetrics(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        borderRadius: borderRadius.lg,
        iconGap: 16,
        indicatorGap: 16,
        titleSubtitleGap: 4,
        leadingIconSize: 28,
        titleFontSize: 16,
        subtitleFontSize: 14,
        indicatorSize: 30,
        indicatorIconSize: 18,
      ),
  };
}

HUFCheckboxCardColors hufCheckboxCardColorsFor(
  HUFThemeColors palette,
  bool isChecked,
  bool isDisabled, {
  Color? activeColor,
  Color? checkColor,
  Color? borderColor,
}) {
  final active = activeColor ?? palette.primary;
  final border = borderColor ?? active;

  if (isDisabled) {
    return HUFCheckboxCardColors(
      activeBackground: palette.secondary.withValues(alpha: 0.35),
      inactiveBackground: palette.secondary.withValues(alpha: 0.25),
      titleColor: palette.disabled,
      subtitleColor: palette.disabled,
      leadingIconColor: palette.disabled,
      indicatorCheckedBackground: palette.disabled,
      indicatorCheckedIconColor: palette.disabledForeground,
      indicatorUncheckedBackground: palette.secondary.withValues(alpha: 0.5),
      indicatorUncheckedBorder: palette.disabled,
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

  return HUFCheckboxCardColors(
    activeBackground: Color.alphaBlend(
      active.withValues(alpha: 0.14),
      palette.secondary.withValues(alpha: 0.45),
    ),
    inactiveBackground: palette.secondary.withValues(alpha: 0.45),
    titleColor: palette.secondaryForeground,
    subtitleColor: palette.secondaryForeground.withValues(alpha: 0.65),
    leadingIconColor: active,
    indicatorCheckedBackground: indicatorColors.activeBackground,
    indicatorCheckedIconColor: indicatorColors.checkColor,
    indicatorUncheckedBackground: palette.secondary.withValues(alpha: 0.85),
    indicatorUncheckedBorder: border.withValues(alpha: 0.35),
  );
}
