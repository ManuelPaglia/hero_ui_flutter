import 'package:flutter/material.dart';

/// Definizione colonna per [HUFTable].
class HUFTableColumn<T> {
  const HUFTableColumn({
    required this.key,
    required this.label,
    this.flex = 1,
    this.allowsSorting = false,
    this.isTreeColumn = false,
    this.minWidth,
    this.alignment = Alignment.centerLeft,
    this.cellBuilder,
    this.valueBuilder,
    this.headerBuilder,
  });

  /// Identificativo univoco (ordinamento, tree).
  final String key;

  /// Testo intestazione.
  final String label;

  /// Peso relativo nella riga.
  final int flex;

  /// Se `true`, il tap sull'header cicla l'ordinamento.
  final bool allowsSorting;

  /// Colonna gerarchica: chevron e indentazione.
  final bool isTreeColumn;

  final double? minWidth;
  final AlignmentGeometry alignment;

  /// Cella custom; se assente usa [valueBuilder] o `toString()` su [T].
  final Widget Function(BuildContext context, T row)? cellBuilder;

  /// Valore testuale di default per la cella.
  final String Function(T row)? valueBuilder;

  /// Header custom (es. checkbox "seleziona tutto" gestito dalla tabella).
  final Widget Function(BuildContext context)? headerBuilder;
}
