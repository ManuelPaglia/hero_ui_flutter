import 'package:flutter/material.dart';

import '../../theme/huf_control_colors.dart';
import '../../theme/huf_theme.dart';
import 'huf_radio_button_size.dart';

/// Metriche condivise per [HUFRadioButton].
class HUFRadioButtonMetrics {
  const HUFRadioButtonMetrics({
    required this.size,
    required this.dotSize,
    required this.borderWidth,
    required this.selectedBorderWidth,
    required this.labelGap,
  });

  final double size;
  final double dotSize;
  final double borderWidth;
  final double selectedBorderWidth;
  final double labelGap;
}

/// Colori risolti per [HUFRadioButton] (identici per ogni [HUFThemePreset]).
class HUFRadioButtonColors {
  const HUFRadioButtonColors({
    required this.backgroundColor,
    required this.borderColor,
    required this.dotColor,
    this.boxShadow,
  });

  /// Sfondo del cerchio ([HUFThemeColors.card]).
  final Color backgroundColor;

  /// Bordo: [HUFThemeColors.primary] se selezionato, [HUFThemeColors.border] altrimenti.
  final Color borderColor;

  /// Pallino interno (stesso token del thumb su accent: [hufAccentControlFill]).
  final Color dotColor;
  final List<BoxShadow>? boxShadow;
}

HUFRadioButtonMetrics hufRadioButtonMetricsFor(HUFRadioButtonSize size) {
  return switch (size) {
    HUFRadioButtonSize.small => const HUFRadioButtonMetrics(
        size: 16,
        dotSize: 6,
        borderWidth: 1.5,
        selectedBorderWidth: 4,
        labelGap: 6,
      ),
    HUFRadioButtonSize.medium => const HUFRadioButtonMetrics(
        size: 20,
        dotSize: 8,
        borderWidth: 1.5,
        selectedBorderWidth: 5,
        labelGap: 8,
      ),
    HUFRadioButtonSize.large => const HUFRadioButtonMetrics(
        size: 24,
        dotSize: 10,
        borderWidth: 2,
        selectedBorderWidth: 6,
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
  final background = palette.card;
  final fill = dotColor ?? hufAccentControlFill(palette);

  if (isDisabled) {
    return HUFRadioButtonColors(
      backgroundColor: background,
      borderColor: palette.disabled,
      dotColor: palette.disabledForeground,
    );
  }

  if (value) {
    return HUFRadioButtonColors(
      backgroundColor: background,
      borderColor: borderColor ?? active,
      dotColor: fill,
      boxShadow: hufGlowShadowFor(glowSize, active),
    );
  }

  return HUFRadioButtonColors(
    backgroundColor: background,
    borderColor: borderColor ?? palette.border,
    dotColor: fill,
  );
}
