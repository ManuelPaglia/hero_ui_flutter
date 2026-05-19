import 'package:flutter/foundation.dart';

import 'huf_border_radius.dart';
import 'huf_glow.dart';
import 'huf_theme_colors.dart';

/// Override per una singola modalità (light o dark).
@immutable
class HUFThemePalette {
  const HUFThemePalette({
    this.colors,
    this.borderRadius,
    this.glowSize,
  });

  final HUFThemeColors? colors;
  final HUFBorderRadius? borderRadius;
  final HUFGlowSize? glowSize;
}
