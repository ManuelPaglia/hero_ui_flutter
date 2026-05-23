import 'package:flutter/material.dart';

import '../box_list/huf_box_list_layout.dart';
import '../box_list/huf_box_list_layout_utils.dart' as box_list;

export '../box_list/huf_box_list_layout_utils.dart'
    show kHufBoxListSeparatorInset;

/// Alias per compatibilità.
const double kHufControlCardSeparatorInset = box_list.kHufBoxListSeparatorInset;

BorderRadius hufControlCardItemBorderRadius({
  required HUFBoxListLayout layout,
  required double radius,
  required bool isFirst,
  required bool isLast,
}) =>
    box_list.hufBoxItemBorderRadius(
      layout: layout,
      radius: radius,
      isFirst: isFirst,
      isLast: isLast,
    );

Widget hufControlCardUnitedGroup({
  required BuildContext context,
  required List<Widget> children,
  required bool showSeparators,
}) =>
    box_list.hufBoxListUnitedGroup(
      context: context,
      children: children,
      showSeparators: showSeparators,
    );

Widget hufControlCardUnitedSeparator({required Color color}) =>
    box_list.hufBoxListUnitedSeparator(color: color);
