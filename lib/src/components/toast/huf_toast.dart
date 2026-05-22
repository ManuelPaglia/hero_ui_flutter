import 'package:flutter/material.dart';

import '../../layout/huf_shrink_wrap_width.dart';
import '../../theme/huf_theme.dart';
import '../alert/huf_alert_color.dart';
import '../alert/huf_alert_style.dart';
import 'huf_toast_style.dart';

/// Azione opzionale a destra in [HUFToast] (es. «Billing», «Undo»).
@immutable
class HUFToastAction {
  const HUFToastAction({
    required this.label,
    this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;
}

/// Toast orizzontale pill del design system Hero UI Flutter.
///
/// Layout: icona (o [leading]) a sinistra, [title] obbligatorio con
/// [description] opzionale al centro, azione pill opzionale a destra.
///
/// Sfondo e descrizione seguono [HUFTheme]. Con [color] diverso da
/// [HUFAlertColor.defaultColor], icona e titolo usano il colore semantico
/// del tema; l'azione pill usa lo stesso accento come sfondo.
///
/// Per mostrarlo in overlay con slide e auto-dismiss usa [hufShowToast].
class HUFToast extends StatelessWidget {
  const HUFToast({
    super.key,
    required this.title,
    this.leading,
    this.icon,
    this.isLoading = false,
    this.description,
    this.action,
    this.trailing,
    this.color = HUFAlertColor.defaultColor,
  });

  /// Titolo principale (obbligatorio).
  final String title;

  /// Widget a sinistra; priorità su [icon] / [isLoading].
  final Widget? leading;

  /// Icona di stato a sinistra.
  final Widget? icon;

  /// Spinner al posto di [icon].
  final bool isLoading;

  /// Testo secondario sotto il titolo.
  final String? description;

  /// Pulsante pill a destra con colori di accento.
  final HUFToastAction? action;

  /// Widget trailing custom; priorità su [action].
  final Widget? trailing;

  /// Colore semantico per icona e titolo ([HUFAlertColor] del tema).
  final HUFAlertColor color;

  @override
  Widget build(BuildContext context) {
    final theme = context.hufTheme;
    final metrics = hufToastMetricsFor(theme.borderRadius);
    final surface = hufToastSurfaceColorsFor(theme.colors);
    final accent = hufToastAccentColorsFor(theme.colors, color);
    final titleColor = color == HUFAlertColor.defaultColor
        ? theme.colors.cardForeground
        : accent.accent;

    final borderRadius = BorderRadius.circular(metrics.borderRadius);

    final card = DecoratedBox(
      decoration: BoxDecoration(
        color: surface.background,
        borderRadius: borderRadius,
        border: Border.all(color: surface.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: theme.isDark ? 0.35 : 0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: metrics.padding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (leading != null || icon != null || isLoading) ...[
              _buildLeading(metrics, accent),
              SizedBox(width: metrics.gap),
            ],
            Flexible(
              fit: FlexFit.loose,
              child: _buildContent(metrics, surface, titleColor),
            ),
            if (_hasTrailing) ...[
              SizedBox(width: metrics.gap),
              _buildTrailing(metrics, accent),
            ],
          ],
        ),
      ),
    );

    return HUFShrinkWrapWidth(
      alignment: AlignmentDirectional.center,
      child: UnconstrainedBox(
        alignment: AlignmentDirectional.center,
        constrainedAxis: Axis.horizontal,
        clipBehavior: Clip.hardEdge,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: metrics.maxWidth),
          child: card,
        ),
      ),
    );
  }

  bool get _hasTrailing => trailing != null || action != null;

  Widget _buildLeading(HUFToastMetrics metrics, HUFAlertAccentColors accent) {
    if (leading != null) return leading!;

    if (isLoading) {
      return SizedBox(
        width: metrics.iconSize,
        height: metrics.iconSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: accent.accent,
        ),
      );
    }

    if (icon == null) return const SizedBox.shrink();

    return IconTheme(
      data: IconThemeData(
        color: accent.accent,
        size: metrics.iconSize,
      ),
      child: icon!,
    );
  }

  Widget _buildContent(
    HUFToastMetrics metrics,
    HUFToastSurfaceColors surface,
    Color titleColor,
  ) {
    final children = <Widget>[
      Text(
        title,
        style: TextStyle(
          fontSize: metrics.titleFontSize,
          fontWeight: FontWeight.w600,
          color: titleColor,
          height: 1.3,
        ),
      ),
    ];

    if (description != null) {
      children.add(SizedBox(height: metrics.contentGap));
      children.add(
        Text(
          description!,
          style: TextStyle(
            fontSize: metrics.descriptionFontSize,
            fontWeight: FontWeight.w400,
            color: surface.descriptionColor,
            height: 1.35,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  Widget _buildTrailing(HUFToastMetrics metrics, HUFAlertAccentColors accent) {
    if (trailing != null) return trailing!;

    if (action == null) return const SizedBox.shrink();

    return _HUFToastActionButton(
      label: action!.label,
      onPressed: action!.onPressed,
      metrics: metrics,
      accent: accent,
    );
  }
}

class _HUFToastActionButton extends StatelessWidget {
  const _HUFToastActionButton({
    required this.label,
    required this.onPressed,
    required this.metrics,
    required this.accent,
  });

  final String label;
  final VoidCallback? onPressed;
  final HUFToastMetrics metrics;
  final HUFAlertAccentColors accent;

  @override
  Widget build(BuildContext context) {
    final theme = context.hufTheme;
    final borderRadius = BorderRadius.circular(metrics.borderRadius);

    return Material(
      color: theme.colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: borderRadius,
        child: Ink(
          decoration: BoxDecoration(
            color: accent.accent,
            borderRadius: borderRadius,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: metrics.actionHorizontalPadding,
            ),
            child: SizedBox(
              height: metrics.actionHeight,
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    color: accent.onAccent,
                    fontSize: metrics.actionFontSize,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
