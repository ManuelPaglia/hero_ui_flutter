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

/// Restituisce la posizione opposta per il fallback su overflow viewport.
HUFPopoverPlacement hufPopoverFlipPlacement(HUFPopoverPlacement placement) {
  return switch (placement) {
    HUFPopoverPlacement.top => HUFPopoverPlacement.bottom,
    HUFPopoverPlacement.bottom => HUFPopoverPlacement.top,
    HUFPopoverPlacement.start => HUFPopoverPlacement.end,
    HUFPopoverPlacement.end => HUFPopoverPlacement.start,
  };
}
