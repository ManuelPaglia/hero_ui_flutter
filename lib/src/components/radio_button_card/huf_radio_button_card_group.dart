import 'package:flutter/material.dart';

import '../box_list/huf_box_list.dart';
import '../box_list/huf_box_list_layout.dart';
import 'huf_radio_button_card.dart';

/// Gruppo di [HUFRadioButtonCard] con gestione interna della selezione singola.
///
/// Usa [HUFBoxList] per il layout visivo (`separated` / `united`).
class HUFRadioButtonCardGroup<T> extends StatefulWidget {
  const HUFRadioButtonCardGroup({
    super.key,
    required this.children,
    this.initialValue,
    this.value,
    this.onChanged,
    this.spacing = 12,
    this.runSpacing = 12,
    this.direction = Axis.vertical,
    this.layout = HUFBoxListLayout.separated,
    this.showSeparators = true,
  }) : assert(
          children.length > 0,
          'HUFRadioButtonCardGroup richiede almeno una HUFRadioButtonCard.',
        );

  final List<HUFRadioButtonCard> children;
  final T? initialValue;
  final T? value;
  final ValueChanged<T>? onChanged;
  final double spacing;
  final double runSpacing;
  final Axis direction;
  final HUFBoxListLayout layout;
  final bool showSeparators;

  @override
  State<HUFRadioButtonCardGroup<T>> createState() =>
      _HUFRadioButtonCardGroupState<T>();
}

class _HUFRadioButtonCardGroupState<T> extends State<HUFRadioButtonCardGroup<T>> {
  T? _selected;

  bool get _isControlled => widget.value != null;

  @override
  void initState() {
    super.initState();
    _selected = widget.value ?? widget.initialValue;
    _assertChildren();
  }

  @override
  void didUpdateWidget(HUFRadioButtonCardGroup<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.children != oldWidget.children) {
      _assertChildren();
    }
    if (_isControlled && widget.value != oldWidget.value) {
      _selected = widget.value;
    }
  }

  void _assertChildren() {
    assert(
      widget.children.every((child) => child.optionValue != null),
      'Ogni HUFRadioButtonCard in HUFRadioButtonCardGroup deve avere optionValue.',
    );
    assert(
      widget.children.every((child) => child.value == null && child.onChanged == null),
      'I figli di HUFRadioButtonCardGroup non devono avere value né onChanged.',
    );
  }

  void _handleItemSelected(T value) {
    if (_isControlled) {
      widget.onChanged?.call(value);
      return;
    }

    setState(() => _selected = value);
    widget.onChanged?.call(value);
  }

  List<HUFRadioButtonCard> _wireChildren(T? selected) {
    return widget.children.map((child) {
      final optionValue = child.optionValue! as T;
      final isSelected = selected == optionValue;

      return child.copyWith(
        value: isSelected,
        onChanged: child.enabled
            ? (_) => _handleItemSelected(optionValue)
            : null,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final selected = _isControlled ? widget.value : _selected;

    return HUFBoxList(
      layout: widget.layout,
      showSeparators: widget.showSeparators,
      spacing: widget.spacing,
      runSpacing: widget.runSpacing,
      direction: widget.direction,
      children: _wireChildren(selected),
    );
  }
}
