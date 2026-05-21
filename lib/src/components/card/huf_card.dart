import 'package:flutter/material.dart';

import '../../theme/huf_theme.dart';
import '../button/huf_button.dart';
import 'huf_card_radius_size.dart';
import 'huf_card_style.dart';

/// Espande un'azione in [HUFCard] a tutta la larghezza disponibile.
Widget hufCardExpandAction(Widget action) {
  if (action is HUFButton && !action.isIconOnly && !action.isFullWidth) {
    return HUFButton(
      key: action.key,
      label: action.label,
      onPressed: action.onPressed,
      variant: action.variant,
      size: action.size,
      isLoading: action.isLoading,
      isFullWidth: true,
      icon: action.icon,
      glowSize: action.glowSize,
      popover: action.popover,
    );
  }
  return action;
}

/// Card composable del design system Hero UI Flutter.
///
/// Usa lo stesso token [HUFBorderRadius.value] del tema condiviso da bottoni e altri
/// componenti. Il [padding] interno e le spaziature tra sezioni sono fissi
/// ([kHufCardPadding], [kHufCardSectionGap]).
///
/// **Verticale** (dall'alto): immagine → titolo → sottotitolo → contenuto → azioni.
///
/// **Orizzontale**: immagine a sinistra; titolo, sottotitolo, contenuto e azioni
/// impilati nella colonna a destra.
class HUFCard extends StatelessWidget {
  const HUFCard({
    super.key,
    this.style = HUFCardStyle.card,
    this.orientation = HUFCardOrientation.vertical,
    this.radiusSize = HUFCardRadiusSize.medium,
    this.image,
    this.imageAspectRatio,
    this.title,
    this.subtitle,
    this.content,
    this.actions = const [],
    this.actionsLayout = HUFCardActionsLayout.row,
    this.onTap,
  });

  final HUFCardStyle style;
  final HUFCardOrientation orientation;
  final HUFCardRadiusSize radiusSize;

  /// Widget immagine (es. [Image], [Image.network]). Usa lo stesso token radius del tema.
  final Widget? image;

  /// Override dell'aspect ratio immagine in layout verticale.
  final double? imageAspectRatio;

  final String? title;
  final String? subtitle;
  final Widget? content;

  /// Una o più azioni (es. [HUFButton]).
  final List<Widget> actions;

  /// Disposizione delle [actions] quando ce n'è più di una.
  final HUFCardActionsLayout actionsLayout;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.hufTheme;
    final metrics = hufCardMetricsFor(radiusSize, theme.borderRadius);
    final colors = hufCardColorsFor(theme.colors, style);

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;

        final body = orientation == HUFCardOrientation.vertical
            ? _buildVertical(metrics, colors)
            : _buildHorizontal(metrics, colors);

        final outerRadius = hufCardEffectiveOuterRadius(
          borderRadius: metrics.borderRadius,
          width: cardWidth,
        );
        final borderRadius = BorderRadius.circular(outerRadius);

        final card = DecoratedBox(
          decoration: BoxDecoration(
            color: colors.background,
            borderRadius: borderRadius,
            border: style == HUFCardStyle.transparent
                ? null
                : Border.all(color: theme.colors.border),
          ),
          child: Padding(
            padding: metrics.padding,
            child: body,
          ),
        );

        if (onTap == null) return card;

        return Material(
          color: theme.colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: borderRadius,
            child: card,
          ),
        );
      },
    );
  }

  Widget _buildVertical(
    HUFCardMetrics metrics,
    HUFCardColors colors,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (image != null) ...[
          _buildImage(metrics),
          SizedBox(height: metrics.sectionGap),
        ],
        ..._buildTextAndContent(metrics, colors),
        if (actions.isNotEmpty) ...[
          SizedBox(height: metrics.sectionGap),
          _buildActions(metrics),
        ],
      ],
    );
  }

  Widget _buildHorizontal(
    HUFCardMetrics metrics,
    HUFCardColors colors,
  ) {
    final textColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        ..._buildTextAndContent(metrics, colors),
        if (actions.isNotEmpty) ...[
          SizedBox(height: metrics.sectionGap),
          _buildActions(metrics),
        ],
      ],
    );

    if (image == null) return textColumn;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: metrics.horizontalImageExtent,
          child: _buildImage(metrics),
        ),
        SizedBox(width: metrics.sectionGap),
        Expanded(child: textColumn),
      ],
    );
  }

  List<Widget> _buildTextAndContent(HUFCardMetrics metrics, HUFCardColors colors) {
    final children = <Widget>[];

    if (title != null) {
      children.add(
        Text(
          title!,
          style: TextStyle(
            fontSize: metrics.titleFontSize,
            fontWeight: FontWeight.w600,
            color: colors.titleColor,
            height: 1.3,
          ),
        ),
      );
    }

    if (subtitle != null) {
      if (children.isNotEmpty) {
        children.add(SizedBox(height: metrics.titleSubtitleGap));
      }
      children.add(
        Text(
          subtitle!,
          style: TextStyle(
            fontSize: metrics.subtitleFontSize,
            fontWeight: FontWeight.w400,
            color: colors.subtitleColor,
            height: 1.35,
          ),
        ),
      );
    }

    if (content != null) {
      if (children.isNotEmpty) {
        children.add(SizedBox(height: metrics.sectionGap));
      }
      children.add(content!);
    }

    return children;
  }

  Widget _buildImage(
    HUFCardMetrics metrics,
  ) {
    final aspectRatio = imageAspectRatio ?? metrics.imageAspectRatio;

    final imageChild = LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        final innerRadius = hufCardEffectiveInnerRadius(
          borderRadius: metrics.borderRadius,
          width: width,
          height: height,
        );

        return ClipRRect(
          borderRadius: BorderRadius.circular(innerRadius),
          child: image!,
        );
      },
    );

    if (orientation == HUFCardOrientation.vertical) {
      return AspectRatio(
        aspectRatio: aspectRatio,
        child: imageChild,
      );
    }

    return AspectRatio(
      aspectRatio: 1,
      child: imageChild,
    );
  }

  Widget _buildActions(HUFCardMetrics metrics) {
    if (actions.isEmpty) return const SizedBox.shrink();

    if (actions.length == 1) {
      return Row(
        children: [
          Expanded(child: hufCardExpandAction(actions.first)),
        ],
      );
    }

    final gap = metrics.sectionGap * 0.5;

    return switch (actionsLayout) {
      HUFCardActionsLayout.stacked => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < actions.length; i++) ...[
              if (i > 0) SizedBox(height: gap),
              hufCardExpandAction(actions[i]),
            ],
          ],
        ),
      HUFCardActionsLayout.row => Row(
          children: [
            for (var i = 0; i < actions.length; i++) ...[
              if (i > 0) SizedBox(width: gap),
              Expanded(child: hufCardExpandAction(actions[i])),
            ],
          ],
        ),
    };
  }
}
