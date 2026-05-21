import 'package:flutter/material.dart';
import 'package:hero_ui_flutter/hero_ui_flutter.dart';

import '../example_app_scope.dart';
import 'showcase_shared.dart';

class AlertsShowcasePage extends StatelessWidget {
  const AlertsShowcasePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ShowcaseAppBar(title: 'Alert'),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const ShowcaseSubsectionTitle('Esempi statici (come design)'),
          const SizedBox(height: 8),
          HUFAlert(
            icon: const Icon(Icons.info_outline),
            title: 'New message from Sarah',
            description:
                'Hey! Just wanted to check in and see how the project is coming along.',
            color: HUFAlertColor.defaultColor,
          ),
          const SizedBox(height: 12),
          HUFAlert(
            icon: const Icon(Icons.system_update_alt_outlined),
            title: 'Update available',
            description:
                'Version 2.4.0 is ready to install with performance improvements.',
            color: HUFAlertColor.accent,
            action: HUFAlertAction(
              label: 'Refresh',
              onPressed: () {},
            ),
          ),
          const SizedBox(height: 12),
          HUFAlert(
            icon: const Icon(Icons.cloud_off_outlined),
            title: 'Unable to connect to server',
            description: 'Please check your connection and try again:',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _bullet(context, 'Verify your internet connection'),
                _bullet(context, 'Check if the server is online'),
                _bullet(context, 'Try again in a few minutes'),
              ],
            ),
            color: HUFAlertColor.danger,
            action: HUFAlertAction(
              label: 'Retry',
              onPressed: () {},
            ),
          ),
          const SizedBox(height: 12),
          HUFAlert(
            icon: const Icon(Icons.check_circle_outline),
            title: 'Profile updated successfully',
            color: HUFAlertColor.success,
            showCloseButton: true,
            onDismiss: () {},
          ),
          const SizedBox(height: 12),
          HUFAlert(
            isLoading: true,
            title: 'Processing your request',
            description: 'This may take a few moments. Please wait.',
            color: HUFAlertColor.accent,
          ),
          const SizedBox(height: 12),
          HUFAlert(
            icon: const Icon(Icons.warning_amber_outlined),
            title: 'Scheduled maintenance',
            description:
                'Our services will be unavailable on Sunday from 2:00 AM to 6:00 AM EST.',
            color: HUFAlertColor.warning,
          ),
          const SizedBox(height: 32),
          const ShowcaseSubsectionTitle('Dimensioni'),
          for (final size in HUFAlertSize.values) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: HUFAlert(
                size: size,
                icon: const Icon(Icons.notifications_outlined),
                title: 'Notifica · ${showcaseAlertSizeLabel(size)}',
                description: 'Testo descrittivo secondario.',
                color: HUFAlertColor.accent,
              ),
            ),
          ],
          const SizedBox(height: 32),
          const ShowcaseSubsectionTitle('Overlay (4 angoli)'),
          const Text(
            'Gli alert in overlay non usano scrim e compaiono negli angoli. '
            'Richiedono HUFAlertOverlay nel builder di MaterialApp.',
            style: TextStyle(height: 1.4),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final position in HUFAlertPosition.values)
                HUFButton(
                  label: showcaseAlertPositionLabel(position),
                  variant: HUFButtonVariant.outlined,
                  size: HUFButtonSize.small,
                  onPressed: () {
                    context.showHufAlert(
                      options: HUFShowAlertOptions(
                        position: position,
                        title: showcaseAlertPositionLabel(position),
                        description: 'Alert mostrato tramite hufShowAlert.',
                        icon: const Icon(Icons.place_outlined),
                        color: HUFAlertColor.accent,
                        showCloseButton: true,
                        duration: const Duration(seconds: 6),
                      ),
                    );
                  },
                ),
              HUFButton(
                label: 'Chiudi tutti',
                variant: HUFButtonVariant.ghost,
                size: HUFButtonSize.small,
                onPressed: () => context.dismissAllHufAlerts(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bullet(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('•  '),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

String showcaseAlertSizeLabel(HUFAlertSize size) {
  return switch (size) {
    HUFAlertSize.small => 'Small',
    HUFAlertSize.medium => 'Medium',
    HUFAlertSize.large => 'Large',
  };
}

String showcaseAlertPositionLabel(HUFAlertPosition position) {
  return switch (position) {
    HUFAlertPosition.topLeft => 'Alto sinistra',
    HUFAlertPosition.topRight => 'Alto destra',
    HUFAlertPosition.bottomLeft => 'Basso sinistra',
    HUFAlertPosition.bottomRight => 'Basso destra',
  };
}
