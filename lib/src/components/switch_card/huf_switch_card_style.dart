import 'package:flutter/material.dart';

import '../../theme/huf_theme.dart';
import '../switch/huf_switch_size.dart';
import '../switch/huf_switch_style.dart';

HUFSwitchMetrics hufSwitchCardSwitchMetricsFor(
  HUFSwitchSize size,
  HUFBorderRadius borderRadius,
) =>
    hufSwitchMetricsFor(size, borderRadius);

HUFSwitchColors hufSwitchCardSwitchColorsFor(
  HUFThemeColors palette,
  bool isOn,
  bool isDisabled, {
  required HUFGlowSize glowSize,
  Color? activeColor,
  Color? thumbColor,
  Color? inactiveTrackColor,
  Color? iconColor,
}) =>
    hufSwitchColorsFor(
      palette,
      isOn,
      isDisabled,
      glowSize: isDisabled ? HUFGlowSize.none : glowSize,
      activeColor: activeColor,
      thumbColor: thumbColor,
      inactiveTrackColor: inactiveTrackColor,
      iconColor: iconColor,
    );
