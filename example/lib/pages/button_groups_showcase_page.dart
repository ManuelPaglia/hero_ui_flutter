import 'package:flutter/material.dart';
import 'package:hero_ui_flutter/hero_ui_flutter.dart';

import '../example_app_scope.dart';
import 'showcase_shared.dart';

class ButtonGroupsShowcasePage extends StatelessWidget {
  const ButtonGroupsShowcasePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ShowcaseAppBar(title: 'Button group'),
      body: ListView(
        padding: const EdgeInsets.all(24),
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
          const ShowcaseSubsectionTitle('Solo icone'),
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
        ],
      ),
    );
  }
}
