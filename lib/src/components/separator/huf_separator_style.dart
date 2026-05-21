import 'package:flutter/material.dart';

import '../../theme/huf_theme.dart';
import 'huf_separator_variant.dart';

/// Spessore predefinito del separatore (1 logical pixel).
const double kHufSeparatorThickness = 1;

Color hufSeparatorColorFor(
  HUFThemeColors palette,
  HUFSeparatorVariant variant,
) {
  return switch (variant) {
    HUFSeparatorVariant.defaultVariant => palette.border,
    HUFSeparatorVariant.secondary => palette.cardMutedForeground.withValues(
        alpha: 0.45,
      ),
    HUFSeparatorVariant.tertiary => palette.cardMutedForeground.withValues(
        alpha: 0.28,
      ),
  };
}
