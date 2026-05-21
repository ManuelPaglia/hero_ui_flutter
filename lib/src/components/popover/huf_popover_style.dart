import 'package:flutter/material.dart';

import '../../theme/huf_theme.dart';

/// Padding interno fisso del popover.
const EdgeInsets kHufPopoverPadding = EdgeInsets.all(16);

/// Gap tra titolo e descrizione nel contenuto predefinito.
const double kHufPopoverTitleDescriptionGap = 4;

/// Larghezza massima del popover.
const double kHufPopoverMaxWidth = 320;

/// Dimensione base della freccia.
const double kHufPopoverArrowSize = 8;

/// Metriche di [HUFPopover].
class HUFPopoverMetrics {
  const HUFPopoverMetrics({
    required this.padding,
    required this.borderRadius,
    required this.gap,
    required this.arrowSize,
    required this.titleFontSize,
    required this.descriptionFontSize,
    required this.maxWidth,
    required this.shadow,
  });

  final EdgeInsets padding;
  final double borderRadius;
  final double gap;
  final double arrowSize;
  final double titleFontSize;
  final double descriptionFontSize;
  final double maxWidth;
  final List<BoxShadow> shadow;
}

/// Colori risolti per [HUFPopover].
class HUFPopoverColors {
  const HUFPopoverColors({
    required this.background,
    required this.border,
    required this.titleColor,
    required this.descriptionColor,
  });

  final Color background;
  final Color border;
  final Color titleColor;
  final Color descriptionColor;
}

HUFPopoverMetrics hufPopoverMetricsFor(HUFBorderRadius borderRadius) {
  return HUFPopoverMetrics(
    padding: kHufPopoverPadding,
    borderRadius: borderRadius.value,
    gap: 8,
    arrowSize: kHufPopoverArrowSize,
    titleFontSize: 14,
    descriptionFontSize: 13,
    maxWidth: kHufPopoverMaxWidth,
    shadow: const [
      BoxShadow(
        color: Color(0x26000000),
        blurRadius: 16,
        offset: Offset(0, 4),
      ),
    ],
  );
}

HUFPopoverColors hufPopoverColorsFor(HUFThemeColors palette) {
  return HUFPopoverColors(
    background: palette.card,
    border: palette.border,
    titleColor: palette.cardForeground,
    descriptionColor: palette.cardMutedForeground,
  );
}
