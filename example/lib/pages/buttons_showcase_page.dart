import 'package:flutter/material.dart';
import 'package:hero_ui_flutter/hero_ui_flutter.dart';

import '../example_app_scope.dart';
import 'showcase_shared.dart';

class ButtonsShowcasePage extends StatelessWidget {
  const ButtonsShowcasePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ShowcaseAppBar(title: 'Bottoni'),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          for (final variant in HUFButtonVariant.values) ...[
            ShowcaseSubsectionTitle(showcaseVariantLabel(variant)),
            for (final size in HUFButtonSize.values) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: HUFButton(
                  label:
                      '${showcaseVariantLabel(variant)} · ${showcaseSizeLabel(size)}',
                  variant: variant,
                  size: size,
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () {},
                ),
              ),
            ],
            const SizedBox(height: 8),
          ],
          const ShowcaseSubsectionTitle('Icon only'),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final variant in HUFButtonVariant.values)
                for (final size in HUFButtonSize.values)
                  HUFButton.iconOnly(
                    icon: Icon(showcaseIconForVariant(variant)),
                    variant: variant,
                    size: size,
                    onPressed: () {},
                  ),
            ],
          ),
        ],
      ),
    );
  }
}
