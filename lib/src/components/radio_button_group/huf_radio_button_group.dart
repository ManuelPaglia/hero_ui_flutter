import 'package:flutter/material.dart';

import '../radio_button/huf_radio_button.dart';

/// Gruppo di [HUFRadioButton] con gestione interna della selezione singola.
///
/// Ogni figlio deve avere [HUFRadioButton.optionValue] e non deve passare
/// [HUFRadioButton.value] né [HUFRadioButton.onChanged].
///
/// In modalità non controllata usa [initialValue] e notifica [onChanged].
/// In modalità controllata passa [value] e aggiorna lo stato dal parent.
class HUFRadioButtonGroup<T> extends StatefulWidget {
  const HUFRadioButtonGroup({
    super.key,
    required this.children,
    this.initialValue,
    this.value,
    this.onChanged,
    this.spacing = 12,
    this.runSpacing = 12,
    this.direction = Axis.vertical,
  }) : assert(
          children.length > 0,
          'HUFRadioButtonGroup richiede almeno un HUFRadioButton.',
        );

  final List<HUFRadioButton> children;

  /// Valore iniziale (modalità non controllata).
  final T? initialValue;

  /// Valore corrente (modalità controllata).
  final T? value;

  final ValueChanged<T>? onChanged;
  final double spacing;
  final double runSpacing;
  final Axis direction;

  @override
  State<HUFRadioButtonGroup<T>> createState() => _HUFRadioButtonGroupState<T>();
}

class _HUFRadioButtonGroupState<T> extends State<HUFRadioButtonGroup<T>> {
  T? _selected;

  bool get _isControlled => widget.value != null;

  @override
  void initState() {
    super.initState();
    _selected = widget.value ?? widget.initialValue;
    _assertChildren();
  }

  @override
  void didUpdateWidget(HUFRadioButtonGroup<T> oldWidget) {
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
      'Ogni HUFRadioButton in HUFRadioButtonGroup deve avere optionValue.',
    );
    assert(
      widget.children.every((child) => child.value == null && child.onChanged == null),
      'I figli di HUFRadioButtonGroup non devono avere value né onChanged.',
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

  @override
  Widget build(BuildContext context) {
    final selected = _isControlled ? widget.value : _selected;

    final wiredChildren = widget.children.map((child) {
      final optionValue = child.optionValue! as T;
      final isSelected = selected == optionValue;

      return child.copyWith(
        value: isSelected,
        onChanged: child.enabled
            ? (_) => _handleItemSelected(optionValue)
            : null,
      );
    }).toList();

    if (widget.direction == Axis.vertical) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _spacedChildren(wiredChildren, widget.spacing),
      );
    }

    return Wrap(
      spacing: widget.spacing,
      runSpacing: widget.runSpacing,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: wiredChildren,
    );
  }

  List<Widget> _spacedChildren(List<Widget> children, double spacing) {
    if (children.length <= 1) return children;

    final spaced = <Widget>[children.first];
    for (var i = 1; i < children.length; i++) {
      spaced
        ..add(SizedBox(height: spacing))
        ..add(children[i]);
    }
    return spaced;
  }
}
