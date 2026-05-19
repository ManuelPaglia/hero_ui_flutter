import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/huf_theme.dart';
import 'huf_card_radius_size.dart';

/// Sfondo della card.
enum HUFCardStyle {
  transparent,
  card,
  cardSecondary,
  cardTertiary,
}

/// Disposizione verticale o orizzontale del contenuto.
enum HUFCardOrientation {
  vertical,
  horizontal,
}

/// Padding interno fisso: non varia con il preset radius del tema.
const EdgeInsets kHufCardPadding = EdgeInsets.all(16);

/// Spaziatura tra sezioni interne (fissa, indipendente dal token radius).
const double kHufCardSectionGap = 12;

const double kHufCardTitleSubtitleGap = 4;

/// Larghezza immagine in layout orizzontale.
const double kHufCardHorizontalImageExtent = 96;

/// Allineamento di più azioni (pulsanti).
enum HUFCardActionsLayout {
  /// Azioni impilate verticalmente.
  stacked,

  /// Azioni sulla stessa riga (con wrap se necessario).
  row,
}

/// Radius esterno della card, clampato alle dimensioni disponibili.
double hufCardEffectiveOuterRadius({
  required double borderRadius,
  required double width,
  double? height,
}) {
  final maxFromWidth = width / 2;
  final maxFromHeight = height != null && height.isFinite && height > 0
      ? height / 2
      : double.infinity;
  final maxOuter = math.min(maxFromWidth, maxFromHeight);
  return math.min(borderRadius, maxOuter);
}

/// Radius dell'immagine interna, clampato alle dimensioni disponibili.
double hufCardEffectiveInnerRadius({
  required double borderRadius,
  required double width,
  required double height,
}) {
  final maxInner = math.min(width / 2, height / 2);
  return math.min(borderRadius, maxInner);
}

/// Metriche derivate dal token radius del tema.
class HUFCardMetrics {
  const HUFCardMetrics({
    required this.borderRadius,
    required this.padding,
    required this.sectionGap,
    required this.titleSubtitleGap,
    required this.titleFontSize,
    required this.subtitleFontSize,
    required this.horizontalImageExtent,
    required this.imageAspectRatio,
  });

  /// Stesso token radius condiviso da tutti i componenti.
  final double borderRadius;

  final EdgeInsets padding;
  final double sectionGap;
  final double titleSubtitleGap;
  final double titleFontSize;
  final double subtitleFontSize;

  /// Larghezza dell'immagine in layout orizzontale.
  final double horizontalImageExtent;

  /// Aspect ratio predefinito per l'immagine in layout verticale.
  final double imageAspectRatio;
}

/// Colori risolti per [HUFCard].
class HUFCardColors {
  const HUFCardColors({
    required this.background,
    required this.titleColor,
    required this.subtitleColor,
  });

  final Color background;
  final Color titleColor;
  final Color subtitleColor;
}

HUFCardMetrics hufCardMetricsFor(
  HUFCardRadiusSize size,
  HUFBorderRadius borderRadius,
) {
  return HUFCardMetrics(
    borderRadius: borderRadius.value,
    padding: kHufCardPadding,
    sectionGap: kHufCardSectionGap,
    titleSubtitleGap: kHufCardTitleSubtitleGap,
    titleFontSize: switch (size) {
      HUFCardRadiusSize.small => 14,
      HUFCardRadiusSize.medium => 15,
      HUFCardRadiusSize.large => 16,
    },
    subtitleFontSize: switch (size) {
      HUFCardRadiusSize.small => 12,
      HUFCardRadiusSize.medium => 13,
      HUFCardRadiusSize.large => 14,
    },
    horizontalImageExtent: kHufCardHorizontalImageExtent,
    imageAspectRatio: 16 / 9,
  );
}

Color hufCardBackgroundFor(HUFThemeColors palette, HUFCardStyle style) {
  return switch (style) {
    HUFCardStyle.transparent => palette.transparent,
    HUFCardStyle.card => palette.card,
    HUFCardStyle.cardSecondary => palette.cardSecondary,
    HUFCardStyle.cardTertiary => palette.cardTertiary,
  };
}

HUFCardColors hufCardColorsFor(HUFThemeColors palette, HUFCardStyle style) {
  return HUFCardColors(
    background: hufCardBackgroundFor(palette, style),
    titleColor: palette.cardForeground,
    subtitleColor: palette.cardMutedForeground,
  );
}
