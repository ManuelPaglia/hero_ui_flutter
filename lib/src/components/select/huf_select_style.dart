import 'package:flutter/material.dart';

import '../../theme/huf_theme.dart';
import '../field/huf_field_style.dart';

/// Padding interno del pannello menu.
const EdgeInsets kHufSelectMenuPadding = EdgeInsets.all(8);

/// Altezza massima scrollabile del menu.
const double kHufSelectMenuMaxHeight = 320;

/// Metriche di [HUFSelect] (menu; il trigger usa [HUFFieldMetrics]).
class HUFSelectMetrics {
  const HUFSelectMetrics({
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
    required this.menuBackground,
    required this.menuBorder,
    required this.itemForeground,
    required this.itemSubtitle,
    required this.itemHighlight,
    required this.sectionHeader,
    required this.checkIcon,
    required this.disabledForeground,
  });

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

/// Stile testo del menu select (alias di [hufFieldTextStyle]).
TextStyle hufSelectTextStyle({
  required double fontSize,
  required Color color,
  FontWeight fontWeight = FontWeight.w400,
  double height = 1.3,
}) {
  return hufFieldTextStyle(
    fontSize: fontSize,
    color: color,
    fontWeight: fontWeight,
    height: height,
  );
}

HUFSelectColors hufSelectColorsFor(HUFThemeColors palette) {
  return HUFSelectColors(
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
