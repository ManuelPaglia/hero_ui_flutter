import 'package:flutter/material.dart';

import '../../layout/huf_shrink_wrap_width.dart';
import '../../theme/huf_theme.dart';
import '../button/huf_button.dart';
import '../button/huf_button_size.dart';
import '../button/huf_button_variant.dart';
import 'huf_alert_color.dart';
import 'huf_alert_size.dart';
import 'huf_alert_style.dart';

/// Azione opzionale a destra in [HUFAlert] (es. «Refresh», «Retry»).
@immutable
class HUFAlertAction {
  const HUFAlertAction({
    required this.label,
    this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;
}

/// Alert orizzontale del design system Hero UI Flutter.
///
/// Layout: icona (o [leading]) a sinistra, titolo e descrizione al centro,
/// azione o pulsante di chiusura a destra.
///
/// Sfondo e testo descrittivo seguono il tema principale ([HUFThemeColors.card]
/// e [HUFThemeColors.cardMutedForeground]). Icona, titolo e azione usano il
/// colore semantico [color] dal tema.
///
/// Se [action] è null e [showCloseButton] è `true`, viene mostrato un
/// [HUFButton.iconOnly] in stile soft (secondary) che invoca [onDismiss].
class HUFAlert extends StatelessWidget {
  const HUFAlert({
    super.key,
    this.leading,
    this.icon,
    this.isLoading = false,
    this.title,
    this.description,
    this.content,
    this.action,
    this.trailing,
    this.showCloseButton = false,
    this.onDismiss,
    this.color = HUFAlertColor.defaultColor,
    this.size = HUFAlertSize.medium,
  });

  /// Widget a sinistra; ha priorità su [icon] / [isLoading].
  final Widget? leading;

  /// Icona di stato a sinistra.
  final Widget? icon;

  /// Mostra un indicatore di caricamento al posto di [icon].
  final bool isLoading;

  final String? title;

  /// Testo descrittivo; per contenuti complessi usare [content].
  final String? description;

  /// Contenuto sotto il titolo (liste, widget custom).
  final Widget? content;

  /// Pulsante pill a destra con colori di accento.
  final HUFAlertAction? action;

  /// Widget trailing custom; ha priorità su [action] e [showCloseButton].
  final Widget? trailing;

  /// Se `true` e [action] e [trailing] sono null, mostra il pulsante di chiusura.
  final bool showCloseButton;

  /// Invocato dal pulsante di chiusura predefinito.
  final VoidCallback? onDismiss;

  final HUFAlertColor color;
  final HUFAlertSize size;

  @override
  Widget build(BuildContext context) {
    final theme = context.hufTheme;
    final metrics = hufAlertMetricsFor(size, theme.borderRadius);
    final surface = hufAlertSurfaceColorsFor(theme.colors);
    final accent = hufAlertAccentColorsFor(theme.colors, color);

    final borderRadius = BorderRadius.circular(metrics.borderRadius);

    final card = DecoratedBox(
      decoration: BoxDecoration(
        color: surface.background,
        borderRadius: borderRadius,
        border: Border.all(color: theme.colors.border),
      ),
      child: Padding(
        padding: metrics.padding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (leading != null || icon != null || isLoading) ...[
              _buildLeading(metrics, accent),
              SizedBox(width: metrics.gap),
            ],
            Flexible(
              fit: FlexFit.loose,
              child: _buildContent(metrics, surface, accent),
            ),
            if (_hasTrailing) ...[
              SizedBox(width: metrics.gap),
              _buildTrailing(context, metrics, accent, theme.colors),
            ],
          ],
        ),
      ),
    );

    return HUFShrinkWrapWidth(
      alignment: AlignmentDirectional.centerStart,
      child: UnconstrainedBox(
        alignment: AlignmentDirectional.centerStart,
        constrainedAxis: Axis.horizontal,
        clipBehavior: Clip.hardEdge,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: metrics.maxWidth),
          child: card,
        ),
      ),
    );
  }

  bool get _hasTrailing =>
      trailing != null ||
      action != null ||
      (showCloseButton && trailing == null && action == null);

  Widget _buildLeading(HUFAlertMetrics metrics, HUFAlertAccentColors accent) {
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
    HUFAlertMetrics metrics,
    HUFAlertSurfaceColors surface,
    HUFAlertAccentColors accent,
  ) {
    final children = <Widget>[];

    if (title != null) {
      children.add(
        Text(
          title!,
          style: TextStyle(
            fontSize: metrics.titleFontSize,
            fontWeight: FontWeight.w600,
            color: accent.accent,
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
            height: 1.4,
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
            height: 1.4,
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

  Widget _buildTrailing(
    BuildContext context,
    HUFAlertMetrics metrics,
    HUFAlertAccentColors accent,
    HUFThemeColors palette,
  ) {
    if (trailing != null) return trailing!;

    if (action != null) {
      return _HUFAlertActionButton(
        label: action!.label,
        onPressed: action!.onPressed,
        metrics: metrics,
        accent: accent,
      );
    }

    if (!showCloseButton) return const SizedBox.shrink();

    final buttonSize = switch (size) {
      HUFAlertSize.small => HUFButtonSize.small,
      HUFAlertSize.medium => HUFButtonSize.medium,
      HUFAlertSize.large => HUFButtonSize.large,
    };

    return HUFButton.iconOnly(
      icon: const Icon(Icons.close),
      variant: HUFButtonVariant.secondary,
      size: buttonSize,
      onPressed: onDismiss,
    );
  }
}

class _HUFAlertActionButton extends StatelessWidget {
  const _HUFAlertActionButton({
    required this.label,
    required this.onPressed,
    required this.metrics,
    required this.accent,
  });

  final String label;
  final VoidCallback? onPressed;
  final HUFAlertMetrics metrics;
  final HUFAlertAccentColors accent;

  @override
  Widget build(BuildContext context) {
    final theme = context.hufTheme;
    final borderRadius = BorderRadius.circular(metrics.actionBorderRadius);

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
