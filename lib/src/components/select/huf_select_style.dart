import 'package:flutter/material.dart';

import '../../theme/huf_theme.dart';

/// Padding interno del pannello menu.
const EdgeInsets kHufSelectMenuPadding = EdgeInsets.all(8);

/// Altezza massima scrollabile del menu.
const double kHufSelectMenuMaxHeight = 320;

/// Metriche di [HUFSelect].
class HUFSelectMetrics {
  const HUFSelectMetrics({
    required this.triggerHeight,
    required this.triggerHorizontalPadding,
    required this.triggerFontSize,
    required this.labelFontSize,
    required this.labelGap,
    required this.menuPadding,
    required this.menuGap,
    required this.menuMaxHeight,
    required this.itemVerticalPadding,
    required this.itemHorizontalPadding,
    required this.itemFontSize,
    required this.itemSubtitleFontSize,
    required this.sectionHeaderFontSize,
    required this.sectionHeaderVerticalPadding,
    required this.borderRadius,
    required this.iconSize,
    required this.checkIconSize,
    required this.shadow,
  });

  final double triggerHeight;
  final double triggerHorizontalPadding;
  final double triggerFontSize;
  final double labelFontSize;
  final double labelGap;
  final EdgeInsets menuPadding;
  final double menuGap;
  final double menuMaxHeight;
  final double itemVerticalPadding;
  final double itemHorizontalPadding;
  final double itemFontSize;
  final double itemSubtitleFontSize;
  final double sectionHeaderFontSize;
  final double sectionHeaderVerticalPadding;
  final double borderRadius;
  final double iconSize;
  final double checkIconSize;
  final List<BoxShadow> shadow;
}

/// Colori risolti per [HUFSelect].
class HUFSelectColors {
  const HUFSelectColors({
    required this.triggerBackground,
    required this.triggerBorder,
    required this.triggerForeground,
    required this.placeholder,
    required this.label,
    required this.menuBackground,
    required this.menuBorder,
    required this.itemForeground,
    required this.itemSubtitle,
    required this.itemHighlight,
    required this.sectionHeader,
    required this.checkIcon,
    required this.disabledForeground,
  });

  final Color triggerBackground;
  final Color triggerBorder;
  final Color triggerForeground;
  final Color placeholder;
  final Color label;
  final Color menuBackground;
  final Color menuBorder;
  final Color itemForeground;
  final Color itemSubtitle;
  final Color itemHighlight;
  final Color sectionHeader;
  final Color checkIcon;
  final Color disabledForeground;
}

HUFSelectMetrics hufSelectMetricsFor(HUFBorderRadius borderRadius) {
  return HUFSelectMetrics(
    triggerHeight: 44,
    triggerHorizontalPadding: 14,
    triggerFontSize: 14,
    labelFontSize: 14,
    labelGap: 6,
    menuPadding: kHufSelectMenuPadding,
    menuGap: 6,
    menuMaxHeight: kHufSelectMenuMaxHeight,
    itemVerticalPadding: 10,
    itemHorizontalPadding: 12,
    itemFontSize: 14,
    itemSubtitleFontSize: 12,
    sectionHeaderFontSize: 12,
    sectionHeaderVerticalPadding: 8,
    borderRadius: borderRadius.value,
    iconSize: 20,
    checkIconSize: 18,
    shadow: const [
      BoxShadow(
        color: Color(0x26000000),
        blurRadius: 16,
        offset: Offset(0, 4),
      ),
    ],
  );
}

/// Stile testo senza sottolineature (evita decorazioni ereditate dal tema / web).
TextStyle hufSelectTextStyle({
  required double fontSize,
  required Color color,
  FontWeight fontWeight = FontWeight.w400,
  double height = 1.3,
}) {
  return TextStyle(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    height: height,
    decoration: TextDecoration.none,
    decorationColor: color,
  );
}

HUFSelectColors hufSelectColorsFor(HUFThemeColors palette) {
  return HUFSelectColors(
    triggerBackground: palette.cardSecondary,
    triggerBorder: palette.border,
    triggerForeground: palette.cardForeground,
    placeholder: palette.cardMutedForeground,
    label: palette.cardForeground,
    menuBackground: palette.card,
    menuBorder: palette.border,
    itemForeground: palette.cardForeground,
    itemSubtitle: palette.cardMutedForeground,
    itemHighlight: palette.cardTertiary,
    sectionHeader: palette.cardMutedForeground,
    checkIcon: palette.cardForeground,
    disabledForeground: palette.disabledForeground,
  );
}
