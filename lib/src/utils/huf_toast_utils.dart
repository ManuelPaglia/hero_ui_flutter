import 'package:flutter/material.dart';

import 'huf_toast_overlay.dart';

export 'huf_toast_overlay.dart'
    show
        HUFShowToastOptions,
        HUFToastOverlay,
        HUFToastOverlayEntry,
        HUFToastOverlayState;

export '../components/toast/huf_toast_position.dart' show HUFToastPosition;

int _toastIdCounter = 0;

String _nextToastId([String? id]) {
  if (id != null && id.isNotEmpty) return id;
  _toastIdCounter += 1;
  return 'huf_toast_$_toastIdCounter';
}

/// Mostra un [HUFToast] al centro alto o basso tramite [HUFToastOverlay].
///
/// Richiede che l'app sia avvolta da [HUFToastOverlay]. Restituisce l'id del
/// toast per [hufDismissToast].
String hufShowToast(
  BuildContext context, {
  required HUFShowToastOptions options,
}) {
  final overlay = HUFToastOverlay.maybeOf(context);
  assert(
    overlay != null,
    'hufShowToast richiede un antenato HUFToastOverlay. '
    'Avvolgi MaterialApp con HUFToastOverlay nel builder.',
  );

  final id = _nextToastId(options.id);
  overlay!.insert(
    HUFToastOverlayEntry(
      id: id,
      position: options.position,
      margin: options.margin,
      duration: options.duration,
      toast: options.toToast(),
      onDismissed: options.onDismissed,
    ),
  );
  return id;
}

/// Rimuove il toast con [id] dall'overlay (con animazione di uscita).
void hufDismissToast(BuildContext context, String id) {
  HUFToastOverlay.maybeOf(context)?.dismiss(id);
}

/// Rimuove tutti i toast dall'overlay.
void hufDismissAllToasts(BuildContext context) {
  HUFToastOverlay.maybeOf(context)?.dismissAll();
}

extension HUFToastContext on BuildContext {
  String showHufToast({required HUFShowToastOptions options}) {
    return hufShowToast(this, options: options);
  }

  void dismissHufToast(String id) => hufDismissToast(this, id);

  void dismissAllHufToasts() => hufDismissAllToasts(this);
}
