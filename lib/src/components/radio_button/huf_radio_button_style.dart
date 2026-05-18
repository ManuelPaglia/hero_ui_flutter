import 'package:flutter/material.dart';

import '../../theme/huf_theme.dart';
import 'huf_radio_button_size.dart';

/// Metriche condivise per [HUFRadioButton].
class HUFRadioButtonMetrics {
  const HUFRadioButtonMetrics({
    required this.size,
    required this.dotSize,
    required this.borderWidth,
    required this.labelGap,
  });

  final double size;
  final double dotSize;
  final double borderWidth;
  final double labelGap;
}

/// Colori risolti per [HUFRadioButton].
class HUFRadioButtonColors {
  const HUFRadioButtonColors({
    required this.activeBorder,
    required this.inactiveBorder,
    required this.dotColor,
    this.boxShadow,
  });

  final Color activeBorder;
  final Color inactiveBorder;
  final Color dotColor;
  final List<BoxShadow>? boxShadow;
}

HUFRadioButtonMetrics hufRadioButtonMetricsFor(HUFRadioButtonSize size) {
  return switch (size) {
    HUFRadioButtonSize.small => const HUFRadioButtonMetrics(
        size: 16,
        dotSize: 8,
        borderWidth: 1.5,
        labelGap: 6,
      ),
    HUFRadioButtonSize.medium => const HUFRadioButtonMetrics(
        size: 20,
        dotSize: 10,
        borderWidth: 1.5,
        labelGap: 8,
      ),
    HUFRadioButtonSize.large => const HUFRadioButtonMetrics(
        size: 24,
        dotSize: 12,
        borderWidth: 2,
        labelGap: 10,
      ),
  };
}

HUFRadioButtonColors hufRadioButtonColorsFor(
  HUFThemeColors palette,
  bool value,
  bool isDisabled, {
  HUFGlowSize glowSize = HUFGlowSize.medium,
  Color? activeColor,
  Color? dotColor,
  Color? borderColor,
}) {
  final active = activeColor ?? palette.primary;
  final dot = dotColor ?? active;
  final border = borderColor ?? active;

  if (isDisabled) {
    return HUFRadioButtonColors(
      activeBorder: palette.disabled,
      inactiveBorder: palette.disabled,
      dotColor: palette.disabledForeground,
    );
  }

  final glow = value ? hufGlowShadowFor(glowSize, active) : null;

  if (value) {
    return HUFRadioButtonColors(
      activeBorder: active,
      inactiveBorder: border,
      dotColor: dot,
      boxShadow: glow,
    );
  }

  return HUFRadioButtonColors(
    activeBorder: active,
    inactiveBorder: border,
    dotColor: dot,
  );
}
