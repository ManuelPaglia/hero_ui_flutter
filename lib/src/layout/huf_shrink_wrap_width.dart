import 'package:flutter/material.dart';

/// Impone larghezza intrinseca al [child] anche dentro parent con vincoli
/// orizzontali stretti (`ListView`, `Column` con `crossAxisAlignment: stretch`, …).
///
/// ## Perché serve
///
/// In Flutter, quando un parent passa constraint **tight** sull'asse orizzontale
/// (`minWidth == maxWidth`, tipico di [ListView] e [Column] stretched), i figli
/// non possono restringersi: [Row] con `mainAxisSize: min`, [IntrinsicWidth] e
/// container senza larghezza esplicita vengono **forzati** a occupare tutta la riga.
///
/// Il sintomo visivo è uno sfondo (colore, bordo, glow) che si estende per tutta
/// la larghezza disponibile anche se il contenuto è più corto.
///
/// [Align] con [widthFactor] applicato a `1` passa constraint **loose** al
/// [child] (`minWidth: 0`, `maxWidth: parent`) e, quando possibile, restringe
/// anche lo slot di layout alla larghezza del contenuto.
class HUFShrinkWrapWidth extends StatelessWidget {
  const HUFShrinkWrapWidth({
    super.key,
    required this.child,
    this.alignment = Alignment.centerLeft,
  });

  final Widget child;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      widthFactor: 1,
      child: child,
    );
  }
}
