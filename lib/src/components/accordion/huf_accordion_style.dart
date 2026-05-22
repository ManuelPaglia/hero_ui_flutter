import 'package:flutter/material.dart';

import '../../theme/huf_theme.dart';
import 'huf_accordion_variant.dart';

/// Padding orizzontale dell'header di ogni item.
const double kHufAccordionHeaderHorizontalPadding = 12;

/// Padding verticale dell'header di ogni item.
const double kHufAccordionHeaderVerticalPadding = 14;

/// Spaziatura tra icona sinistra e titolo.
const double kHufAccordionLeadingGap = 12;

/// Spaziatura tra titolo e icona di espansione.
const double kHufAccordionTrailingGap = 8;

/// Spaziatura tra header e contenuto espanso.
const double kHufAccordionContentTopGap = 4;

/// Padding inferiore del contenuto espanso.
const double kHufAccordionContentBottomPadding = 14;

/// Inset orizzontale dei separatori nel variant card.
const double kHufAccordionSeparatorInset = 12;

/// Metriche di [HUFAccordion] (senza size: valori fissi).
class HUFAccordionMetrics {
  const HUFAccordionMetrics({
    required this.borderRadius,
    required this.headerHorizontalPadding,
    required this.headerVerticalPadding,
    required this.leadingGap,
    required this.trailingGap,
    required this.contentTopGap,
    required this.contentBottomPadding,
    required this.separatorInset,
    required this.titleFontSize,
    required this.contentFontSize,
    required this.iconSize,
  });

  final double borderRadius;
  final double headerHorizontalPadding;
  final double headerVerticalPadding;
  final double leadingGap;
  final double trailingGap;
  final double contentTopGap;
  final double contentBottomPadding;
  final double separatorInset;
  final double titleFontSize;
  final double contentFontSize;
  final double iconSize;
}

/// Colori risolti per [HUFAccordion].
class HUFAccordionColors {
  const HUFAccordionColors({
    required this.background,
    required this.titleColor,
    required this.contentColor,
    required this.iconColor,
    required this.separatorColor,
  });

  final Color background;
  final Color titleColor;
  final Color contentColor;
  final Color iconColor;
  final Color separatorColor;
}

HUFAccordionMetrics hufAccordionMetricsFor(HUFBorderRadius borderRadius) {
  return HUFAccordionMetrics(
    borderRadius: borderRadius.value,
    headerHorizontalPadding: kHufAccordionHeaderHorizontalPadding,
    headerVerticalPadding: kHufAccordionHeaderVerticalPadding,
    leadingGap: kHufAccordionLeadingGap,
    trailingGap: kHufAccordionTrailingGap,
    contentTopGap: kHufAccordionContentTopGap,
    contentBottomPadding: kHufAccordionContentBottomPadding,
    separatorInset: kHufAccordionSeparatorInset,
    titleFontSize: 15,
    contentFontSize: 14,
    iconSize: 20,
  );
}

HUFAccordionColors hufAccordionColorsFor(
  HUFThemeColors palette,
  HUFAccordionVariant variant, {
  Color? titleColor,
  Color? iconColor,
}) {
  return HUFAccordionColors(
    background: switch (variant) {
      HUFAccordionVariant.ghost => palette.transparent,
      HUFAccordionVariant.card => palette.card,
    },
    titleColor: titleColor ?? palette.cardForeground,
    contentColor: palette.cardMutedForeground,
    iconColor: iconColor ?? palette.cardForeground,
    separatorColor: palette.border,
  );
}
