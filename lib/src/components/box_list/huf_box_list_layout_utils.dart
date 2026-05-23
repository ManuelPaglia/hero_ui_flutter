import 'package:flutter/material.dart';

import '../../theme/huf_theme.dart';
import 'huf_box_list_layout.dart';

/// Inset orizzontale dei separatori nel layout [HUFBoxListLayout.united].
const double kHufBoxListSeparatorInset = 12;

/// Border radius di un item in base a posizione e layout.
BorderRadius hufBoxItemBorderRadius({
  required HUFBoxListLayout layout,
  required double radius,
  required bool isFirst,
  required bool isLast,
}) {
  if (layout == HUFBoxListLayout.separated) {
    return BorderRadius.circular(radius);
  }

  return BorderRadius.only(
    topLeft: Radius.circular(isFirst ? radius : 0),
    topRight: Radius.circular(isFirst ? radius : 0),
    bottomLeft: Radius.circular(isLast ? radius : 0),
    bottomRight: Radius.circular(isLast ? radius : 0),
  );
}

Widget hufBoxListUnitedSeparator({required Color color}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: kHufBoxListSeparatorInset),
    child: Divider(
      height: 1,
      thickness: 1,
      color: color,
    ),
  );
}

/// Avvolge gli item in un unico blocco con bordo e separatori opzionali.
Widget hufBoxListUnitedGroup({
  required BuildContext context,
  required List<Widget> children,
  required bool showSeparators,
}) {
  final theme = context.hufTheme;
  final borderRadius = BorderRadius.circular(theme.borderRadius.value);

  final items = <Widget>[];
  for (var i = 0; i < children.length; i++) {
    items.add(children[i]);
    if (showSeparators && i < children.length - 1) {
      items.add(hufBoxListUnitedSeparator(color: theme.colors.border));
    }
  }

  return DecoratedBox(
    decoration: BoxDecoration(
      color: theme.colors.card,
      borderRadius: borderRadius,
      border: Border.all(color: theme.colors.border),
    ),
    child: ClipRRect(
      borderRadius: borderRadius,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: items,
      ),
    ),
  );
}
