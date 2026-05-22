import 'package:flutter/material.dart';
import 'package:hero_ui_flutter/hero_ui_flutter.dart';

import '../example_app_scope.dart';
import 'showcase_shared.dart';

class DrawersShowcasePage extends StatelessWidget {
  const DrawersShowcasePage({super.key});

  List<Widget> _sampleContent(BuildContext context) => [
        Text(
          'Menu',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const HUFSeparator(),
        HUFButton(
          label: 'Profilo',
          variant: HUFButtonVariant.ghost,
          isFullWidth: true,
          onPressed: () {},
        ),
        HUFButton(
          label: 'Impostazioni',
          variant: HUFButtonVariant.ghost,
          isFullWidth: true,
          onPressed: () {},
        ),
      ];

  void _showLeftDrawer(BuildContext context) {
    context.showHufDrawer(
      options: HUFShowDrawerOptions(
        openFrom: HUFDrawerOpenFrom.left,
        content: _sampleContent(context),
      ),
    );
  }

  void _showRightDrawer(BuildContext context) {
    context.showHufDrawer(
      options: HUFShowDrawerOptions(
        openFrom: HUFDrawerOpenFrom.right,
        content: _sampleContent(context),
      ),
    );
  }

  void _showFixedWidthDrawer(BuildContext context) {
    context.showHufDrawer(
      options: HUFShowDrawerOptions(
        openFrom: HUFDrawerOpenFrom.left,
        width: 280,
        content: [
          Text(
            'Larghezza fissa 280 px',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          ..._sampleContent(context),
        ],
      ),
    );
  }

  void _showBottomDefault(BuildContext context) {
    context.showHufDrawer(
      options: HUFShowDrawerOptions(
        openFrom: HUFDrawerOpenFrom.bottom,
        content: _sampleContent(context),
      ),
    );
  }

  void _showBottomFixedHeight(BuildContext context) {
    context.showHufDrawer(
      options: HUFShowDrawerOptions(
        openFrom: HUFDrawerOpenFrom.bottom,
        height: 320,
        content: [
          Text(
            'Altezza fissa 320 px',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          ..._sampleContent(context),
        ],
      ),
    );
  }

  void _showBottomFull(BuildContext context) {
    context.showHufDrawer(
      options: HUFShowDrawerOptions(
        openFrom: HUFDrawerOpenFrom.bottom,
        isFullWidth: true,
        content: [
          Text(
            'Drawer full dal basso',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Chiude solo con la X in alto a destra.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          ..._sampleContent(context),
        ],
      ),
    );
  }

  void _showFullWidthLeft(BuildContext context) {
    context.showHufDrawer(
      options: HUFShowDrawerOptions(
        openFrom: HUFDrawerOpenFrom.left,
        isFullWidth: true,
        content: [
          Text(
            'Drawer full da sinistra',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          ..._sampleContent(context),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ShowcaseAppBar(title: 'Drawer'),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const ShowcaseSubsectionTitle('Laterali'),
          HUFButton(
            label: 'Da sinistra',
            onPressed: () => _showLeftDrawer(context),
          ),
          const SizedBox(height: 12),
          HUFButton(
            label: 'Da destra',
            variant: HUFButtonVariant.secondary,
            onPressed: () => _showRightDrawer(context),
          ),
          const SizedBox(height: 12),
          HUFButton(
            label: 'Larghezza fissa (280 px)',
            variant: HUFButtonVariant.outlined,
            onPressed: () => _showFixedWidthDrawer(context),
          ),
          const SizedBox(height: 12),
          HUFButton(
            label: 'Full width da sinistra (solo X)',
            variant: HUFButtonVariant.dangerSoft,
            onPressed: () => _showFullWidthLeft(context),
          ),
          const SizedBox(height: 32),
          const ShowcaseSubsectionTitle('Dal basso'),
          HUFButton(
            label: 'Default (altezza dal contenuto)',
            onPressed: () => _showBottomDefault(context),
          ),
          const SizedBox(height: 12),
          HUFButton(
            label: 'Altezza fissa (320 px)',
            variant: HUFButtonVariant.secondary,
            onPressed: () => _showBottomFixedHeight(context),
          ),
          const SizedBox(height: 12),
          HUFButton(
            label: 'Full screen (solo X)',
            variant: HUFButtonVariant.outlined,
            onPressed: () => _showBottomFull(context),
          ),
        ],
      ),
    );
  }
}
