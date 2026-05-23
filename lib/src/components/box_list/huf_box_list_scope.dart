import 'package:flutter/material.dart';

import 'huf_box_list_layout.dart';

/// Fornisce layout e posizione in lista agli [HUFBoxItem] figli di [HUFBoxList].
class HUFBoxListScope extends InheritedWidget {
  const HUFBoxListScope({
    super.key,
    required this.layout,
    required this.isFirst,
    required this.isLast,
    required super.child,
  });

  final HUFBoxListLayout layout;
  final bool isFirst;
  final bool isLast;

  static HUFBoxListScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<HUFBoxListScope>();
  }

  @override
  bool updateShouldNotify(HUFBoxListScope oldWidget) {
    return layout != oldWidget.layout ||
        isFirst != oldWidget.isFirst ||
        isLast != oldWidget.isLast;
  }
}
