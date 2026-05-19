import 'package:flutter/material.dart';
import 'package:hero_ui_flutter/hero_ui_flutter.dart';

import '../example_app_scope.dart';
import 'showcase_shared.dart';

class ChipsShowcasePage extends StatelessWidget {
  const ChipsShowcasePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ShowcaseAppBar(title: 'Chip'),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          for (final variant in HUFChipVariant.values) ...[
            ShowcaseSubsectionTitle(showcaseChipVariantLabel(variant)),
            for (final size in HUFChipSize.values) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: HUFChip(
                  label:
                      '${showcaseChipVariantLabel(variant)} · ${showcaseChipSizeLabel(size)}',
                  variant: variant,
                  size: size,
                  icon: const Icon(Icons.label_outline),
                ),
              ),
            ],
            const SizedBox(height: 8),
          ],
          const ShowcaseSubsectionTitle('Disabled'),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final variant in HUFChipVariant.values)
                for (final size in HUFChipSize.values)
                  HUFChip(
                    label:
                        '${showcaseChipVariantLabel(variant)} · ${showcaseChipSizeLabel(size)}',
                    variant: variant,
                    size: size,
                    icon: const Icon(Icons.label_outline),
                    isDisabled: true,
                  ),
            ],
          ),
        ],
      ),
    );
  }
}

String showcaseChipVariantLabel(HUFChipVariant variant) {
  return switch (variant) {
    HUFChipVariant.primary => 'Primary',
    HUFChipVariant.outlined => 'Outlined',
    HUFChipVariant.ghost => 'Ghost',
  };
}

String showcaseChipSizeLabel(HUFChipSize size) {
  return switch (size) {
    HUFChipSize.small => 'Small',
    HUFChipSize.medium => 'Medium',
    HUFChipSize.large => 'Large',
  };
}
