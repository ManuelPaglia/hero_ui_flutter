import 'dart:async';

import 'package:flutter/material.dart';

/// Feedback di scala al press per [HUFButton] e segmenti di [HUFButtonGroup].
///
/// Garantisce una durata minima visibile dello stato pressed, così un tap
/// rapido su mobile mostra comunque l'animazione di scala.
mixin HUFButtonPressScaleMixin<T extends StatefulWidget> on State<T> {
  static const double pressedScale = 0.97;
  static const Duration pressAnimationDuration = Duration(milliseconds: 120);

  bool _isPressed = false;
  DateTime? _pressedAt;
  Timer? _releaseTimer;

  double pressScaleFor(bool enabled) =>
      enabled && _isPressed ? pressedScale : 1.0;

  void disposeHufButtonPressScale() {
    _releaseTimer?.cancel();
  }

  void handleHufButtonPressStart() {
    _releaseTimer?.cancel();
    _pressedAt = DateTime.now();
    _setHufButtonPressed(true);
  }

  void handleHufButtonPressEnd() {
    final pressedAt = _pressedAt;
    if (pressedAt == null) {
      _setHufButtonPressed(false);
      return;
    }

    final elapsed = DateTime.now().difference(pressedAt);
    final remaining = pressAnimationDuration - elapsed;

    void release() {
      if (!mounted) return;
      _pressedAt = null;
      _setHufButtonPressed(false);
    }

    if (remaining <= Duration.zero) {
      release();
    } else {
      _releaseTimer?.cancel();
      _releaseTimer = Timer(remaining, release);
    }
  }

  void _setHufButtonPressed(bool value) {
    if (_isPressed == value) return;
    setState(() => _isPressed = value);
  }
}
