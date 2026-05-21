import 'package:flutter/material.dart';
import 'package:hero_ui_flutter/hero_ui_flutter.dart';

import '../example_app_scope.dart';
import 'showcase_shared.dart';

class PopoverShowcasePage extends StatelessWidget {
  const PopoverShowcasePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ShowcaseAppBar(title: 'Popover'),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const ShowcaseSubsectionTitle('Base'),
          Center(
            child: HUFButton(
              label: 'Click me',
              variant: HUFButtonVariant.primary,
              size: HUFButtonSize.medium,
              popover: const HUFButtonPopover(
                child: HUFPopoverContent(
                  title: 'Popover Title',
                  description:
                      'This is the popover content. You can put any content here.',
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          const ShowcaseSubsectionTitle('Con freccia'),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              HUFButton(
                label: 'With Arrow',
                variant: HUFButtonVariant.outlined,
                size: HUFButtonSize.medium,
                popover: const HUFButtonPopover(
                  showArrow: true,
                  child: HUFPopoverContent(
                    title: 'Popover with Arrow',
                    description:
                        'The arrow shows which element triggered the popover.',
                  ),
                ),
              ),
              HUFButton.iconOnly(
                icon: const Icon(Icons.more_horiz),
                variant: HUFButtonVariant.secondary,
                size: HUFButtonSize.medium,
                popover: const HUFButtonPopover(
                  showArrow: true,
                  child: HUFPopoverContent(
                    title: 'Actions',
                    description: 'Menu contestuale con freccia.',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const ShowcaseSubsectionTitle('Posizionamento'),
          const Text(
            'Clicca i bottoni per aprire il popover nella direzione indicata. '
            'Con placement bottom/top, se non c\'è spazio il popover si capovolge '
            'automaticamente.',
            style: TextStyle(height: 1.4),
          ),
          const SizedBox(height: 16),
          Center(
            child: SizedBox(
              width: 320,
              height: 240,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  const Text('Click buttons'),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: _PlacementPopover(
                        placement: HUFPopoverPlacement.top,
                        label: 'Top',
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: _PlacementPopover(
                        placement: HUFPopoverPlacement.bottom,
                        label: 'Bottom',
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: _PlacementPopover(
                        placement: HUFPopoverPlacement.start,
                        label: 'Left',
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: _PlacementPopover(
                        placement: HUFPopoverPlacement.end,
                        label: 'Right',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          const ShowcaseSubsectionTitle('Profilo (contenuto custom)'),
          Center(
            child: HUFButton(
              label: 'Sarah Johnson',
              icon: HUFAvatar(
                size: HUFAvatarSize.small,
                initials: 'SJ',
                color: HUFAvatarColor.accent,
              ),
              variant: HUFButtonVariant.ghost,
              popover: const HUFButtonPopover(
                showArrow: true,
                child: _ProfilePopoverContent(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlacementPopover extends StatelessWidget {
  const _PlacementPopover({
    required this.placement,
    required this.label,
  });

  final HUFPopoverPlacement placement;
  final String label;

  @override
  Widget build(BuildContext context) {
    return HUFButton(
      label: label,
      variant: HUFButtonVariant.secondary,
      size: HUFButtonSize.small,
      popover: HUFButtonPopover(
        placement: placement,
        showArrow: true,
        child: HUFPopoverContent(
          title: '$label placement',
        ),
      ),
    );
  }
}

class _ProfilePopoverContent extends StatelessWidget {
  const _ProfilePopoverContent();

  @override
  Widget build(BuildContext context) {
    final theme = context.hufTheme;
    final colors = hufPopoverColorsFor(theme.colors);

    return SizedBox(
      width: 280,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HUFAvatar(
                size: HUFAvatarSize.medium,
                initials: 'SJ',
                color: HUFAvatarColor.accent,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sarah Johnson',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: colors.titleColor,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    Text(
                      '@sarahj',
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.descriptionColor,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
              HUFButton(
                label: 'Follow',
                variant: HUFButtonVariant.primary,
                size: HUFButtonSize.small,
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Product designer and creative director. Building beautiful '
            'experiences that matter.',
            style: TextStyle(
              fontSize: 13,
              color: colors.descriptionColor,
              height: 1.4,
              decoration: TextDecoration.none,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _StatItem(value: '892', label: 'Following', colors: colors),
              const SizedBox(width: 16),
              _StatItem(value: '12.5K', label: 'Followers', colors: colors),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.value,
    required this.label,
    required this.colors,
  });

  final String value;
  final String label;
  final HUFPopoverColors colors;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 13,
          color: colors.descriptionColor,
          decoration: TextDecoration.none,
        ),
        children: [
          TextSpan(
            text: value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: colors.titleColor,
              decoration: TextDecoration.none,
            ),
          ),
          TextSpan(
            text: ' $label',
            style: const TextStyle(decoration: TextDecoration.none),
          ),
        ],
      ),
    );
  }
}
