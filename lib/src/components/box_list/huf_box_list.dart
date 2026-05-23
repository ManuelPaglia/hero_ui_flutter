import 'package:flutter/material.dart';

import 'huf_box_list_layout.dart';
import 'huf_box_list_layout_utils.dart';
import 'huf_box_list_scope.dart';

/// Contenitore per [HUFBoxItem] e widget derivati (checkbox/radio/switch card, mix).
///
/// Con [layout] [HUFBoxListLayout.separated] (default) gli item sono distanziati.
/// Con [HUFBoxListLayout.united] formano un blocco unico stile accordion card.
///
/// Ogni figlio riceve posizione e layout tramite [HUFBoxListScope].
class HUFBoxList extends StatelessWidget {
  const HUFBoxList({
    super.key,
    required this.children,
    this.layout = HUFBoxListLayout.separated,
    this.showSeparators = true,
    this.spacing = 12,
    this.runSpacing = 12,
    this.direction = Axis.vertical,
  }) : assert(
          children.length > 0,
          'HUFBoxList richiede almeno un figlio.',
        );

  final List<Widget> children;
  final HUFBoxListLayout layout;
  final bool showSeparators;
  final double spacing;
  final double runSpacing;
  final Axis direction;

  @override
  Widget build(BuildContext context) {
    final scopedChildren = List<Widget>.generate(children.length, (index) {
      return HUFBoxListScope(
        layout: layout,
        isFirst: index == 0,
        isLast: index == children.length - 1,
        child: children[index],
      );
    });

    if (layout == HUFBoxListLayout.united) {
      assert(
        direction == Axis.vertical,
        'HUFBoxList con layout united richiede direction: Axis.vertical.',
      );
      return hufBoxListUnitedGroup(
        context: context,
        children: scopedChildren,
        showSeparators: showSeparators,
      );
    }

    if (direction == Axis.vertical) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _spacedChildren(scopedChildren, spacing),
      );
    }

    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: scopedChildren,
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
