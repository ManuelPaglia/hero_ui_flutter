import 'package:flutter/material.dart';

import '../../theme/huf_theme.dart';
import '../radio_button/huf_radio_button_size.dart';
import '../radio_button/huf_radio_button_style.dart';

HUFRadioButtonMetrics hufRadioButtonCardRadioMetricsFor(HUFRadioButtonSize size) =>
    hufRadioButtonMetricsFor(size);

HUFRadioButtonColors hufRadioButtonCardRadioColorsFor(
  HUFThemeColors palette,
  bool isSelected,
  bool isDisabled, {
  required HUFGlowSize glowSize,
  Color? activeColor,
  Color? dotColor,
  Color? borderColor,
}) =>
    hufRadioButtonColorsFor(
      palette,
      isSelected,
      isDisabled,
      glowSize: isDisabled ? HUFGlowSize.none : glowSize,
      activeColor: activeColor,
      dotColor: dotColor,
      borderColor: borderColor,
    );
