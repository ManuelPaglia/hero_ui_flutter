import 'package:flutter/material.dart';

import '../../theme/huf_glow.dart';
import '../../theme/huf_theme.dart';
import 'huf_checkbox_size.dart';

/// Metriche condivise per [HUFCheckbox].
class HUFCheckboxMetrics {
  const HUFCheckboxMetrics({
    required this.size,
    required this.borderRadius,
    required this.checkIconSize,
    required this.borderWidth,
    required this.labelGap,
  });

  final double size;
  final double borderRadius;
  final double checkIconSize;
  final double borderWidth;

  /// Spazio tra box e label quando si usa [HUFCheckbox] con testo.
  final double labelGap;
}

/// Colori risolti per [HUFCheckbox].
class HUFCheckboxColors {
  const HUFCheckboxColors({
    required this.activeBackground,
    required this.checkColor,
    required this.inactiveBackground,
    required this.inactiveBorder,
    required this.activeBorder,
    this.boxShadow,
  });

  final Color activeBackground;
  final Color checkColor;
  final Color inactiveBackground;
  final Color inactiveBorder;
  final Color activeBorder;
  final List<BoxShadow>? boxShadow;
}

HUFCheckboxMetrics hufCheckboxMetricsFor(
  HUFCheckboxSize size,
  HUFBorderRadius borderRadius,
) {
  return switch (size) {
    HUFCheckboxSize.small => HUFCheckboxMetrics(
        size: 16,
        borderRadius: borderRadius.sm,
        checkIconSize: 12,
        borderWidth: 1.5,
        labelGap: 6,
      ),
    HUFCheckboxSize.medium => HUFCheckboxMetrics(
        size: 20,
        borderRadius: borderRadius.md,
        checkIconSize: 14,
        borderWidth: 1.5,
        labelGap: 8,
      ),
    HUFCheckboxSize.large => HUFCheckboxMetrics(
        size: 24,
        borderRadius: borderRadius.lg,
        checkIconSize: 18,
        borderWidth: 2,
        labelGap: 10,
      ),
  };
}

HUFCheckboxColors hufCheckboxColorsFor(
  HUFThemeColors palette,
  bool value,
  bool isDisabled, {
  HUFGlowSize glowSize = HUFGlowSize.medium,
  Color? activeColor,
  Color? checkColor,
  Color? borderColor,
}) {
  final active = activeColor ?? palette.primary;
  final check = checkColor ?? palette.primaryForeground;
  final border = borderColor ?? active;

  if (isDisabled) {
    return HUFCheckboxColors(
      activeBackground: palette.disabled,
      checkColor: palette.disabledForeground,
      inactiveBackground: palette.transparent,
      inactiveBorder: palette.disabled,
      activeBorder: palette.disabled,
    );
  }

  final glow = value ? hufGlowShadowFor(glowSize, active) : null;

  if (value) {
    return HUFCheckboxColors(
      activeBackground: active,
      checkColor: check,
      inactiveBackground: palette.transparent,
      inactiveBorder: border,
      activeBorder: active,
      boxShadow: glow,
    );
  }

  return HUFCheckboxColors(
    activeBackground: active,
    checkColor: check,
    inactiveBackground: palette.transparent,
    inactiveBorder: border,
    activeBorder: active,
  );
}
