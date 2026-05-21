import 'package:flutter/material.dart';

import '../components/alert/huf_alert.dart';
import 'huf_alert_overlay.dart';

export 'huf_alert_overlay.dart'
    show HUFAlertOverlay, HUFAlertOverlayEntry, HUFAlertOverlayState, HUFShowAlertOptions;

int _alertIdCounter = 0;

String _nextAlertId([String? id]) {
  if (id != null && id.isNotEmpty) return id;
  _alertIdCounter += 1;
  return 'huf_alert_$_alertIdCounter';
}

/// Mostra un [HUFAlert] nell'angolo dello schermo tramite [HUFAlertOverlay].
///
/// Richiede che l'app sia avvolta da [HUFAlertOverlay] (es. nel `builder` di
/// [MaterialApp]). Restituisce l'id dell'alert per [hufDismissAlert].
///
/// Compatibile con il pattern overlay di Flutter: non usa [showDialog] né scrim.
String hufShowAlert(
  BuildContext context, {
  HUFShowAlertOptions? options,
}) {
  final resolved = options ?? HUFShowAlertOptions();
  final overlay = HUFAlertOverlay.maybeOf(context);
  assert(
    overlay != null,
    'hufShowAlert richiede un antenato HUFAlertOverlay. '
    'Avvolgi MaterialApp con HUFAlertOverlay nel builder.',
  );

  final id = _nextAlertId(resolved.id);
  overlay!.insert(
    HUFAlertOverlayEntry(
      id: id,
      position: resolved.position,
      margin: resolved.margin,
      duration: resolved.duration,
      alert: resolved.toAlert(),
      onDismissed: resolved.onDismissed,
    ),
  );
  return id;
}

/// Rimuove l'alert con [id] dall'overlay.
void hufDismissAlert(BuildContext context, String id) {
  HUFAlertOverlay.maybeOf(context)?.dismiss(id);
}

/// Rimuove tutti gli alert dall'overlay.
void hufDismissAllAlerts(BuildContext context) {
  HUFAlertOverlay.maybeOf(context)?.dismissAll();
}

/// Estensione su [BuildContext] per show/dismiss degli alert.
extension HUFAlertContext on BuildContext {
  String showHufAlert({HUFShowAlertOptions? options}) {
    return hufShowAlert(this, options: options);
  }

  void dismissHufAlert(String id) => hufDismissAlert(this, id);

  void dismissAllHufAlerts() => hufDismissAllAlerts(this);
}
