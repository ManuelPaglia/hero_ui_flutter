/// Posizione preferita del menu rispetto al trigger di [HUFSelect].
enum HUFSelectPlacement {
  /// Menu sopra il trigger.
  top,

  /// Menu sotto il trigger (default).
  bottom,
}

/// Restituisce il placement opposto per il fallback su overflow viewport.
HUFSelectPlacement hufSelectFlipPlacement(HUFSelectPlacement placement) {
  return switch (placement) {
    HUFSelectPlacement.top => HUFSelectPlacement.bottom,
    HUFSelectPlacement.bottom => HUFSelectPlacement.top,
  };
}
