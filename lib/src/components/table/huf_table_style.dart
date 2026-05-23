import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/huf_theme.dart';
import 'huf_table_column.dart';
import 'huf_table_selection_mode.dart';
import 'huf_table_variant.dart';

/// Metriche condivise per [HUFTable].
class HUFTableMetrics {
  const HUFTableMetrics({
    required this.borderRadius,
    required this.cellPaddingHorizontal,
    required this.cellPaddingVertical,
    required this.headerFontSize,
    required this.bodyFontSize,
    required this.footerFontSize,
    required this.selectionSummaryFontSize,
    required this.emptyStateIconSize,
    required this.treeIndent,
    required this.minRowHeight,
    required this.columnFlexUnitWidth,
    required this.selectionColumnWidth,
    required this.horizontalScrollShadowSize,
    required this.bodyInset,
    required this.headerBodyGap,
  });

  final double borderRadius;
  final double cellPaddingHorizontal;
  final double cellPaddingVertical;
  final double headerFontSize;
  final double bodyFontSize;
  final double footerFontSize;
  final double selectionSummaryFontSize;
  final double emptyStateIconSize;
  final double treeIndent;
  final double minRowHeight;

  /// Larghezza base per unità di [HUFTableColumn.flex] in layout scrollabile.
  final double columnFlexUnitWidth;

  /// Larghezza colonna checkbox di selezione.
  final double selectionColumnWidth;

  /// Profondità ombre [HUFScrollShadow] su scroll orizzontale/verticale.
  final double horizontalScrollShadowSize;

  /// Padding tra bordo esterno e pannello righe ([HUFTableVariant.primary]).
  final double bodyInset;

  /// Spazio tra header e pannello righe.
  final double headerBodyGap;
}

/// Colori risolti per [HUFTable].
class HUFTableColors {
  const HUFTableColors({
    required this.containerColor,
    required this.containerBorderColor,
    required this.headerBackgroundColor,
    required this.headerTextColor,
    required this.bodyTextColor,
    required this.dividerColor,
    required this.rowHoverColor,
    required this.rowSelectedColor,
    required this.stripedRowColor,
    required this.footerTextColor,
    required this.emptyStateColor,
    required this.sortIconColor,
    required this.bodyBackgroundColor,
  });

  final Color containerColor;
  final Color containerBorderColor;
  final Color headerBackgroundColor;
  final Color headerTextColor;
  final Color bodyTextColor;
  final Color dividerColor;
  final Color rowHoverColor;
  final Color rowSelectedColor;
  final Color stripedRowColor;
  final Color footerTextColor;
  final Color emptyStateColor;
  final Color sortIconColor;

  /// Sfondo del pannello righe incassato (variante primary).
  final Color bodyBackgroundColor;
}

/// Gap fisso tra bordo esterno e pannello righe (sempre costante, primary).
const double kHufTableBodyInset = 10;

/// Spazio tra header e pannello righe (primary).
const double kHufTableHeaderBodyGap = 8;

HUFTableMetrics hufTableMetricsFor(HUFBorderRadius borderRadius) {
  final containerRadius = borderRadius.lg;

  return HUFTableMetrics(
    borderRadius: containerRadius,
    cellPaddingHorizontal: 16,
    cellPaddingVertical: 14,
    headerFontSize: 13,
    bodyFontSize: 14,
    footerFontSize: 13,
    selectionSummaryFontSize: 13,
    emptyStateIconSize: 40,
    treeIndent: 20,
    minRowHeight: 48,
    columnFlexUnitWidth: 112,
    selectionColumnWidth: 44,
    horizontalScrollShadowSize: 28,
    bodyInset: kHufTableBodyInset,
    headerBodyGap: kHufTableHeaderBodyGap,
  );
}

/// Radius del pannello righe interno: solo il radius esterno meno l'inset fisso.
double hufTableBodyBorderRadius(double containerRadius, double bodyInset) {
  final inner = containerRadius - bodyInset;
  return inner > 0 ? inner : 0;
}

/// [BorderRadius] del pannello righe primary; con [hasFooter] solo angoli superiori.
BorderRadius hufTableBodyPanelShape({
  required double bodyRadius,
  required bool hasFooter,
}) {
  if (bodyRadius <= 0) return BorderRadius.zero;
  final radius = Radius.circular(bodyRadius);
  if (hasFooter) {
    return BorderRadius.only(topLeft: radius, topRight: radius);
  }
  return BorderRadius.all(radius);
}

/// Larghezze fisse per colonna quando la tabella scrolla in orizzontale.
List<double> hufTableColumnWidthsFor<T>(
  List<HUFTableColumn<T>> columns,
  HUFTableMetrics metrics,
) {
  return columns
      .map(
        (column) => math.max(
          column.minWidth ?? 0,
          metrics.columnFlexUnitWidth * column.flex,
        ),
      )
      .toList();
}

/// Larghezza minima del contenuto tabella (header + righe).
double hufTableMinContentWidthFor<T>({
  required List<HUFTableColumn<T>> columns,
  required HUFTableMetrics metrics,
  required HUFTableSelectionMode selectionMode,
  HUFTableVariant variant = HUFTableVariant.primary,
}) {
  final columnWidths = hufTableColumnWidthsFor(columns, metrics);
  var total = metrics.cellPaddingHorizontal * 2;
  if (variant == HUFTableVariant.primary) {
    total += metrics.bodyInset * 2;
  }
  if (selectionMode != HUFTableSelectionMode.none) {
    total += metrics.selectionColumnWidth;
  }
  for (final width in columnWidths) {
    total += width;
  }
  return total;
}

HUFTableColors hufTableColorsFor(
  HUFThemeColors palette, {
  Color? containerColor,
  Color? containerBorderColor,
  Color? headerBackgroundColor,
  Color? headerTextColor,
  Color? bodyTextColor,
  Color? dividerColor,
  Color? rowHoverColor,
  Color? rowSelectedColor,
  Color? stripedRowColor,
  Color? footerTextColor,
  Color? emptyStateColor,
  Color? sortIconColor,
  Color? bodyBackgroundColor,
}) {
  return HUFTableColors(
    containerColor: containerColor ?? palette.card,
    containerBorderColor: containerBorderColor ?? palette.border,
    headerBackgroundColor: headerBackgroundColor ?? palette.cardSecondary,
    headerTextColor: headerTextColor ?? palette.cardMutedForeground,
    bodyTextColor: bodyTextColor ?? palette.cardForeground,
    dividerColor: dividerColor ?? palette.border,
    rowHoverColor: rowHoverColor ?? palette.cardTertiary,
    rowSelectedColor: rowSelectedColor ?? palette.cardSecondary,
    stripedRowColor: stripedRowColor ?? palette.cardTertiary.withValues(alpha: 0.45),
    footerTextColor: footerTextColor ?? palette.cardMutedForeground,
    emptyStateColor: emptyStateColor ?? palette.cardMutedForeground,
    sortIconColor: sortIconColor ?? palette.cardMutedForeground,
    bodyBackgroundColor: bodyBackgroundColor ?? palette.cardSecondary,
  );
}
