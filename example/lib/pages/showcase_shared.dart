import 'package:flutter/material.dart';
import 'package:hero_ui_flutter/hero_ui_flutter.dart';

const showcaseRadiusPresets = <String, HUFBorderRadius>{
  'None': HUFBorderRadius.none,
  'Extra small': HUFBorderRadius.extraSmall,
  'Small': HUFBorderRadius.small,
  'Medium': HUFBorderRadius.medium,
  'Large': HUFBorderRadius.large,
};

class ShowcaseSectionTitle extends StatelessWidget {
  const ShowcaseSectionTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

class ShowcaseSubsectionTitle extends StatelessWidget {
  const ShowcaseSubsectionTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 4),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

String showcaseVariantLabel(HUFButtonVariant variant) {
  return switch (variant) {
    HUFButtonVariant.primary => 'Primary',
    HUFButtonVariant.secondary => 'Secondary',
    HUFButtonVariant.outlined => 'Outlined',
    HUFButtonVariant.ghost => 'Ghost',
    HUFButtonVariant.danger => 'Danger',
    HUFButtonVariant.dangerSoft => 'Danger soft',
  };
}

String showcaseSizeLabel(HUFButtonSize size) {
  return switch (size) {
    HUFButtonSize.small => 'Small',
    HUFButtonSize.medium => 'Medium',
    HUFButtonSize.large => 'Large',
  };
}

IconData showcaseIconForVariant(HUFButtonVariant variant) {
  return switch (variant) {
    HUFButtonVariant.primary => Icons.add,
    HUFButtonVariant.secondary => Icons.edit_outlined,
    HUFButtonVariant.outlined => Icons.settings_outlined,
    HUFButtonVariant.ghost => Icons.favorite_border,
    HUFButtonVariant.danger => Icons.delete_outline,
    HUFButtonVariant.dangerSoft => Icons.warning_amber_outlined,
  };
}
