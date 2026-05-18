import 'package:flutter/material.dart';
import 'package:hero_ui_flutter/hero_ui_flutter.dart';

const _radiusPresets = <String, HUFBorderRadius>{
  'Standard': HUFBorderRadius.standard,
  'Sharp': HUFBorderRadius.sharp,
  'Rounded': HUFBorderRadius.rounded,
  'Pill': HUFBorderRadius.pill,
};

class ButtonsShowcasePage extends StatelessWidget {
  const ButtonsShowcasePage({
    required this.onToggleTheme,
    super.key,
  });

  final VoidCallback onToggleTheme;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bottoni'),
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
          for (final radiusEntry in _radiusPresets.entries) ...[
            _SectionTitle('Radius · ${radiusEntry.key}'),
            _HufThemeScope(
              borderRadius: radiusEntry.value,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final variant in HUFButtonVariant.values) ...[
                    _SubsectionTitle(_variantLabel(variant)),
                    for (final size in HUFButtonSize.values) ...[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: HUFButton(
                          label:
                              '${_variantLabel(variant)} · ${_sizeLabel(size)}',
                          variant: variant,
                          size: size,
                          icon: const Icon(Icons.arrow_forward),
                          onPressed: () {},
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                  ],
                  _SubsectionTitle('Icon only'),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      for (final variant in HUFButtonVariant.values)
                        for (final size in HUFButtonSize.values)
                          HUFButton.iconOnly(
                            icon: Icon(_iconForVariant(variant)),
                            variant: variant,
                            size: size,
                            onPressed: () {},
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

class _HufThemeScope extends StatelessWidget {
  const _HufThemeScope({
    required this.borderRadius,
    required this.child,
  });

  final HUFBorderRadius borderRadius;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context);
    final huf = context.hufTheme;

    return Theme(
      data: base.copyWith(
        extensions: <ThemeExtension<dynamic>>[
          huf.copyWith(borderRadius: borderRadius),
        ],
      ),
      child: child,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

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

class _SubsectionTitle extends StatelessWidget {
  const _SubsectionTitle(this.text);

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

String _variantLabel(HUFButtonVariant variant) {
  return switch (variant) {
    HUFButtonVariant.primary => 'Primary',
    HUFButtonVariant.secondary => 'Secondary',
    HUFButtonVariant.outlined => 'Outlined',
    HUFButtonVariant.ghost => 'Ghost',
    HUFButtonVariant.danger => 'Danger',
    HUFButtonVariant.dangerSoft => 'Danger soft',
  };
}

String _sizeLabel(HUFButtonSize size) {
  return switch (size) {
    HUFButtonSize.small => 'Small',
    HUFButtonSize.medium => 'Medium',
    HUFButtonSize.large => 'Large',
  };
}

IconData _iconForVariant(HUFButtonVariant variant) {
  return switch (variant) {
    HUFButtonVariant.primary => Icons.add,
    HUFButtonVariant.secondary => Icons.edit_outlined,
    HUFButtonVariant.outlined => Icons.settings_outlined,
    HUFButtonVariant.ghost => Icons.favorite_border,
    HUFButtonVariant.danger => Icons.delete_outline,
    HUFButtonVariant.dangerSoft => Icons.warning_amber_outlined,
  };
}
