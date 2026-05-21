import 'package:flutter/material.dart';
import 'package:hero_ui_flutter/hero_ui_flutter.dart';

import '../example_app_scope.dart';
import 'showcase_shared.dart';

class SeparatorsShowcasePage extends StatelessWidget {
  const SeparatorsShowcasePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.hufTheme;
    final textStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: theme.colors.cardForeground,
        );
    final linkStyle = textStyle?.copyWith(fontWeight: FontWeight.w500);

    return Scaffold(
      appBar: const ShowcaseAppBar(title: 'Separator'),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const ShowcaseSectionTitle('Base'),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'HeroUI v3 Components',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colors.cardForeground,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Beautiful, fast and modern React UI library.',
                  style: textStyle,
                ),
                const SizedBox(height: 16),
                const HUFSeparator(),
                const SizedBox(height: 16),
                _NavLinksRow(textStyle: linkStyle),
              ],
            ),
          ),
          const ShowcaseSectionTitle('Verticale'),
          SizedBox(
            height: 20,
            child: Row(
              children: [
                Text('Blog', style: linkStyle),
                const SizedBox(width: 16),
                const HUFSeparator(orientation: HUFSeparatorOrientation.vertical),
                const SizedBox(width: 16),
                Text('Docs', style: linkStyle),
                const SizedBox(width: 16),
                const HUFSeparator(orientation: HUFSeparatorOrientation.vertical),
                const SizedBox(width: 16),
                Text('Source', style: linkStyle),
              ],
            ),
          ),
          const ShowcaseSectionTitle('Varianti'),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              children: [
                for (final variant in HUFSeparatorVariant.values) ...[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _variantLabel(variant),
                      style: textStyle,
                    ),
                  ),
                  const SizedBox(height: 8),
                  HUFSeparator(variant: variant),
                  if (variant != HUFSeparatorVariant.tertiary)
                    const SizedBox(height: 20),
                ],
              ],
            ),
          ),
          const ShowcaseSectionTitle('Su superfici'),
          for (final style in [
            HUFCardStyle.card,
            HUFCardStyle.cardSecondary,
            HUFCardStyle.cardTertiary,
            HUFCardStyle.transparent,
          ]) ...[
            ShowcaseSubsectionTitle(_surfaceLabel(style)),
            HUFCard(
              style: style,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Surface content',
                    style: textStyle,
                  ),
                  const SizedBox(height: 12),
                  const HUFSeparator(),
                  const SizedBox(height: 12),
                  Text(
                    'Surface content',
                    style: textStyle,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _NavLinksRow extends StatelessWidget {
  const _NavLinksRow({required this.textStyle});

  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: Row(
        children: [
          Text('Blog', style: textStyle),
          const SizedBox(width: 16),
          const HUFSeparator(orientation: HUFSeparatorOrientation.vertical),
          const SizedBox(width: 16),
          Text('Docs', style: textStyle),
          const SizedBox(width: 16),
          const HUFSeparator(orientation: HUFSeparatorOrientation.vertical),
          const SizedBox(width: 16),
          Text('Source', style: textStyle),
        ],
      ),
    );
  }
}

String _variantLabel(HUFSeparatorVariant variant) {
  return switch (variant) {
    HUFSeparatorVariant.defaultVariant => 'Default',
    HUFSeparatorVariant.secondary => 'Secondary',
    HUFSeparatorVariant.tertiary => 'Tertiary',
  };
}

String _surfaceLabel(HUFCardStyle style) {
  return switch (style) {
    HUFCardStyle.card => 'Default surface',
    HUFCardStyle.cardSecondary => 'Secondary surface',
    HUFCardStyle.cardTertiary => 'Tertiary surface',
    HUFCardStyle.transparent => 'Transparent surface',
  };
}
