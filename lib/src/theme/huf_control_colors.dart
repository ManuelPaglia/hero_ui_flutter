import 'package:flutter/material.dart';

import 'huf_theme_colors.dart';

/// Pallino radio / thumb su track accent ([HUFThemeColors.primaryForeground]).
Color hufAccentControlFill(HUFThemeColors palette) => palette.primaryForeground;

/// Thumb switch spento: sempre bianco, indipendentemente dal [HUFThemePreset].
const Color hufSwitchOffThumbFill = Color(0xFFFFFFFF);
