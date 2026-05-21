import 'package:flutter/material.dart';
import 'package:hero_ui_flutter/hero_ui_flutter.dart';

import '../example_app_scope.dart';
import 'showcase_shared.dart';

class AvatarsShowcasePage extends StatelessWidget {
  const AvatarsShowcasePage({super.key});

  static const _images = [
    NetworkImage(
      'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=128&h=128&fit=crop',
    ),
    NetworkImage(
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=128&h=128&fit=crop',
    ),
    NetworkImage(
      'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=128&h=128&fit=crop',
    ),
    NetworkImage(
      'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=128&h=128&fit=crop',
    ),
    NetworkImage(
      'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=128&h=128&fit=crop',
    ),
  ];

  static const _initials = ['AG', 'MK', 'LP', 'RS', 'TN'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ShowcaseAppBar(title: 'Avatar'),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const ShowcaseSectionTitle('Singolo avatar'),
          const ShowcaseSubsectionTitle('Iniziali · varianti'),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              for (final variant in HUFAvatarVariant.values)
                HUFAvatar(
                  initials: 'AG',
                  variant: variant,
                ),
            ],
          ),
          const SizedBox(height: 16),
          const ShowcaseSubsectionTitle('Icona · varianti'),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              for (final variant in HUFAvatarVariant.values)
                HUFAvatar(
                  icon: const Icon(Icons.person_outline),
                  variant: variant,
                ),
            ],
          ),
          const SizedBox(height: 16),
          const ShowcaseSubsectionTitle('Immagine'),
          const HUFAvatar(
            image: NetworkImage(
              'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=128&h=128&fit=crop',
            ),
            semanticsLabel: 'Foto profilo',
          ),
          const SizedBox(height: 24),
          const ShowcaseSectionTitle('Dimensioni'),
          for (final size in HUFAvatarSize.values) ...[
            ShowcaseSubsectionTitle(showcaseAvatarSizeLabel(size)),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                HUFAvatar(initials: 'AG', size: size),
                HUFAvatar(
                  icon: const Icon(Icons.person_outline),
                  size: size,
                ),
                HUFAvatar(image: _images.first, size: size),
              ],
            ),
            const SizedBox(height: 16),
          ],
          const ShowcaseSectionTitle('Colori'),
          for (final color in HUFAvatarColor.values) ...[
            ShowcaseSubsectionTitle(showcaseAvatarColorLabel(color)),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                for (final variant in HUFAvatarVariant.values) ...[
                  HUFAvatar(
                    initials: 'AG',
                    color: color,
                    variant: variant,
                  ),
                  HUFAvatar(
                    icon: const Icon(Icons.person_outline),
                    color: color,
                    variant: variant,
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
          ],
          const ShowcaseSectionTitle('Colori personalizzati'),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: const [
              HUFAvatar(
                initials: 'AG',
                backgroundColor: Color(0xFF1E3A5F),
                foregroundColor: Color(0xFF60A5FA),
              ),
              HUFAvatar(
                icon: Icon(Icons.person_outline),
                backgroundColor: Color(0xFF14532D),
                foregroundColor: Color(0xFF4ADE80),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const ShowcaseSectionTitle('Ring'),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              HUFAvatar(
                initials: 'AG',
                ringWidth: 2,
              ),
              HUFAvatar(
                image: _images.first,
                ringWidth: 2,
              ),
              HUFAvatar(
                initials: 'AG',
                ringWidth: 4,
                ringColor: Colors.blue,
              ),
            ],
          ),
          const SizedBox(height: 24),
          const ShowcaseSectionTitle('Badge'),
          const ShowcaseSubsectionTitle('Contenuto'),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            children: [
              HUFAvatar(
                initials: 'AG',
                badge: const HUFAvatarBadge.count(5),
              ),
              HUFAvatar(
                initials: 'AG',
                badge: HUFAvatarBadge.newLabel,
              ),
              HUFAvatar(
                initials: 'AG',
                badge: HUFAvatarBadge.oldLabel,
              ),
              const HUFAvatar(
                initials: 'AG',
                badge: HUFAvatarBadge.dot(),
              ),
              HUFAvatar(
                initials: 'AG',
                badge: HUFAvatarBadge.icon(
                  Icon(Icons.check_rounded),
                  color: HUFAvatarBadgeColor.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const ShowcaseSubsectionTitle('Dimensioni badge'),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (final avatarSize in HUFAvatarSize.values)
                HUFAvatar(
                  initials: 'AG',
                  size: avatarSize,
                  badge: const HUFAvatarBadge.dot(),
                ),
            ],
          ),
          const SizedBox(height: 16),
          const ShowcaseSubsectionTitle('Colori badge'),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            children: [
              for (final badgeColor in HUFAvatarBadgeColor.values)
                HUFAvatar(
                  initials: 'AG',
                  badge: HUFAvatarBadge.dot(color: badgeColor),
                ),
            ],
          ),
          const SizedBox(height: 16),
          const ShowcaseSubsectionTitle('Posizione'),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            children: [
              for (final placement in HUFAvatarBadgePlacement.values)
                HUFAvatar(
                  initials: 'AG',
                  badge: HUFAvatarBadge.dot(placement: placement),
                ),
            ],
          ),
          const SizedBox(height: 16),
          const ShowcaseSubsectionTitle('Badge su immagine'),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            children: [
              HUFAvatar(
                image: _images.first,
                badge: const HUFAvatarBadge.count(5),
              ),
              HUFAvatar(
                image: _images[1],
                badge: HUFAvatarBadge.newLabel,
              ),
              HUFAvatar(
                image: _images[2],
                badge: const HUFAvatarBadge.dot(
                  placement: HUFAvatarBadgePlacement.bottomRight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const ShowcaseSubsectionTitle('Colori badge personalizzati'),
          const HUFAvatar(
            initials: 'AG',
            badge: HUFAvatarBadge(
              content: 'VIP',
              backgroundColor: Color(0xFF7C3AED),
              foregroundColor: Color(0xFFFFFFFF),
            ),
          ),
          const SizedBox(height: 24),
          const ShowcaseSectionTitle('Avatar group'),
          const ShowcaseSubsectionTitle('Tutti visibili · immagini'),
          HUFAvatarGroup(
            children: [
              for (final image in _images.take(4))
                HUFAvatar(image: image),
            ],
          ),
          const SizedBox(height: 16),
          const ShowcaseSubsectionTitle('Con max · immagini'),
          HUFAvatarGroup(
            max: 4,
            children: [
              for (final image in _images)
                HUFAvatar(image: image),
            ],
          ),
          const SizedBox(height: 16),
          const ShowcaseSubsectionTitle('Con max · iniziali'),
          HUFAvatarGroup(
            max: 4,
            children: [
              for (final initials in _initials)
                HUFAvatar(initials: initials),
            ],
          ),
          const SizedBox(height: 16),
          const ShowcaseSubsectionTitle('Mix immagini e iniziali'),
          HUFAvatarGroup(
            max: 4,
            children: [
              HUFAvatar(image: _images[0]),
              const HUFAvatar(initials: 'MK'),
              HUFAvatar(image: _images[2]),
              const HUFAvatar(initials: 'RS'),
              const HUFAvatar(initials: 'TN'),
            ],
          ),
          const SizedBox(height: 24),
          const ShowcaseSectionTitle('Avatar group · dimensioni'),
          for (final size in HUFAvatarSize.values) ...[
            ShowcaseSubsectionTitle(showcaseAvatarSizeLabel(size)),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: HUFAvatarGroup(
                size: size,
                max: 4,
                children: [
                  for (final initials in _initials)
                    HUFAvatar(initials: initials),
                ],
              ),
            ),
          ],
          const ShowcaseSectionTitle('Avatar group · colori'),
          for (final color in HUFAvatarColor.values) ...[
            for (final variant in HUFAvatarVariant.values) ...[
              ShowcaseSubsectionTitle(
                '${showcaseAvatarColorLabel(color)} · ${showcaseAvatarVariantLabel(variant)}',
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: HUFAvatarGroup(
                  color: color,
                  variant: variant,
                  max: 4,
                  children: [
                    for (final initials in _initials)
                      HUFAvatar(initials: initials),
                  ],
                ),
              ),
            ],
          ],
          const ShowcaseSectionTitle('Avatar group · overflow personalizzato'),
          HUFAvatarGroup(
            max: 3,
            overflowBackgroundColor: const Color(0xFF312E81),
            overflowForegroundColor: const Color(0xFFC4B5FD),
            children: [
              for (final initials in _initials)
                HUFAvatar(initials: initials),
            ],
          ),
          const SizedBox(height: 16),
          const ShowcaseSubsectionTitle('Overlap e ring personalizzati'),
          HUFAvatarGroup(
            max: 4,
            overlap: 16,
            ringWidth: 3,
            children: [
              for (final image in _images)
                HUFAvatar(image: image),
            ],
          ),
        ],
      ),
    );
  }
}

String showcaseAvatarSizeLabel(HUFAvatarSize size) {
  return switch (size) {
    HUFAvatarSize.small => 'Small',
    HUFAvatarSize.medium => 'Medium',
    HUFAvatarSize.large => 'Large',
  };
}

String showcaseAvatarColorLabel(HUFAvatarColor color) {
  return switch (color) {
    HUFAvatarColor.defaultColor => 'Default',
    HUFAvatarColor.accent => 'Accent',
    HUFAvatarColor.success => 'Success',
    HUFAvatarColor.warning => 'Warning',
    HUFAvatarColor.danger => 'Danger',
  };
}

String showcaseAvatarVariantLabel(HUFAvatarVariant variant) {
  return switch (variant) {
    HUFAvatarVariant.defaultVariant => 'Default',
    HUFAvatarVariant.soft => 'Soft',
  };
}

String showcaseAvatarBadgeColorLabel(HUFAvatarBadgeColor color) {
  return switch (color) {
    HUFAvatarBadgeColor.defaultColor => 'Default',
    HUFAvatarBadgeColor.accent => 'Accent',
    HUFAvatarBadgeColor.success => 'Success',
    HUFAvatarBadgeColor.warning => 'Warning',
    HUFAvatarBadgeColor.danger => 'Danger',
  };
}

String showcaseAvatarBadgePlacementLabel(HUFAvatarBadgePlacement placement) {
  return switch (placement) {
    HUFAvatarBadgePlacement.topRight => 'Top right',
    HUFAvatarBadgePlacement.topLeft => 'Top left',
    HUFAvatarBadgePlacement.bottomRight => 'Bottom right',
    HUFAvatarBadgePlacement.bottomLeft => 'Bottom left',
  };
}
