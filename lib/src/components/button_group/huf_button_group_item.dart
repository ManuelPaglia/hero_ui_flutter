import 'package:flutter/material.dart';

/// Elemento cliccabile di un [HUFButtonGroup].
class HUFButtonGroupItem {
  const HUFButtonGroupItem({
    this.label,
    this.icon,
    this.onPressed,
  }) : assert(
          label != null || icon != null,
          'HUFButtonGroupItem richiede almeno label o icon.',
        );

  final String? label;
  final Widget? icon;
  final VoidCallback? onPressed;

  bool get isIconOnly =>
      icon != null && (label == null || label!.isEmpty);
}
