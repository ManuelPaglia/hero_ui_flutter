import 'package:flutter/material.dart';
import 'package:hero_ui_flutter/hero_ui_flutter.dart';

import 'showcase_shared.dart';

class SwitchesShowcasePage extends StatefulWidget {
  const SwitchesShowcasePage({
    required this.onToggleTheme,
    super.key,
  });

  final VoidCallback onToggleTheme;

  @override
  State<SwitchesShowcasePage> createState() => _SwitchesShowcasePageState();
}

class _SwitchesShowcasePageState extends State<SwitchesShowcasePage> {
  bool _onMedium = true;
  bool _offMedium = false;
  Set<String> _groupValues = {'wifi', 'bluetooth'};

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Switch'),
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
          const ShowcaseSectionTitle('Dimensioni'),
          for (final size in HUFSwitchSize.values) ...[
            ShowcaseSubsectionTitle(_sizeLabel(size)),
            Wrap(
              spacing: 24,
              runSpacing: 16,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                HUFSwitch(
                  value: true,
                  onChanged: (_) {},
                  size: size,
                ),
                HUFSwitch(
                  value: false,
                  onChanged: (_) {},
                  size: size,
                ),
                HUFSwitch(
                  value: true,
                  onChanged: null,
                  size: size,
                ),
                HUFSwitch(
                  value: false,
                  onChanged: null,
                  size: size,
                ),
                HUFSwitch(
                  value: true,
                  onChanged: (_) {},
                  size: size,
                  label: 'Con etichetta',
                ),
                HUFSwitch(
                  value: true,
                  onChanged: (_) {},
                  size: size,
                  icon: const Icon(Icons.check_rounded),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
          const ShowcaseSectionTitle('Glow'),
          for (final glowSize in HUFGlowSize.values) ...[
            ShowcaseSubsectionTitle(_glowLabel(glowSize)),
            Wrap(
              spacing: 24,
              runSpacing: 16,
              children: [
                HUFSwitch(
                  value: true,
                  onChanged: (_) {},
                  glowSize: glowSize,
                ),
                HUFSwitch(
                  value: false,
                  onChanged: (_) {},
                  glowSize: glowSize,
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
          const ShowcaseSectionTitle('Colori personalizzati'),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              HUFSwitch(
                value: true,
                onChanged: (_) {},
                activeColor: const Color(0xFF22C55E),
                icon: const Icon(Icons.check_rounded),
              ),
              HUFSwitch(
                value: true,
                onChanged: (_) {},
                activeColor: const Color(0xFF38BDF8),
                icon: const Icon(Icons.wb_sunny_outlined),
              ),
              HUFSwitch(
                value: true,
                onChanged: (_) {},
                activeColor: const Color(0xFFEF4444),
                icon: const Icon(Icons.mic_off_outlined),
              ),
              HUFSwitch(
                value: true,
                onChanged: (_) {},
                activeColor: const Color(0xFFA855F7),
                icon: const Icon(Icons.notifications_none_outlined),
              ),
              HUFSwitch(
                value: true,
                onChanged: (_) {},
                activeColor: const Color(0xFF2563EB),
                icon: const Icon(Icons.volume_off_outlined),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const ShowcaseSectionTitle('Switch group'),
          HUFSwitchGroup<String>(
            initialValues: _groupValues,
            onChanged: (values) => setState(() => _groupValues = values),
            children: [
              HUFSwitch(
                optionValue: 'wifi',
                icon: const Icon(Icons.wifi),
                activeColor: const Color(0xFF22C55E),
              ),
              HUFSwitch(
                optionValue: 'bluetooth',
                icon: const Icon(Icons.bluetooth),
                activeColor: const Color(0xFF38BDF8),
              ),
              HUFSwitch(
                optionValue: 'mic',
                icon: const Icon(Icons.mic_off_outlined),
                activeColor: const Color(0xFFEF4444),
              ),
              HUFSwitch(
                optionValue: 'notifications',
                icon: const Icon(Icons.notifications_none_outlined),
                activeColor: const Color(0xFFA855F7),
              ),
              HUFSwitch(
                optionValue: 'sound',
                icon: const Icon(Icons.volume_off_outlined),
                activeColor: const Color(0xFF2563EB),
              ),
            ],
          ),
          const SizedBox(height: 24),
          for (final radiusEntry in showcaseRadiusPresets.entries) ...[
            ShowcaseSectionTitle('Radius · ${radiusEntry.key}'),
            ShowcaseThemeScope(
              borderRadius: radiusEntry.value,
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  HUFSwitch(
                    value: _onMedium,
                    onChanged: (v) => setState(() => _onMedium = v),
                  ),
                  HUFSwitch(
                    value: _offMedium,
                    onChanged: (v) => setState(() => _offMedium = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }

  String _sizeLabel(HUFSwitchSize size) {
    return switch (size) {
      HUFSwitchSize.small => 'Small',
      HUFSwitchSize.medium => 'Medium',
      HUFSwitchSize.large => 'Large',
    };
  }

  String _glowLabel(HUFGlowSize size) {
    return switch (size) {
      HUFGlowSize.none => 'None',
      HUFGlowSize.small => 'Small',
      HUFGlowSize.medium => 'Medium',
      HUFGlowSize.large => 'Large',
    };
  }
}
