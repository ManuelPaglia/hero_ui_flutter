import 'package:flutter/material.dart';
import 'package:hero_ui_flutter/hero_ui_flutter.dart';

import '../example_app_scope.dart';
import 'showcase_shared.dart';

class AlertDialogsShowcasePage extends StatelessWidget {
  const AlertDialogsShowcasePage({super.key});

  void _showDeleteDialog(BuildContext context) {
    context.showHufAlertDialog(
      options: HUFShowAlertDialogOptions(
        icon: const Icon(Icons.error_outline),
        color: HUFAlertColor.danger,
        title: 'Delete project permanently?',
        content: RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 14,
              height: 1.45,
              color: HUFTheme.of(context).colors.cardMutedForeground,
            ),
            children: const [
              TextSpan(
                text:
                    'This will permanently delete ',
              ),
              TextSpan(
                text: 'My Awesome Project',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFCFCFC),
                ),
              ),
              TextSpan(
                text:
                    ' and all of its data. This action cannot be undone.',
              ),
            ],
          ),
        ),
        actions: [
          HUFButton(
            label: 'Cancel',
            variant: HUFButtonVariant.secondary,
            onPressed: () => Navigator.of(context).pop(),
          ),
          HUFButton(
            label: 'Delete Project',
            variant: HUFButtonVariant.danger,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _showTopDialog(BuildContext context) {
    context.showHufAlertDialog(
      options: HUFShowAlertDialogOptions(
        position: HUFAlertDialogPosition.top,
        icon: const Icon(Icons.info_outline),
        color: HUFAlertColor.accent,
        title: 'Posizione top',
        description: 'Il dialog è ancorato in alto con margine dal bordo.',
        actions: [
          HUFButton(
            label: 'OK',
            isFullWidth: true,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _showBottomFullWidthActions(BuildContext context) {
    context.showHufAlertDialog(
      options: HUFShowAlertDialogOptions(
        position: HUFAlertDialogPosition.bottom,
        icon: const Icon(Icons.warning_amber_outlined),
        color: HUFAlertColor.warning,
        title: 'Due azioni full-width',
        description: 'Ogni pulsante occupa il 50% della larghezza.',
        actions: [
          HUFButton(
            label: 'Annulla',
            variant: HUFButtonVariant.secondary,
            isFullWidth: true,
            onPressed: () => Navigator.of(context).pop(),
          ),
          HUFButton(
            label: 'Conferma',
            isFullWidth: true,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _showWithoutActions(BuildContext context) {
    context.showHufAlertDialog(
      options: HUFShowAlertDialogOptions(
        icon: const Icon(Icons.check_circle_outline),
        color: HUFAlertColor.success,
        title: 'Solo chiusura',
        description:
            'Nessuna azione nel footer: si chiude solo con la X in alto a destra.',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ShowcaseAppBar(title: 'Alert Dialog'),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const ShowcaseSubsectionTitle('Design di riferimento'),
          HUFButton(
            label: 'Apri dialog eliminazione',
            variant: HUFButtonVariant.danger,
            onPressed: () => _showDeleteDialog(context),
          ),
          const SizedBox(height: 32),
          const ShowcaseSubsectionTitle('Posizione e layout azioni'),
          HUFButton(
            label: 'Dialog in alto (azione full-width)',
            variant: HUFButtonVariant.secondary,
            onPressed: () => _showTopDialog(context),
          ),
          const SizedBox(height: 12),
          HUFButton(
            label: 'Dialog in basso (2 azioni 50%)',
            variant: HUFButtonVariant.secondary,
            onPressed: () => _showBottomFullWidthActions(context),
          ),
          const SizedBox(height: 12),
          HUFButton(
            label: 'Senza azioni footer',
            variant: HUFButtonVariant.outlined,
            onPressed: () => _showWithoutActions(context),
          ),
          const SizedBox(height: 32),
          const ShowcaseSubsectionTitle('Anteprima statica'),
          const HUFAlertDialog(
            icon: Icon(Icons.error_outline),
            color: HUFAlertColor.danger,
            title: 'Delete project permanently?',
            description:
                'Anteprima inline (senza overlay). Usa i pulsanti sopra per il modale.',
            onDismiss: _noop,
          ),
        ],
      ),
    );
  }
}

void _noop() {}
