import 'package:flutter/material.dart';
import 'package:hero_ui_flutter/hero_ui_flutter.dart';

import '../example_app_scope.dart';
import 'showcase_shared.dart';

class ProgressShowcasePage extends StatelessWidget {
  const ProgressShowcasePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ShowcaseAppBar(title: 'Progress'),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const ShowcaseSectionTitle('Dimensioni'),
          for (final entry in _sizeEntries) ...[
            HUFProgress(
              label: entry.label,
              value: entry.value,
              maxValue: 100,
              size: entry.size,
            ),
            const SizedBox(height: 20),
          ],
          const ShowcaseSectionTitle('Loading'),
          const HUFProgress(
            label: 'Loading...',
            isLoading: true,
            size: HUFProgressSize.medium,
          ),
          const SizedBox(height: 20),
          const HUFProgress(
            label: 'Loading...',
            isLoading: true,
            size: HUFProgressSize.small,
          ),
          const SizedBox(height: 32),
          const ShowcaseSectionTitle('Valore e suffisso'),
          const HUFProgress(
            label: 'Upload',
            value: 240,
            maxValue: 500,
            valueSuffix: ' MB',
            showValue: true,
          ),
          const SizedBox(height: 16),
          const HUFProgress(
            label: 'Senza valore',
            value: 60,
            showValue: false,
          ),
          const SizedBox(height: 24),
          const ShowcaseSectionTitle('Colori personalizzati'),
          const HUFProgress(
            label: 'Primary',
            value: 70,
            fillColor: Color(0xFF0485F7),
          ),
          const SizedBox(height: 16),
          const HUFProgress(
            label: 'Success',
            value: 85,
            fillColor: Color(0xFF15C964),
          ),
        ],
      ),
    );
  }
}

class _SizeEntry {
  const _SizeEntry({
    required this.label,
    required this.value,
    required this.size,
  });

  final String label;
  final double value;
  final HUFProgressSize size;
}

const _sizeEntries = [
  _SizeEntry(label: 'Small', value: 40, size: HUFProgressSize.small),
  _SizeEntry(label: 'Medium', value: 60, size: HUFProgressSize.medium),
  _SizeEntry(label: 'Large', value: 80, size: HUFProgressSize.large),
];
