import 'package:flutter/material.dart';
import 'package:hero_ui_flutter/hero_ui_flutter.dart';

import '../example_app_scope.dart';
import 'showcase_shared.dart';

class ScrollShadowShowcasePage extends StatelessWidget {
  const ScrollShadowShowcasePage({super.key});

  static const _lorem =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
      'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
      'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris. '
      'Duis aute irure dolor in reprehenderit in voluptate velit esse '
      'cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat '
      'cupidatat non proident, sunt in culpa qui officia deserunt mollit '
      'anim id est laborum.';

  @override
  Widget build(BuildContext context) {
    final theme = context.hufTheme;
    final cardColor = theme.colors.card;
    final muted = theme.colors.cardMutedForeground;
    final radius = BorderRadius.circular(theme.borderRadius.value);

    return Scaffold(
      appBar: const ShowcaseAppBar(title: 'Scroll Shadow'),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const ShowcaseSectionTitle('Verticale'),
          _ScrollPanel(
            height: 180,
            color: cardColor,
            radius: radius,
            child: HUFScrollShadow.verticalList(
              color: cardColor,
              size: 40,
              padding: const EdgeInsets.all(16),
              children: List.generate(
                6,
                (_) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    _lorem,
                    style: TextStyle(color: muted, height: 1.4),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          const ShowcaseSectionTitle('Orizzontale'),
          _ScrollPanel(
            height: 120,
            color: cardColor,
            radius: radius,
            child: HUFScrollShadow.horizontalList(
              color: cardColor,
              size: 40,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              children: List.generate(
                8,
                (index) => _HorizontalCard(
                  index: index,
                  muted: muted,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          const ShowcaseSectionTitle('Dimensione ombra'),
          const ShowcaseSubsectionTitle('size: 16'),
          _ScrollPanel(
            height: 140,
            color: cardColor,
            radius: radius,
            child: HUFScrollShadow.verticalList(
              color: cardColor,
              size: 16,
              padding: const EdgeInsets.all(16),
              children: [
                Text(_lorem, style: TextStyle(color: muted, height: 1.4)),
                const SizedBox(height: 12),
                Text(_lorem, style: TextStyle(color: muted, height: 1.4)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const ShowcaseSubsectionTitle('size: 64'),
          _ScrollPanel(
            height: 140,
            color: cardColor,
            radius: radius,
            child: HUFScrollShadow.verticalList(
              color: cardColor,
              size: 64,
              padding: const EdgeInsets.all(16),
              children: [
                Text(_lorem, style: TextStyle(color: muted, height: 1.4)),
                const SizedBox(height: 12),
                Text(_lorem, style: TextStyle(color: muted, height: 1.4)),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const ShowcaseSectionTitle('Column / Row'),
          const ShowcaseSubsectionTitle('HUFScrollShadow.column'),
          _ScrollPanel(
            height: 120,
            color: cardColor,
            radius: radius,
            child: HUFScrollShadow.column(
              color: cardColor,
              children: List.generate(
                5,
                (i) => Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text('Riga ${i + 1}', style: TextStyle(color: muted)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const ShowcaseSubsectionTitle('HUFScrollShadow.row'),
          _ScrollPanel(
            height: 72,
            color: cardColor,
            radius: radius,
            child: HUFScrollShadow.row(
              color: cardColor,
              children: List.generate(
                12,
                (i) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: theme.colors.cardSecondary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('Item $i', style: TextStyle(color: muted)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScrollPanel extends StatelessWidget {
  const _ScrollPanel({
    required this.height,
    required this.color,
    required this.radius,
    required this.child,
  });

  final double height;
  final Color color;
  final BorderRadius radius;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: radius,
      child: ColoredBox(
        color: color,
        child: SizedBox(height: height, child: child),
      ),
    );
  }
}

class _HorizontalCard extends StatelessWidget {
  const _HorizontalCard({
    required this.index,
    required this.muted,
  });

  final int index;
  final Color muted;

  static const _swatches = [
    Color(0xFFF472B6),
    Color(0xFF60A5FA),
    Color(0xFF34D399),
    Color(0xFFFBBF24),
    Color(0xFFA78BFA),
    Color(0xFFFB7185),
    Color(0xFF2DD4BF),
    Color(0xFFF97316),
  ];

  @override
  Widget build(BuildContext context) {
    final swatch = _swatches[index % _swatches.length];

    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: swatch,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Bridging the Future',
                  style: TextStyle(
                    color: muted.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Today, 6:30 PM',
                  style: TextStyle(
                    color: muted.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
