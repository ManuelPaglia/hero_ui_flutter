import 'package:flutter/material.dart';
import 'package:hero_ui_flutter/hero_ui_flutter.dart';

import 'showcase_shared.dart';

class CheckboxesShowcasePage extends StatefulWidget {
  const CheckboxesShowcasePage({
    required this.onToggleTheme,
    super.key,
  });

  final VoidCallback onToggleTheme;

  @override
  State<CheckboxesShowcasePage> createState() => _CheckboxesShowcasePageState();
}

class _CheckboxesShowcasePageState extends State<CheckboxesShowcasePage> {
  bool _checkedMedium = true;
  bool _checkedSmall = false;
  bool _checkedLarge = true;
  bool _checkedCustom = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkbox'),
        actions: [
          IconButton(
            onPressed: widget.onToggleTheme,
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
                  for (final size in HUFCheckboxSize.values) ...[
                    ShowcaseSubsectionTitle(_sizeLabel(size)),
                    Wrap(
                      spacing: 24,
                      runSpacing: 16,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        HUFCheckbox(
                          value: true,
                          onChanged: (_) {},
                          size: size,
                        ),
                        HUFCheckbox(
                          value: false,
                          onChanged: (_) {},
                          size: size,
                        ),
                        HUFCheckbox(
                          value: true,
                          onChanged: null,
                          size: size,
                        ),
                        HUFCheckbox(
                          value: false,
                          onChanged: null,
                          size: size,
                        ),
                        HUFCheckbox(
                          value: true,
                          onChanged: (_) {},
                          size: size,
                          label: 'Con etichetta',
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
          const ShowcaseSectionTitle('Glow'),
          for (final glowSize in HUFGlowSize.values) ...[
            ShowcaseSubsectionTitle(_glowLabel(glowSize)),
            Wrap(
              spacing: 24,
              runSpacing: 16,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                HUFCheckbox(
                  value: true,
                  onChanged: (_) {},
                  glowSize: glowSize,
                ),
                HUFCheckbox(
                  value: false,
                  onChanged: (_) {},
                  glowSize: glowSize,
                ),
                HUFCheckbox(
                  value: true,
                  onChanged: (_) {},
                  glowSize: glowSize,
                  label: 'Con etichetta',
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
          const ShowcaseSectionTitle('Interattivi'),
          HUFCheckbox(
            value: _checkedSmall,
            onChanged: (v) => setState(() => _checkedSmall = v),
            size: HUFCheckboxSize.small,
            label: 'Small',
          ),
          const SizedBox(height: 12),
          HUFCheckbox(
            value: _checkedMedium,
            onChanged: (v) => setState(() => _checkedMedium = v),
            label: 'Medium (default)',
          ),
          const SizedBox(height: 12),
          HUFCheckbox(
            value: _checkedLarge,
            onChanged: (v) => setState(() => _checkedLarge = v),
            size: HUFCheckboxSize.large,
            label: 'Large',
          ),
          const SizedBox(height: 24),
          const ShowcaseSubsectionTitle('Override colori (widget)'),
          HUFCheckbox(
            value: _checkedCustom,
            onChanged: (v) => setState(() => _checkedCustom = v),
            activeColor: const Color(0xFF059669),
            checkColor: Colors.white,
            borderColor: const Color(0xFF059669),
            label: 'Verde custom',
          ),
          const SizedBox(height: 24),
          const ShowcaseSubsectionTitle('Icone custom'),
          Wrap(
            spacing: 24,
            runSpacing: 16,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              HUFCheckbox(
                value: true,
                onChanged: (_) {},
                checkedIcon: const Icon(Icons.favorite),
                label: 'Preferiti',
              ),
              HUFCheckbox(
                value: false,
                onChanged: (_) {},
                uncheckedIcon: const Icon(Icons.favorite_border),
                checkedIcon: const Icon(Icons.favorite),
                label: 'Toggle cuore',
              ),
              HUFCheckbox(
                value: true,
                onChanged: (_) {},
                checkedIcon: const Icon(Icons.star_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _sizeLabel(HUFCheckboxSize size) {
    return switch (size) {
      HUFCheckboxSize.small => 'Small',
      HUFCheckboxSize.medium => 'Medium',
      HUFCheckboxSize.large => 'Large',
    };
  }

  String _glowLabel(HUFGlowSize glowSize) {
    return switch (glowSize) {
      HUFGlowSize.none => 'None',
      HUFGlowSize.small => 'Small',
      HUFGlowSize.medium => 'Medium',
      HUFGlowSize.large => 'Large',
    };
  }
}
