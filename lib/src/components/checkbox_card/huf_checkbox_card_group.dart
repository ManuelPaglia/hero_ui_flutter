import 'package:flutter/material.dart';

import 'huf_checkbox_card.dart';

/// Gruppo di [HUFCheckboxCard] con gestione interna della selezione.
///
/// Ogni figlio deve avere [HUFCheckboxCard.optionValue] e non deve passare
/// [HUFCheckboxCard.value] né [HUFCheckboxCard.onChanged].
///
/// In modalità non controllata usa [initialValues] e notifica [onChanged].
/// In modalità controllata passa [values] e aggiorna lo stato dal parent.
///
/// Con [multiSelect] `false` è selezionabile al massimo un valore alla volta.
class HUFCheckboxCardGroup<T> extends StatefulWidget {
  const HUFCheckboxCardGroup({
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
          'HUFCheckboxCardGroup richiede almeno una HUFCheckboxCard.',
        );

  final List<HUFCheckboxCard> children;

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
  State<HUFCheckboxCardGroup<T>> createState() => _HUFCheckboxCardGroupState<T>();
}

class _HUFCheckboxCardGroupState<T> extends State<HUFCheckboxCardGroup<T>> {
  late Set<T> _selected;

  bool get _isControlled => widget.values != null;

  @override
  void initState() {
    super.initState();
    _selected = Set<T>.from(widget.values ?? widget.initialValues ?? {});
    _assertChildren();
  }

  @override
  void didUpdateWidget(HUFCheckboxCardGroup<T> oldWidget) {
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
      'Ogni HUFCheckboxCard in HUFCheckboxCardGroup deve avere optionValue.',
    );
    assert(
      widget.children.every((child) => child.value == null && child.onChanged == null),
      'I figli di HUFCheckboxCardGroup non devono avere value né onChanged.',
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
