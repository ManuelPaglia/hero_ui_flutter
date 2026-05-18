import 'package:flutter/material.dart';
import 'package:hero_ui_flutter/hero_ui_flutter.dart';

import 'showcase_shared.dart';

class ChipsShowcasePage extends StatelessWidget {
  const ChipsShowcasePage({
    required this.onToggleTheme,
    super.key,
  });

  final VoidCallback onToggleTheme;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chip'),
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
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  ShowcaseSubsectionTitle('Disabled'),
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
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
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
