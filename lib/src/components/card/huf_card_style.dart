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

/// Padding interno fisso: non varia con il preset radius del tema (sharp, rounded, …).
const EdgeInsets kHufCardPadding = EdgeInsets.all(16);

/// Spaziatura tra sezioni interne (fissa, indipendente dal token radius).
const double kHufCardSectionGap = 12;

const double kHufCardTitleSubtitleGap = 4;

/// Larghezza immagine in layout orizzontale.
const double kHufCardHorizontalImageExtent = 96;

/// Valori token ≥ questa soglia indicano preset pill sul tema (es. 999).
const double kHufCardPillRadiusThreshold = 100;

/// Preset radius usato dalle card quando il tema è pill (bottoni/chip restano pill).
const HUFBorderRadius kHufCardPillFallbackBorderRadius = HUFBorderRadius.rounded;

/// Allineamento di più azioni (pulsanti).
enum HUFCardActionsLayout {
  /// Azioni impilate verticalmente.
  stacked,

  /// Azioni sulla stessa riga (con wrap se necessario).
  row,
}

/// Radius esterno con angoli concentrici rispetto a un elemento interno.
///
/// Con padding uniforme [inset] tra i due bordi: `R_esterno = R_interno + inset`.
/// Così la curva dell'immagine (o del contenuto) continua visivamente quella della card.
double hufConcentricOuterRadius({
  required double innerRadius,
  required double inset,
}) {
  return innerRadius + inset;
}

/// `true` se il tema usa il preset pill (token sentinel tipo 999).
bool hufCardThemeUsesPillPreset(HUFBorderRadius borderRadius) =>
    borderRadius.sm >= kHufCardPillRadiusThreshold;

/// Radius effettivo per [HUFCard]: con tema pill si usa [kHufCardPillFallbackBorderRadius].
HUFBorderRadius hufCardResolveBorderRadius(HUFBorderRadius borderRadius) {
  if (hufCardThemeUsesPillPreset(borderRadius)) {
    return kHufCardPillFallbackBorderRadius;
  }
  return borderRadius;
}

/// Radius esterno effettivo, clampato alle dimensioni disponibili.
double hufCardEffectiveOuterRadius({
  required double tokenInnerRadius,
  required double inset,
  required double width,
  double? height,
}) {
  final maxFromWidth = width / 2;
  final maxFromHeight = height != null && height.isFinite && height > 0
      ? height / 2
      : double.infinity;
  final maxOuter = math.min(maxFromWidth, maxFromHeight);

  final concentric = hufConcentricOuterRadius(
    innerRadius: tokenInnerRadius,
    inset: inset,
  );
  return math.min(concentric, maxOuter);
}

/// Radius interno effettivo (es. immagine), concentrico e clampato.
double hufCardEffectiveInnerRadius({
  required double tokenInnerRadius,
  required double outerRadius,
  required double inset,
  required double width,
  required double height,
}) {
  final maxInner = math.min(width / 2, height / 2);
  final concentricInner = math.max(0.0, outerRadius - inset);
  return math.min(tokenInnerRadius, math.min(maxInner, concentricInner));
}

/// Metriche derivate dal token radius del tema.
class HUFCardMetrics {
  const HUFCardMetrics({
    required this.innerBorderRadius,
    required this.padding,
    required this.sectionGap,
    required this.titleSubtitleGap,
    required this.titleFontSize,
    required this.subtitleFontSize,
    required this.horizontalImageExtent,
    required this.imageAspectRatio,
  });

  /// Token radius sm / md / lg (con tema pill → valori [HUFBorderRadius.rounded]).
  final double innerBorderRadius;

  final EdgeInsets padding;
  final double sectionGap;
  final double titleSubtitleGap;
  final double titleFontSize;
  final double subtitleFontSize;

  /// Larghezza dell'immagine in layout orizzontale (proporzionale al radius).
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
  final resolved = hufCardResolveBorderRadius(borderRadius);
  final innerRadius = switch (size) {
    HUFCardRadiusSize.small => resolved.sm,
    HUFCardRadiusSize.medium => resolved.md,
    HUFCardRadiusSize.large => resolved.lg,
  };

  return HUFCardMetrics(
    innerBorderRadius: innerRadius,
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
