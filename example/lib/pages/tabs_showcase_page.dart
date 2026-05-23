import 'package:flutter/material.dart';
import 'package:hero_ui_flutter/hero_ui_flutter.dart';

import '../example_app_scope.dart';
import 'showcase_shared.dart';

class TabsShowcasePage extends StatefulWidget {
  const TabsShowcasePage({super.key});

  @override
  State<TabsShowcasePage> createState() => _TabsShowcasePageState();
}

class _TabsShowcasePageState extends State<TabsShowcasePage> {
  String _primaryHorizontal = 'overview';
  String _primaryVertical = 'billing';
  String _secondaryHorizontal = 'overview';
  String _secondaryVertical = 'security';
  String _controlled = 'active';
  String _primaryDisabled = 'active';

  @override
  Widget build(BuildContext context) {
    final colors = context.hufTheme.colors;

    return Scaffold(
      appBar: const ShowcaseAppBar(title: 'Tabs'),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const ShowcaseSectionTitle('Primary · orizzontale'),
          HUFTabs<String>(
            value: _primaryHorizontal,
            onChanged: (value) => setState(() => _primaryHorizontal = value),
            items: const [
              HUFTabItem(label: 'Overview', value: 'overview'),
              HUFTabItem(label: 'Analytics', value: 'analytics'),
              HUFTabItem(label: 'Reports', value: 'reports'),
            ],
          ),
          const SizedBox(height: 32),
          const ShowcaseSectionTitle('Primary · verticale'),
          HUFTabs<String>(
            direction: HUFTabDirection.vertical,
            value: _primaryVertical,
            onChanged: (value) => setState(() => _primaryVertical = value),
            items: const [
              HUFTabItem(label: 'Account', value: 'account'),
              HUFTabItem(label: 'Security', value: 'security'),
              HUFTabItem(label: 'Notifications', value: 'notifications'),
              HUFTabItem(label: 'Billing', value: 'billing'),
            ],
          ),
          const SizedBox(height: 32),
          const ShowcaseSectionTitle('Primary · con voce disabilitata'),
          HUFTabs<String>(
            value: _primaryDisabled,
            onChanged: (value) => setState(() => _primaryDisabled = value),
            items: const [
              HUFTabItem(label: 'Active', value: 'active'),
              HUFTabItem(label: 'Disabled', value: 'disabled', enabled: false),
              HUFTabItem(label: 'Available', value: 'available'),
            ],
          ),
          const SizedBox(height: 32),
          const ShowcaseSectionTitle('Secondary · orizzontale'),
          HUFTabs<String>(
            variant: HUFTabVariant.secondary,
            value: _secondaryHorizontal,
            onChanged: (value) =>
                setState(() => _secondaryHorizontal = value),
            indicatorColor: colors.primary,
            items: const [
              HUFTabItem(label: 'Overview', value: 'overview'),
              HUFTabItem(label: 'Analytics', value: 'analytics'),
              HUFTabItem(label: 'Reports', value: 'reports'),
            ],
          ),
          const SizedBox(height: 32),
          const ShowcaseSectionTitle('Secondary · verticale'),
          HUFTabs<String>(
            variant: HUFTabVariant.secondary,
            direction: HUFTabDirection.vertical,
            value: _secondaryVertical,
            onChanged: (value) => setState(() => _secondaryVertical = value),
            indicatorColor: colors.primary,
            items: const [
              HUFTabItem(label: 'Account', value: 'account'),
              HUFTabItem(label: 'Security', value: 'security'),
              HUFTabItem(label: 'Notifications', value: 'notifications'),
              HUFTabItem(label: 'Billing', value: 'billing'),
            ],
          ),
          const SizedBox(height: 32),
          const ShowcaseSectionTitle('Controllato dall\'esterno'),
          Text(
            'Attivo: $_controlled',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          HUFTabs<String>(
            value: _controlled,
            onChanged: (value) => setState(() => _controlled = value),
            items: const [
              HUFTabItem(label: 'Active', value: 'active'),
              HUFTabItem(label: 'Available', value: 'available'),
            ],
          ),
        ],
      ),
    );
  }
}
