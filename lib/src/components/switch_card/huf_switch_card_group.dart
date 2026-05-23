import 'package:flutter/material.dart';

import '../box_list/huf_box_list.dart';
import '../box_list/huf_box_list_layout.dart';
import 'huf_switch_card.dart';

/// Gruppo di [HUFSwitchCard] con gestione interna dello stato on/off per opzione.
///
/// Usa [HUFBoxList] per il layout visivo (`separated` / `united`).
class HUFSwitchCardGroup<T> extends StatefulWidget {
  const HUFSwitchCardGroup({
    super.key,
    required this.children,
    this.initialValues,
    this.values,
    this.onChanged,
    this.spacing = 12,
    this.runSpacing = 12,
    this.direction = Axis.vertical,
    this.layout = HUFBoxListLayout.separated,
    this.showSeparators = true,
  }) : assert(
          children.length > 0,
          'HUFSwitchCardGroup richiede almeno una HUFSwitchCard.',
        );

  final List<HUFSwitchCard> children;
  final Set<T>? initialValues;
  final Set<T>? values;
  final ValueChanged<Set<T>>? onChanged;
  final double spacing;
  final double runSpacing;
  final Axis direction;
  final HUFBoxListLayout layout;
  final bool showSeparators;

  @override
  State<HUFSwitchCardGroup<T>> createState() => _HUFSwitchCardGroupState<T>();
}

class _HUFSwitchCardGroupState<T> extends State<HUFSwitchCardGroup<T>> {
  late Set<T> _active;

  bool get _isControlled => widget.values != null;

  @override
  void initState() {
    super.initState();
    _active = Set<T>.from(widget.values ?? widget.initialValues ?? {});
    _assertChildren();
  }

  @override
  void didUpdateWidget(HUFSwitchCardGroup<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.children != oldWidget.children) {
      _assertChildren();
    }
    if (_isControlled && widget.values != oldWidget.values) {
      _active = Set<T>.from(widget.values!);
    }
  }

  void _assertChildren() {
    assert(
      widget.children.every((child) => child.optionValue != null),
      'Ogni HUFSwitchCard in HUFSwitchCardGroup deve avere optionValue.',
    );
    assert(
      widget.children.every((child) => child.value == null && child.onChanged == null),
      'I figli di HUFSwitchCardGroup non devono avere value né onChanged.',
    );
  }

  void _notifyChange() {
    widget.onChanged?.call(Set<T>.unmodifiable(_active));
  }

  void _handleItemChanged(T value, bool isOn) {
    final next = Set<T>.from(_active);
    if (isOn) {
      next.add(value);
    } else {
      next.remove(value);
    }

    if (_isControlled) {
      _notifyChange();
      return;
    }

    setState(() => _active = next);
    _notifyChange();
  }

  List<HUFSwitchCard> _wireChildren(Set<T> active) {
    return widget.children.map((child) {
      final optionValue = child.optionValue! as T;
      final isOn = active.contains(optionValue);

      return child.copyWith(
        value: isOn,
        onChanged: child.enabled
            ? (on) => _handleItemChanged(optionValue, on)
            : null,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final active = _isControlled ? widget.values! : _active;

    return HUFBoxList(
      layout: widget.layout,
      showSeparators: widget.showSeparators,
      spacing: widget.spacing,
      runSpacing: widget.runSpacing,
      direction: widget.direction,
      children: _wireChildren(active),
    );
  }
}
