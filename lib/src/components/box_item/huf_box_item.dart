import 'package:flutter/material.dart';

import '../../theme/huf_theme.dart';
import '../box_list/huf_box_list_layout.dart';
import '../box_list/huf_box_list_layout_utils.dart';
import '../box_list/huf_box_list_scope.dart';
import 'huf_box_item_size.dart';
import 'huf_box_item_style.dart';

/// Riga con icona, titolo, sottotitolo e azione personalizzabile a destra.
///
/// Usa [HUFBoxList] come contenitore per layout `separated` o `united`.
/// Le control card (checkbox, radio, switch) sono costruite sopra questo widget.
class HUFBoxItem extends StatelessWidget {
  const HUFBoxItem({
    super.key,
    required this.title,
    required this.action,
    this.subtitle,
    this.icon,
    this.onTap,
    this.enabled = true,
    this.highlighted = false,
    this.size = HUFBoxItemSize.medium,
    this.colors,
    this.activeColor,
    this.layout,
    this.isFirst,
    this.isLast,
    this.semanticsLabel,
    this.semanticsChecked,
    this.semanticsToggled,
    this.semanticsButton = true,
  });

  final String title;
  final String? subtitle;
  final Widget? icon;

  /// Widget trailing (switch, checkbox, icona, bottone, ecc.).
  final Widget action;

  /// Tap sull'intera riga. `null` disabilita l'interazione.
  final VoidCallback? onTap;

  final bool enabled;
  final bool highlighted;
  final HUFBoxItemSize size;

  /// Colori espliciti; se null derivati da tema e [highlighted].
  final HUFBoxItemColors? colors;

  /// Usato con [colors] null per calcolare sfondo e icona leading.
  final Color? activeColor;

  /// Override del layout; se null usa [HUFBoxListScope] o `separated`.
  final HUFBoxListLayout? layout;

  /// Override posizione in lista; se null usa [HUFBoxListScope].
  final bool? isFirst;
  final bool? isLast;

  final String? semanticsLabel;
  final bool? semanticsChecked;
  final bool? semanticsToggled;
  final bool semanticsButton;

  bool get _isDisabled => !enabled || onTap == null;

  @override
  Widget build(BuildContext context) {
    final theme = context.hufTheme;
    final scope = HUFBoxListScope.maybeOf(context);
    final resolvedLayout = layout ?? scope?.layout ?? HUFBoxListLayout.separated;
    final resolvedIsFirst = isFirst ?? scope?.isFirst ?? true;
    final resolvedIsLast = isLast ?? scope?.isLast ?? true;

    final metrics = hufBoxItemMetricsFor(size, theme.borderRadius);
    final resolvedColors = colors ??
        hufBoxItemColorsFor(
          theme.colors,
          highlighted,
          _isDisabled,
          activeColor: activeColor,
        );

    final itemBorderRadius = hufBoxItemBorderRadius(
      layout: resolvedLayout,
      radius: metrics.borderRadius,
      isFirst: resolvedIsFirst,
      isLast: resolvedIsLast,
    );
    final background = highlighted
        ? resolvedColors.activeBackground
        : resolvedColors.inactiveBackground;
    final splashColor = resolvedColors.leadingIconColor.withValues(alpha: 0.12);
    final highlightColor =
        resolvedColors.leadingIconColor.withValues(alpha: 0.08);
    final label = semanticsLabel ??
        (subtitle == null ? title : '$title. $subtitle');

    return Semantics(
      checked: semanticsChecked,
      toggled: semanticsToggled,
      enabled: !_isDisabled,
      button: semanticsButton,
      label: label,
      child: Material(
        color: theme.colors.transparent,
        child: InkWell(
          onTap: _isDisabled ? null : onTap,
          borderRadius: itemBorderRadius,
          splashColor: splashColor,
          highlightColor: highlightColor,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            width: double.infinity,
            padding: metrics.padding,
            decoration: BoxDecoration(
              color: background,
              borderRadius: itemBorderRadius,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  IconTheme(
                    data: IconThemeData(
                      color: resolvedColors.leadingIconColor,
                      size: metrics.leadingIconSize,
                    ),
                    child: icon!,
                  ),
                  SizedBox(width: metrics.iconGap),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: metrics.titleFontSize,
                          fontWeight: FontWeight.w600,
                          color: resolvedColors.titleColor,
                          height: 1.3,
                        ),
                      ),
                      if (subtitle != null) ...[
                        SizedBox(height: metrics.titleSubtitleGap),
                        Text(
                          subtitle!,
                          style: TextStyle(
                            fontSize: metrics.subtitleFontSize,
                            fontWeight: FontWeight.w400,
                            color: resolvedColors.subtitleColor,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(width: metrics.actionGap),
                action,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
