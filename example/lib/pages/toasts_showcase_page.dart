import 'package:flutter/material.dart';
import 'package:hero_ui_flutter/hero_ui_flutter.dart';

import '../example_app_scope.dart';
import 'showcase_shared.dart';

class ToastsShowcasePage extends StatelessWidget {
  const ToastsShowcasePage({super.key});

  void _showSuccessBottom(BuildContext context) {
    context.showHufToast(
      options: HUFShowToastOptions(
        position: HUFToastPosition.bottomCenter,
        durationSeconds: 5,
        icon: const Icon(Icons.check_circle_outline),
        color: HUFAlertColor.success,
        title: 'You have upgraded your plan',
        description: 'You can continue using HeroUI Chat',
        action: HUFToastAction(
          label: 'Billing',
          onPressed: () {},
        ),
      ),
    );
  }

  void _showTopAccent(BuildContext context) {
    context.showHufToast(
      options: HUFShowToastOptions(
        position: HUFToastPosition.topCenter,
        durationSeconds: 4,
        icon: const Icon(Icons.info_outline),
        color: HUFAlertColor.accent,
        title: 'Nuova versione disponibile',
        description: 'Scorri dall\'alto · scompare dopo 4 secondi',
      ),
    );
  }

  void _showDefaultTheme(BuildContext context) {
    context.showHufToast(
      options: const HUFShowToastOptions(
        title: 'Titolo con colori del tema',
        description: 'Icona assente · defaultColor',
        durationSeconds: 3,
      ),
    );
  }

  void _showDangerPersistent(BuildContext context) {
    context.showHufToast(
      options: HUFShowToastOptions(
        position: HUFToastPosition.topCenter,
        icon: const Icon(Icons.error_outline),
        color: HUFAlertColor.danger,
        title: 'Errore di rete',
        description: 'Senza durationSeconds resta finché non lo chiudi manualmente',
        action: HUFToastAction(
          label: 'Riprova',
          onPressed: () {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ShowcaseAppBar(title: 'Toast'),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const ShowcaseSubsectionTitle('Design di riferimento'),
          const Text(
            'Richiede HUFToastOverlay nel builder di MaterialApp (già configurato nell\'esempio).',
            style: TextStyle(height: 1.4),
          ),
          const SizedBox(height: 16),
          HUFButton(
            label: 'Toast success (bottom)',
            variant: HUFButtonVariant.primary,
            onPressed: () => _showSuccessBottom(context),
          ),
          const SizedBox(height: 12),
          HUFButton(
            label: 'Toast accent (top)',
            variant: HUFButtonVariant.secondary,
            onPressed: () => _showTopAccent(context),
          ),
          const SizedBox(height: 12),
          HUFButton(
            label: 'Toast tema default',
            variant: HUFButtonVariant.outlined,
            onPressed: () => _showDefaultTheme(context),
          ),
          const SizedBox(height: 12),
          HUFButton(
            label: 'Toast danger persistente (top)',
            variant: HUFButtonVariant.dangerSoft,
            onPressed: () => _showDangerPersistent(context),
          ),
          const SizedBox(height: 32),
          const ShowcaseSubsectionTitle('Anteprima statica'),
          const HUFToast(
            icon: Icon(Icons.check_circle_outline),
            color: HUFAlertColor.success,
            title: 'You have upgraded your plan',
            description: 'You can continue using HeroUI Chat',
            action: HUFToastAction(label: 'Billing'),
          ),
        ],
      ),
    );
  }
}
