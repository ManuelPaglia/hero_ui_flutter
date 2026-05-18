import 'package:flutter/material.dart';

import '../checkbox/huf_checkbox.dart';

/// Gruppo di [HUFCheckbox] con gestione interna della selezione.
///
/// Ogni figlio deve avere [HUFCheckbox.optionValue] e non deve passare
/// [HUFCheckbox.value] né [HUFCheckbox.onChanged].
///
/// In modalità non controllata usa [initialValues] e notifica [onChanged].
/// In modalità controllata passa [values] e aggiorna lo stato dal parent.
///
/// Con [multiSelect] `false` è selezionabile al massimo un valore alla volta.
class HUFCheckboxGroup<T> extends StatefulWidget {
  const HUFCheckboxGroup({
    super.key,
    required this.children,
    this.initialValues,
    this.values,
    this.onChanged,
    this.multiSelect = true,
    this.spacing = 12,
    this.runSpacing = 12,
    this.direction = Axis.vertical,
  }) : assert(
          children.length > 0,
          'HUFCheckboxGroup richiede almeno un HUFCheckbox.',
        );

  final List<HUFCheckbox> children;

  /// Valori iniziali (modalità non controllata).
  final Set<T>? initialValues;

  /// Valori correnti (modalità controllata).
  final Set<T>? values;

  final ValueChanged<Set<T>>? onChanged;
  final bool multiSelect;
  final double spacing;
  final double runSpacing;
  final Axis direction;

  @override
  State<HUFCheckboxGroup<T>> createState() => _HUFCheckboxGroupState<T>();
}

class _HUFCheckboxGroupState<T> extends State<HUFCheckboxGroup<T>> {
  late Set<T> _selected;

  bool get _isControlled => widget.values != null;

  @override
  void initState() {
    super.initState();
    _selected = Set<T>.from(widget.values ?? widget.initialValues ?? {});
    _assertChildren();
  }

  @override
  void didUpdateWidget(HUFCheckboxGroup<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.children != oldWidget.children) {
      _assertChildren();
    }
    if (_isControlled && widget.values != oldWidget.values) {
      _selected = Set<T>.from(widget.values!);
    }
  }

  void _assertChildren() {
    assert(
      widget.children.every((child) => child.optionValue != null),
      'Ogni HUFCheckbox in HUFCheckboxGroup deve avere optionValue.',
    );
    assert(
      widget.children.every((child) => child.value == null && child.onChanged == null),
      'I figli di HUFCheckboxGroup non devono avere value né onChanged.',
    );
  }

  void _notifyChange() {
    widget.onChanged?.call(Set<T>.unmodifiable(_selected));
  }

  void _handleItemChanged(T value, bool checked) {
    final next = Set<T>.from(_selected);

    if (widget.multiSelect) {
      if (checked) {
        next.add(value);
      } else {
        next.remove(value);
      }
    } else if (checked) {
      next
        ..clear()
        ..add(value);
    } else {
      next.remove(value);
    }

    if (_isControlled) {
      _notifyChange();
      return;
    }

    setState(() => _selected = next);
    _notifyChange();
  }

  @override
  Widget build(BuildContext context) {
    final selected = _isControlled ? widget.values! : _selected;

    final wiredChildren = widget.children.map((child) {
      final optionValue = child.optionValue! as T;
      final isSelected = selected.contains(optionValue);

      return child.copyWith(
        value: isSelected,
        onChanged: child.enabled
            ? (checked) => _handleItemChanged(optionValue, checked)
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
