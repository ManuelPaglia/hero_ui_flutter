import 'package:flutter/material.dart';

import '../../theme/huf_theme.dart';
import '../alert/huf_alert_color.dart';
import '../button/huf_button.dart';
import '../button/huf_button_size.dart';
import '../button/huf_button_variant.dart';
import '../card/huf_card.dart';
import 'huf_alert_dialog_style.dart';

/// Dialog modale del design system Hero UI Flutter.
///
/// Include sempre un [HUFButton.iconOnly] di chiusura in alto a destra.
/// Sfondo e testi seguono [HUFTheme]; l'icona di stato usa il colore semantico
/// [color].
///
/// Le [actions] sono opzionali (massimo 2) e vanno passate esplicitamente
/// (es. [HUFButton]). Senza [isFullWidth] sono allineate a destra; con
/// [HUFButton.isFullWidth] una sola azione occupa tutta la larghezza, due
/// azioni full-width si dividono il 50% ciascuna.
///
/// Per mostrarlo con overlay e fade usa [hufShowAlertDialog].
class HUFAlertDialog extends StatelessWidget {
  const HUFAlertDialog({
    super.key,
    this.leading,
    this.icon,
    this.isLoading = false,
    this.title,
    this.description,
    this.content,
    this.actions = const [],
    required this.onDismiss,
    this.color = HUFAlertColor.defaultColor,
  });

  /// Widget in alto a sinistra; priorità su [icon] / [isLoading].
  final Widget? leading;

  /// Icona di stato (es. warning) nel cerchio semitrasparente.
  final Widget? icon;

  /// Spinner al posto di [icon].
  final bool isLoading;

  final String? title;

  /// Testo descrittivo; per contenuti complessi usare [content].
  final String? description;

  /// Contenuto sotto il titolo (testo formattato, liste, …).
  final Widget? content;

  /// Fino a 2 pulsanti (es. [HUFButton]); nessun valore predefinito.
  final List<Widget> actions;

  /// Invocato dal pulsante di chiusura (e da [hufShowAlertDialog] prima del pop).
  final VoidCallback onDismiss;

  /// Colore semantico dell'icona di stato.
  final HUFAlertColor color;

  @override
  Widget build(BuildContext context) {
    assert(actions.length <= 2);

    final theme = context.hufTheme;
    final metrics = hufAlertDialogMetricsFor(theme.borderRadius);
    final surface = hufAlertDialogSurfaceColorsFor(theme.colors);
    final accent = hufAlertDialogAccentColorsFor(theme.colors, color);
    final borderRadius = BorderRadius.circular(metrics.borderRadius);

    return Material(
      color: theme.colors.transparent,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: metrics.maxWidth),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: surface.background,
            borderRadius: borderRadius,
            border: Border.all(color: surface.borderColor),
          ),
          child: Padding(
            padding: metrics.padding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context, metrics, accent),
                if (title != null ||
                    description != null ||
                    content != null) ...[
                  SizedBox(height: metrics.headerGap),
                  _buildBody(metrics, surface),
                ],
                if (actions.isNotEmpty) ...[
                  SizedBox(height: metrics.headerGap),
                  _buildActions(metrics),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    HUFAlertDialogMetrics metrics,
    HUFAlertDialogAccentColors accent,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (leading != null || icon != null || isLoading)
          _buildStatusIcon(metrics, accent),
        const Spacer(),
        HUFButton.iconOnly(
          icon: const Icon(Icons.close),
          variant: HUFButtonVariant.secondary,
          size: HUFButtonSize.medium,
          onPressed: onDismiss,
        ),
      ],
    );
  }

  Widget _buildStatusIcon(
    HUFAlertDialogMetrics metrics,
    HUFAlertDialogAccentColors accent,
  ) {
    if (leading != null) return leading!;

    final Widget glyph;
    if (isLoading) {
      glyph = SizedBox(
        width: metrics.statusIconGlyphSize,
        height: metrics.statusIconGlyphSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: accent.accent,
        ),
      );
    } else if (icon != null) {
      glyph = IconTheme(
        data: IconThemeData(
          color: accent.accent,
          size: metrics.statusIconGlyphSize,
        ),
        child: icon!,
      );
    } else {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: metrics.statusIconOuterSize,
      height: metrics.statusIconOuterSize,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: accent.iconBackground,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: SizedBox(
            width: metrics.statusIconInnerSize,
            height: metrics.statusIconInnerSize,
            child: Center(child: glyph),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    HUFAlertDialogMetrics metrics,
    HUFAlertDialogSurfaceColors surface,
  ) {
    final children = <Widget>[];

    if (title != null) {
      children.add(
        Text(
          title!,
          style: TextStyle(
            fontSize: metrics.titleFontSize,
            fontWeight: FontWeight.w600,
            color: surface.titleColor,
            height: 1.3,
          ),
        ),
      );
    }

    if (description != null) {
      if (children.isNotEmpty) {
        children.add(SizedBox(height: metrics.contentGap));
      }
      children.add(
        Text(
          description!,
          style: TextStyle(
            fontSize: metrics.descriptionFontSize,
            fontWeight: FontWeight.w400,
            color: surface.descriptionColor,
            height: 1.45,
          ),
        ),
      );
    }

    if (content != null) {
      if (children.isNotEmpty) {
        children.add(SizedBox(height: metrics.contentGap));
      }
      children.add(
        DefaultTextStyle(
          style: TextStyle(
            fontSize: metrics.descriptionFontSize,
            fontWeight: FontWeight.w400,
            color: surface.descriptionColor,
            height: 1.45,
          ),
          child: content!,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  Widget _buildActions(HUFAlertDialogMetrics metrics) {
    if (actions.isEmpty) return const SizedBox.shrink();

    if (actions.length == 1) {
      final action = actions.first;
      if (_isFullWidth(action)) {
        return Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: double.infinity,
            child: hufCardExpandAction(action),
          ),
        );
      }
      return Align(
        alignment: Alignment.centerRight,
        child: action,
      );
    }

    final firstFull = _isFullWidth(actions[0]);
    final secondFull = _isFullWidth(actions[1]);

    if (firstFull && secondFull) {
      return Row(
        children: [
          Expanded(child: hufCardExpandAction(actions[0])),
          SizedBox(width: metrics.actionsGap),
          Expanded(child: hufCardExpandAction(actions[1])),
        ],
      );
    }

    if (firstFull || secondFull) {
      final fullAction = firstFull ? actions[0] : actions[1];
      return SizedBox(
        width: double.infinity,
        child: hufCardExpandAction(fullAction),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: [
        actions[0],
        SizedBox(width: metrics.actionsGap),
        actions[1],
      ],
    );
  }

  bool _isFullWidth(Widget widget) {
    return widget is HUFButton && !widget.isIconOnly && widget.isFullWidth;
  }
}
