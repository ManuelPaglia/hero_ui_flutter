import 'package:flutter/material.dart';

import '../popover/huf_popover_placement.dart';

/// Configurazione del popover su [HUFButton].
///
/// Se impostato, il tap sul pulsante apre o chiude il popover ancorato al bottone
/// invece di invocare [HUFButton.onPressed].
class HUFButtonPopover {
  const HUFButtonPopover({
    required this.child,
    this.placement = HUFPopoverPlacement.bottom,
    this.align = HUFPopoverAlign.center,
    this.showArrow = false,
    this.offset,
    this.isOpen,
    this.onOpenChanged,
    this.initialOpen = false,
    this.closeOnTapOutside = true,
  });

  /// Contenuto del popover (es. [HUFPopoverContent] o widget custom).
  final Widget child;

  /// Posizione preferita rispetto al pulsante.
  final HUFPopoverPlacement placement;

  /// Allineamento del popover sul pulsante (`center`, `left`, `right`).
  final HUFPopoverAlign align;

  /// Mostra una freccia che punta verso il pulsante.
  final bool showArrow;

  /// Gap tra pulsante e popover; se null usa le metriche del tema.
  final double? offset;

  /// Stato aperto controllato dall'esterno.
  final bool? isOpen;

  /// Invocato quando lo stato aperto/chiuso cambia.
  final ValueChanged<bool>? onOpenChanged;

  /// Stato iniziale in modalità non controllata.
  final bool initialOpen;

  /// Chiude il popover al tap fuori dal contenuto.
  final bool closeOnTapOutside;
}
