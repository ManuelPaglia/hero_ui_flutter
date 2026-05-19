import 'package:flutter/material.dart';
import 'package:hero_ui_flutter/hero_ui_flutter.dart';

import '../example_app_scope.dart';
import 'showcase_shared.dart';

class RadioButtonsShowcasePage extends StatefulWidget {
  const RadioButtonsShowcasePage({super.key});

  @override
  State<RadioButtonsShowcasePage> createState() => _RadioButtonsShowcasePageState();
}

class _RadioButtonsShowcasePageState extends State<RadioButtonsShowcasePage> {
  bool _selectedSmall = false;
  bool _selectedMedium = true;
  bool _selectedLarge = false;
  bool _selectedCustom = true;
  String? _groupValue = 'notifications';
  String? _frequencyValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ShowcaseAppBar(title: 'Radio button'),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const ShowcaseSectionTitle('Dimensioni'),
          for (final size in HUFRadioButtonSize.values) ...[
            ShowcaseSubsectionTitle(_sizeLabel(size)),
            Wrap(
              spacing: 24,
              runSpacing: 16,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                HUFRadioButton(
                  value: true,
                  onChanged: (_) {},
                  size: size,
                ),
                HUFRadioButton(
                  value: false,
                  onChanged: (_) {},
                  size: size,
                ),
                HUFRadioButton(
                  value: true,
                  onChanged: null,
                  size: size,
                ),
                HUFRadioButton(
                  value: false,
                  onChanged: null,
                  size: size,
                ),
                HUFRadioButton(
                  value: true,
                  onChanged: (_) {},
                  size: size,
                  label: 'Con etichetta',
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
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                HUFRadioButton(
                  value: true,
                  onChanged: (_) {},
                  glowSize: glowSize,
                ),
                HUFRadioButton(
                  value: false,
                  onChanged: (_) {},
                  glowSize: glowSize,
                ),
                HUFRadioButton(
                  value: true,
                  onChanged: (_) {},
                  glowSize: glowSize,
                  label: 'Con etichetta',
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
          const ShowcaseSectionTitle('Radio button group'),
          const ShowcaseSubsectionTitle('Preferenze notifiche'),
          HUFRadioButtonGroup<String>(
            initialValue: _groupValue,
            onChanged: (value) => setState(() => _groupValue = value),
            children: const [
              HUFRadioButton(
                optionValue: 'notifications',
                label: 'Notifiche push',
              ),
              HUFRadioButton(
                optionValue: 'newsletter',
                label: 'Newsletter',
              ),
              HUFRadioButton(
                optionValue: 'marketing',
                label: 'Comunicazioni marketing',
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Selezionato: ${_groupValue ?? 'nessuno'}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          const SizedBox(height: 20),
          const ShowcaseSubsectionTitle('Frequenza report'),
          HUFRadioButtonGroup<String>(
            initialValue: _frequencyValue,
            onChanged: (value) => setState(() => _frequencyValue = value),
            children: const [
              HUFRadioButton(optionValue: 'daily', label: 'Giornaliero'),
              HUFRadioButton(optionValue: 'weekly', label: 'Settimanale'),
              HUFRadioButton(optionValue: 'monthly', label: 'Mensile'),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              _frequencyValue == null
                  ? 'Nessuna frequenza selezionata'
                  : 'Frequenza: $_frequencyValue',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          const SizedBox(height: 32),
          const ShowcaseSectionTitle('Interattivi'),
          HUFRadioButton(
            value: _selectedSmall,
            onChanged: (v) => setState(() {
              _selectedSmall = v;
              _selectedMedium = false;
              _selectedLarge = false;
            }),
            size: HUFRadioButtonSize.small,
            label: 'Small',
          ),
          const SizedBox(height: 12),
          HUFRadioButton(
            value: _selectedMedium,
            onChanged: (v) => setState(() {
              _selectedSmall = false;
              _selectedMedium = v;
              _selectedLarge = false;
            }),
            label: 'Medium (default)',
          ),
          const SizedBox(height: 12),
          HUFRadioButton(
            value: _selectedLarge,
            onChanged: (v) => setState(() {
              _selectedSmall = false;
              _selectedMedium = false;
              _selectedLarge = v;
            }),
            size: HUFRadioButtonSize.large,
            label: 'Large',
          ),
          const SizedBox(height: 24),
          const ShowcaseSubsectionTitle('Override colori (widget)'),
          HUFRadioButton(
            value: _selectedCustom,
            onChanged: (v) => setState(() => _selectedCustom = v),
            activeColor: const Color(0xFF059669),
            dotColor: const Color(0xFF059669),
            borderColor: const Color(0xFF059669),
            label: 'Verde custom',
          ),
        ],
      ),
    );
  }

  String _sizeLabel(HUFRadioButtonSize size) {
    return switch (size) {
      HUFRadioButtonSize.small => 'Small',
      HUFRadioButtonSize.medium => 'Medium',
      HUFRadioButtonSize.large => 'Large',
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
