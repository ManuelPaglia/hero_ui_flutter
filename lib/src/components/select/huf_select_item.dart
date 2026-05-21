import 'package:flutter/widgets.dart';

/// Voce di un [HUFSelect].
@immutable
class HUFSelectItem<T> {
  const HUFSelectItem({
    required this.value,
    required this.label,
    this.subtitle,
    this.leading,
    this.enabled = true,
  });

  final T value;
  final String label;
  final String? subtitle;
  final Widget? leading;
  final bool enabled;
}

/// Sezione raggruppata con intestazione opzionale nel menu di [HUFSelect].
@immutable
class HUFSelectSection<T> {
  const HUFSelectSection({
    required this.items,
    this.header,
    this.showSeparatorBefore = false,
  });

  final String? header;
  final List<HUFSelectItem<T>> items;

  /// Mostra un [HUFSeparator] sopra l'intestazione (es. tra continenti).
  final bool showSeparatorBefore;
}
