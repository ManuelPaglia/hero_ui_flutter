import 'package:flutter/material.dart';

import '../../theme/huf_theme.dart';
import '../checkbox/huf_checkbox_size.dart';
import '../radio_button/huf_radio_button_size.dart';
import '../switch/huf_switch_size.dart';
import 'huf_box_item_size.dart';

/// Metriche condivise per [HUFBoxItem].
class HUFBoxItemMetrics {
  const HUFBoxItemMetrics({
    required this.padding,
    required this.borderRadius,
    required this.iconGap,
    required this.actionGap,
    required this.titleSubtitleGap,
    required this.leadingIconSize,
    required this.titleFontSize,
    required this.subtitleFontSize,
  });

  final EdgeInsets padding;
  final double borderRadius;
  final double iconGap;
  final double actionGap;
  final double titleSubtitleGap;
  final double leadingIconSize;
  final double titleFontSize;
  final double subtitleFontSize;
}

/// Colori risolti per [HUFBoxItem].
class HUFBoxItemColors {
  const HUFBoxItemColors({
    required this.activeBackground,
    required this.inactiveBackground,
    required this.titleColor,
    required this.subtitleColor,
    required this.leadingIconColor,
  });

  final Color activeBackground;
  final Color inactiveBackground;
  final Color titleColor;
  final Color subtitleColor;
  final Color leadingIconColor;
}

HUFBoxItemMetrics hufBoxItemMetricsFor(
  HUFBoxItemSize size,
  HUFBorderRadius borderRadius,
) {
  return switch (size) {
    HUFBoxItemSize.small => HUFBoxItemMetrics(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        borderRadius: borderRadius.value,
        iconGap: 12,
        actionGap: 12,
        titleSubtitleGap: 2,
        leadingIconSize: 20,
        titleFontSize: 14,
        subtitleFontSize: 12,
      ),
    HUFBoxItemSize.medium => HUFBoxItemMetrics(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        borderRadius: borderRadius.value,
        iconGap: 14,
        actionGap: 14,
        titleSubtitleGap: 4,
        leadingIconSize: 24,
        titleFontSize: 15,
        subtitleFontSize: 13,
      ),
    HUFBoxItemSize.large => HUFBoxItemMetrics(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        borderRadius: borderRadius.value,
        iconGap: 16,
        actionGap: 16,
        titleSubtitleGap: 4,
        leadingIconSize: 28,
        titleFontSize: 16,
        subtitleFontSize: 14,
      ),
  };
}

HUFBoxItemSize hufBoxItemSizeFromCheckbox(HUFCheckboxSize size) {
  return switch (size) {
    HUFCheckboxSize.small => HUFBoxItemSize.small,
    HUFCheckboxSize.medium => HUFBoxItemSize.medium,
    HUFCheckboxSize.large => HUFBoxItemSize.large,
  };
}

HUFBoxItemSize hufBoxItemSizeFromSwitch(HUFSwitchSize size) {
  return switch (size) {
    HUFSwitchSize.small => HUFBoxItemSize.small,
    HUFSwitchSize.medium => HUFBoxItemSize.medium,
    HUFSwitchSize.large => HUFBoxItemSize.large,
  };
}

HUFBoxItemSize hufBoxItemSizeFromRadio(HUFRadioButtonSize size) {
  return switch (size) {
    HUFRadioButtonSize.small => HUFBoxItemSize.small,
    HUFRadioButtonSize.medium => HUFBoxItemSize.medium,
    HUFRadioButtonSize.large => HUFBoxItemSize.large,
  };
}

HUFBoxItemColors hufBoxItemColorsFor(
  HUFThemeColors palette,
  bool highlighted,
  bool isDisabled, {
  Color? activeColor,
}) {
  final active = activeColor ?? palette.primary;

  if (isDisabled) {
    return HUFBoxItemColors(
      activeBackground: palette.secondary.withValues(alpha: 0.35),
      inactiveBackground: palette.secondary.withValues(alpha: 0.25),
      titleColor: palette.disabled,
      subtitleColor: palette.disabled,
      leadingIconColor: palette.disabled,
    );
  }

  return HUFBoxItemColors(
    activeBackground: Color.alphaBlend(
      active.withValues(alpha: 0.14),
      palette.secondary.withValues(alpha: 0.45),
    ),
    inactiveBackground: palette.secondary.withValues(alpha: 0.45),
    titleColor: palette.secondaryForeground,
    subtitleColor: palette.secondaryForeground.withValues(alpha: 0.65),
    leadingIconColor: active,
  );
}
