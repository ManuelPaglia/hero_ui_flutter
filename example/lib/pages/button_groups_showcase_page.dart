import 'package:flutter/material.dart';
import 'package:hero_ui_flutter/hero_ui_flutter.dart';

import 'showcase_shared.dart';

class ButtonGroupsShowcasePage extends StatelessWidget {
  const ButtonGroupsShowcasePage({
    required this.onToggleTheme,
    super.key,
  });

  final VoidCallback onToggleTheme;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Button group'),
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
                  for (final variant in HUFButtonVariant.values) ...[
                    ShowcaseSubsectionTitle(showcaseVariantLabel(variant)),
                    for (final size in HUFButtonSize.values) ...[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: HUFButtonGroup(
                          variant: variant,
                          size: size,
                          items: [
                            HUFButtonGroupItem(
                              label:
                                  '${showcaseVariantLabel(variant)} · ${showcaseSizeLabel(size)}',
                              icon: Icon(showcaseIconForVariant(variant)),
                              onPressed: () {},
                            ),
                            HUFButtonGroupItem(
                              icon: const Icon(Icons.arrow_drop_down),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                  ],
                  ShowcaseSubsectionTitle('Solo icone'),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      for (final variant in HUFButtonVariant.values)
                        for (final size in HUFButtonSize.values)
                          HUFButtonGroup(
                            variant: variant,
                            size: size,
                            items: [
                              HUFButtonGroupItem(
                                icon: Icon(showcaseIconForVariant(variant)),
                                onPressed: () {},
                              ),
                              HUFButtonGroupItem(
                                icon: const Icon(Icons.more_horiz),
                                onPressed: () {},
                              ),
                              HUFButtonGroupItem(
                                icon: const Icon(Icons.arrow_drop_down),
                                onPressed: () {},
                              ),
                            ],
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
