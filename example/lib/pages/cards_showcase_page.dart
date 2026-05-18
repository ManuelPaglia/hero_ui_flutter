import 'package:flutter/material.dart';
import 'package:hero_ui_flutter/hero_ui_flutter.dart';

import 'showcase_shared.dart';

class CardsShowcasePage extends StatelessWidget {
  const CardsShowcasePage({
    required this.onToggleTheme,
    super.key,
  });

  final VoidCallback onToggleTheme;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Card'),
        actions: [
          IconButton(
            onPressed: onToggleTheme,
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            tooltip: isDark ? 'Light mode' : 'Dark mode',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          for (final radiusEntry in showcaseRadiusPresets.entries) ...[
            ShowcaseSectionTitle('Radius · ${radiusEntry.key}'),
            ShowcaseThemeScope(
              borderRadius: radiusEntry.value,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final style in HUFCardStyle.values) ...[
                    ShowcaseSubsectionTitle(_styleLabel(style)),
                    HUFCard(
                      style: style,
                      title: 'Titolo card',
                      subtitle: 'Sottotitolo descrittivo',
                      image: _sampleImage(),
                      content: Text(
                        'Contenuto libero della card con testo di esempio.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      actions: [
                        HUFButton(
                          label: 'Azione',
                          variant: HUFButtonVariant.primary,
                          onPressed: () {},
                        ),
                        HUFButton(
                          label: 'Secondaria',
                          variant: HUFButtonVariant.secondary,
                          onPressed: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ],
              ),
            ),
          ],
          const ShowcaseSectionTitle('Orientamento orizzontale'),
          HUFCard(
            orientation: HUFCardOrientation.horizontal,
            title: 'Card orizzontale',
            subtitle: 'Immagine a sinistra, contenuto a destra',
            image: _sampleImage(),
            content: const Text('Il padding e il radius seguono il token del tema.'),
            actions: [
              HUFButton(
                label: 'Dettagli',
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 24),
          const ShowcaseSectionTitle('Azioni impilate'),
          HUFCard(
            style: HUFCardStyle.cardSecondary,
            title: 'Due pulsanti in colonna',
            actionsLayout: HUFCardActionsLayout.stacked,
            actions: [
              HUFButton(
                label: 'Conferma',
                isFullWidth: true,
                onPressed: () {},
              ),
              HUFButton(
                label: 'Annulla',
                variant: HUFButtonVariant.ghost,
                isFullWidth: true,
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 24),
          const ShowcaseSectionTitle('Scala radius'),
          for (final size in HUFCardRadiusSize.values) ...[
            ShowcaseSubsectionTitle(_radiusSizeLabel(size)),
            HUFCard(
              radiusSize: size,
              style: HUFCardStyle.cardTertiary,
              title: 'Radius ${_radiusSizeLabel(size)}',
              subtitle: 'Padding proporzionale al border radius',
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }

  Widget _sampleImage() {
    return Image.network(
      'https://picsum.photos/seed/huf-card/800/450',
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        color: const Color(0xFFCBD5E1),
        alignment: Alignment.center,
        child: const Icon(Icons.image_outlined, size: 48),
      ),
    );
  }

  String _styleLabel(HUFCardStyle style) {
    return switch (style) {
      HUFCardStyle.transparent => 'Transparent',
      HUFCardStyle.card => 'Card (default)',
      HUFCardStyle.cardSecondary => 'Card secondary',
      HUFCardStyle.cardTertiary => 'Card tertiary',
    };
  }

  String _radiusSizeLabel(HUFCardRadiusSize size) {
    return switch (size) {
      HUFCardRadiusSize.small => 'Small',
      HUFCardRadiusSize.medium => 'Medium',
      HUFCardRadiusSize.large => 'Large',
    };
  }
}
