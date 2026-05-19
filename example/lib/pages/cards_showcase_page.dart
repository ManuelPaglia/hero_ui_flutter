import 'package:flutter/material.dart';
import 'package:hero_ui_flutter/hero_ui_flutter.dart';

import '../example_app_scope.dart';
import 'showcase_shared.dart';

class CardsShowcasePage extends StatelessWidget {
  const CardsShowcasePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ShowcaseAppBar(title: 'Card'),
      body: ListView(
        padding: const EdgeInsets.all(24),
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
}
