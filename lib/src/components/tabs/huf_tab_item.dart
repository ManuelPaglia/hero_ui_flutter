import 'package:flutter/foundation.dart';

/// Voce di [HUFTabs].
@immutable
class HUFTabItem<T> {
  const HUFTabItem({
    required this.label,
    required this.value,
    this.enabled = true,
  });

  final String label;
  final T value;
  final bool enabled;
}
