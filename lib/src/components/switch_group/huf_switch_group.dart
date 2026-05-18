import 'package:flutter/material.dart';

import '../switch/huf_switch.dart';

/// Gruppo di [HUFSwitch] con gestione interna dello stato on/off per opzione.
///
/// Ogni figlio deve avere [HUFSwitch.optionValue] e non deve passare
/// [HUFSwitch.value] né [HUFSwitch.onChanged].
///
/// In modalità non controllata usa [initialValues] e notifica [onChanged].
/// In modalità controllata passa [values] e aggiorna lo stato dal parent.
class HUFSwitchGroup<T> extends StatefulWidget {
  const HUFSwitchGroup({
    super.key,
    required this.children,
    this.initialValues,
    this.values,
    this.onChanged,
    this.spacing = 12,
    this.runSpacing = 12,
    this.direction = Axis.horizontal,
  }) : assert(
          children.length > 0,
          'HUFSwitchGroup richiede almeno un HUFSwitch.',
        );

  final List<HUFSwitch> children;

  /// Valori inizialmente attivi (modalità non controllata).
  final Set<T>? initialValues;

  /// Valori attualmente attivi (modalità controllata).
  final Set<T>? values;

  final ValueChanged<Set<T>>? onChanged;
  final double spacing;
  final double runSpacing;
  final Axis direction;

  @override
  State<HUFSwitchGroup<T>> createState() => _HUFSwitchGroupState<T>();
}

class _HUFSwitchGroupState<T> extends State<HUFSwitchGroup<T>> {
  late Set<T> _active;

  bool get _isControlled => widget.values != null;

  @override
  void initState() {
    super.initState();
    _active = Set<T>.from(widget.values ?? widget.initialValues ?? {});
    _assertChildren();
  }

  @override
  void didUpdateWidget(HUFSwitchGroup<T> oldWidget) {
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
      'Ogni HUFSwitch in HUFSwitchGroup deve avere optionValue.',
    );
    assert(
      widget.children.every((child) => child.value == null && child.onChanged == null),
      'I figli di HUFSwitchGroup non devono avere value né onChanged.',
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

  @override
  Widget build(BuildContext context) {
    final active = _isControlled ? widget.values! : _active;

    final wiredChildren = widget.children.map((child) {
      final optionValue = child.optionValue! as T;
      final isOn = active.contains(optionValue);

      return child.copyWith(
        value: isOn,
        onChanged: child.enabled
            ? (on) => _handleItemChanged(optionValue, on)
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
