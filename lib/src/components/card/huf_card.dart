import 'package:flutter/material.dart';

import '../../theme/huf_theme.dart';
import 'huf_card_radius_size.dart';
import 'huf_card_style.dart';

/// Card composable del design system Hero UI Flutter.
///
/// La scala visiva è guidata dal [radiusSize] (token sm / md / lg del tema);
/// il [padding] interno e le spaziature tra sezioni sono fissi ([kHufCardPadding],
/// [kHufCardSectionGap]). Con preset tema **pill**, card e immagine usano il radius
/// di [HUFBorderRadius.rounded] (i pulsanti/chip del tema restano pill).
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

  /// Widget immagine (es. [Image], [Image.network]). Radius interno concentrico con la card.
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
        final inset = metrics.padding.top;

        final body = orientation == HUFCardOrientation.vertical
            ? _buildVertical(
                metrics,
                colors,
                cardWidth: cardWidth,
                inset: inset,
              )
            : _buildHorizontal(
                metrics,
                colors,
                cardWidth: cardWidth,
                inset: inset,
              );

        final outerRadius = hufCardEffectiveOuterRadius(
          tokenInnerRadius: metrics.innerBorderRadius,
          inset: inset,
          width: cardWidth,
        );
        final borderRadius = BorderRadius.circular(outerRadius);

        final card = DecoratedBox(
          decoration: BoxDecoration(
            color: colors.background,
            borderRadius: borderRadius,
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
    HUFCardColors colors, {
    required double cardWidth,
    required double inset,
  }) {
    final outerRadius = hufCardEffectiveOuterRadius(
      tokenInnerRadius: metrics.innerBorderRadius,
      inset: inset,
      width: cardWidth,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (image != null) ...[
          _buildImage(
            metrics,
            outerRadius: outerRadius,
            inset: inset,
          ),
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
    HUFCardColors colors, {
    required double cardWidth,
    required double inset,
  }) {
    final outerRadius = hufCardEffectiveOuterRadius(
      tokenInnerRadius: metrics.innerBorderRadius,
      inset: inset,
      width: cardWidth,
    );

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
          child: _buildImage(
            metrics,
            outerRadius: outerRadius,
            inset: inset,
          ),
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
    HUFCardMetrics metrics, {
    required double outerRadius,
    required double inset,
  }) {
    final aspectRatio = imageAspectRatio ?? metrics.imageAspectRatio;

    final imageChild = LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        final borderRadius = _imageBorderRadius(
          metrics: metrics,
          outerRadius: outerRadius,
          inset: inset,
          width: width,
          height: height,
        );

        return ClipRRect(
          borderRadius: borderRadius,
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

  BorderRadius _imageBorderRadius({
    required HUFCardMetrics metrics,
    required double outerRadius,
    required double inset,
    required double width,
    required double height,
  }) {
    final innerRadius = hufCardEffectiveInnerRadius(
      tokenInnerRadius: metrics.innerBorderRadius,
      outerRadius: outerRadius,
      inset: inset,
      width: width,
      height: height,
    );
    return BorderRadius.circular(innerRadius);
  }

  Widget _buildActions(HUFCardMetrics metrics) {
    if (actions.length == 1) return actions.first;

    return switch (actionsLayout) {
      HUFCardActionsLayout.stacked => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < actions.length; i++) ...[
              if (i > 0) SizedBox(height: metrics.sectionGap * 0.5),
              actions[i],
            ],
          ],
        ),
      HUFCardActionsLayout.row => Wrap(
          spacing: metrics.sectionGap * 0.5,
          runSpacing: metrics.sectionGap * 0.5,
          children: actions,
        ),
    };
  }
}
