import 'package:flutter/material.dart';

import '../../theme/huf_theme.dart';

/// Altezza del campo (input e trigger select).
const double kHufFieldHeight = 44;

/// Padding orizzontale interno del campo.
const double kHufFieldHorizontalPadding = 14;

/// Dimensione font label e testo campo.
const double kHufFieldLabelFontSize = 14;
const double kHufFieldTextFontSize = 14;

/// Gap tra label e campo.
const double kHufFieldLabelGap = 6;

/// Spessore bordo del campo (fisso in tutti gli stati per evitare layout shift).
const double kHufFieldBorderWidth = 2;

/// Durata della transizione colore bordo in focus.
const Duration kHufFieldBorderAnimationDuration = Duration(milliseconds: 150);

/// @deprecated Usa [kHufFieldBorderWidth]. Mantenuto per compatibilità test/export.
const double kHufFieldFocusBorderWidth = kHufFieldBorderWidth;

/// Metriche condivise da [HUFInput] e trigger di [HUFSelect].
class HUFFieldMetrics {
  const HUFFieldMetrics({
    required this.height,
    required this.horizontalPadding,
    required this.fontSize,
    required this.labelFontSize,
    required this.labelGap,
    required this.borderRadius,
    required this.borderWidth,
    required this.focusBorderWidth,
    required this.iconSize,
  });

  final double height;
  final double horizontalPadding;
  final double fontSize;
  final double labelFontSize;
  final double labelGap;
  final double borderRadius;
  final double borderWidth;
  final double focusBorderWidth;
  final double iconSize;
}

/// Colori condivisi da [HUFInput] e trigger di [HUFSelect].
class HUFFieldColors {
  const HUFFieldColors({
    required this.background,
    required this.border,
    required this.focusBorder,
    required this.foreground,
    required this.hint,
    required this.label,
    required this.disabledForeground,
  });

  final Color background;
  final Color border;
  final Color focusBorder;
  final Color foreground;
  final Color hint;
  final Color label;
  final Color disabledForeground;
}

HUFFieldMetrics hufFieldMetricsFor(HUFBorderRadius borderRadius) {
  return HUFFieldMetrics(
    height: kHufFieldHeight,
    horizontalPadding: kHufFieldHorizontalPadding,
    fontSize: kHufFieldTextFontSize,
    labelFontSize: kHufFieldLabelFontSize,
    labelGap: kHufFieldLabelGap,
    borderRadius: borderRadius.value,
    borderWidth: kHufFieldBorderWidth,
    focusBorderWidth: kHufFieldFocusBorderWidth,
    iconSize: 20,
  );
}

/// Stile testo senza sottolineature (evita decorazioni ereditate dal tema / web).
TextStyle hufFieldTextStyle({
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

HUFFieldColors hufFieldColorsFor(HUFThemeColors palette) {
  return HUFFieldColors(
    background: palette.cardSecondary,
    border: palette.border,
    focusBorder: palette.primary,
    foreground: palette.cardForeground,
    hint: palette.cardMutedForeground,
    label: palette.cardForeground,
    disabledForeground: palette.disabledForeground,
  );
}
