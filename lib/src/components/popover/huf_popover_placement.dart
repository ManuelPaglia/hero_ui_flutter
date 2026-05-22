import 'dart:ui' show Offset, Rect, Size;

/// Allineamento del popover rispetto al trigger sull'asse trasversale al
/// [HUFPopoverPlacement] (orizzontale per `top`/`bottom`, verticale per `start`/`end`).
enum HUFPopoverAlign {
  /// Centrato sul trigger (default).
  center,

  /// Bordo iniziale allineato (`left` per top/bottom, `top` per start/end).
  left,

  /// Bordo finale allineato (`right` per top/bottom, `bottom` per start/end).
  right,
}

/// Posizione del popover rispetto al trigger.
enum HUFPopoverPlacement {
  /// Sopra il trigger, centrato orizzontalmente.
  top,

  /// Sotto il trigger, centrato orizzontalmente (default).
  bottom,

  /// A sinistra del trigger (inizio in LTR), centrato verticalmente.
  start,

  /// A destra del trigger (fine in LTR), centrato verticalmente.
  end,
}

/// Lato del popover su cui disegnare la freccia che punta verso il trigger.
enum HUFPopoverArrowEdge {
  top,
  bottom,
  left,
  right,
}

/// Lato del popover su cui disegnare la freccia, dal [HUFPopoverPlacement] risolto
/// (allineato a `_popoverTopLeftFor`, incluso il fallback viewport).
HUFPopoverArrowEdge hufPopoverArrowEdgeForPlacement(
  HUFPopoverPlacement placement,
) {
  return switch (placement) {
    HUFPopoverPlacement.bottom => HUFPopoverArrowEdge.top,
    HUFPopoverPlacement.top => HUFPopoverArrowEdge.bottom,
    HUFPopoverPlacement.start => HUFPopoverArrowEdge.right,
    HUFPopoverPlacement.end => HUFPopoverArrowEdge.left,
  };
}

/// Coordinata lungo l'asse trasversale al [placement] per allineare il popover
/// al trigger secondo [align].
double hufPopoverAlignAxisOffset({
  required HUFPopoverAlign align,
  required HUFPopoverPlacement placement,
  required Rect triggerRect,
  required Size popoverSize,
}) {
  final isVerticalPlacement = switch (placement) {
    HUFPopoverPlacement.start || HUFPopoverPlacement.end => true,
    _ => false,
  };

  if (isVerticalPlacement) {
    return switch (align) {
      HUFPopoverAlign.center =>
        triggerRect.center.dy - popoverSize.height / 2,
      HUFPopoverAlign.left => triggerRect.top,
      HUFPopoverAlign.right => triggerRect.bottom - popoverSize.height,
    };
  }

  return switch (align) {
    HUFPopoverAlign.center => triggerRect.center.dx - popoverSize.width / 2,
    HUFPopoverAlign.left => triggerRect.left,
    HUFPopoverAlign.right => triggerRect.right - popoverSize.width,
  };
}

/// Offset della freccia lungo il bordo del popover (asse trasversale al bordo)
/// per puntare al centro del trigger.
double hufPopoverArrowCrossAxisOffset({
  required HUFPopoverArrowEdge edge,
  required Rect triggerRect,
  required Offset popoverGlobalTopLeft,
  required double arrowSize,
}) {
  return switch (edge) {
    HUFPopoverArrowEdge.top || HUFPopoverArrowEdge.bottom =>
      triggerRect.center.dx - popoverGlobalTopLeft.dx - arrowSize,
    HUFPopoverArrowEdge.left || HUFPopoverArrowEdge.right =>
      triggerRect.center.dy - popoverGlobalTopLeft.dy - arrowSize,
  };
}

/// Restituisce la posizione opposta per il fallback su overflow viewport.
HUFPopoverPlacement hufPopoverFlipPlacement(HUFPopoverPlacement placement) {
  return switch (placement) {
    HUFPopoverPlacement.top => HUFPopoverPlacement.bottom,
    HUFPopoverPlacement.bottom => HUFPopoverPlacement.top,
    HUFPopoverPlacement.start => HUFPopoverPlacement.end,
    HUFPopoverPlacement.end => HUFPopoverPlacement.start,
  };
}
