import 'package:flutter/material.dart';
import 'package:hero_ui_flutter/hero_ui_flutter.dart';

import 'showcase_shared.dart';

String _usd(double value) {
  final text = value.toStringAsFixed(2).replaceAll('.', ',');
  return '$text USD';
}

class SlidersShowcasePage extends StatefulWidget {
  const SlidersShowcasePage({
    required this.onToggleTheme,
    super.key,
  });

  final VoidCallback onToggleTheme;

  @override
  State<SlidersShowcasePage> createState() => _SlidersShowcasePageState();
}

class _SlidersShowcasePageState extends State<SlidersShowcasePage> {
  double _volume = 30;
  RangeValues _priceRange = const RangeValues(100, 500);
  double _stepped = 50;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Slider'),
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
          const ShowcaseSectionTitle('Interattivi'),
          HUFSlider(
            label: 'Volume',
            value: _volume,
            min: 0,
            max: 100,
            showValue: true,
            onChanged: (v) => setState(() => _volume = v),
          ),
          const SizedBox(height: 24),
          HUFRangeSlider(
            label: 'Price Range',
            values: _priceRange,
            min: 0,
            max: 1000,
            step: 10,
            showValue: true,
            valueFormatter: (v) => '${_usd(v.start)} – ${_usd(v.end)}',
            onChanged: (v) => setState(() => _priceRange = v),
          ),
          const SizedBox(height: 32),
          const ShowcaseSectionTitle('Dimensioni · Slider'),
          for (final size in HUFSliderSize.values) ...[
            ShowcaseSubsectionTitle(_sizeLabel(size)),
            HUFSlider(
              label: 'Volume',
              value: 30,
              showValue: true,
              size: size,
              onChanged: (_) {},
            ),
            const SizedBox(height: 16),
          ],
          const ShowcaseSectionTitle('Dimensioni · Range'),
          for (final size in HUFSliderSize.values) ...[
            ShowcaseSubsectionTitle(_sizeLabel(size)),
            HUFRangeSlider(
              label: 'Price Range',
              values: const RangeValues(100, 500),
              min: 0,
              max: 1000,
              showValue: true,
              size: size,
              valueFormatter: (v) => '${_usd(v.start)} – ${_usd(v.end)}',
              onChanged: (_) {},
            ),
            const SizedBox(height: 16),
          ],
          const ShowcaseSectionTitle('Valore visibile'),
          HUFSlider(
            label: 'Con valore',
            value: 30,
            showValue: true,
            onChanged: (_) {},
          ),
          const SizedBox(height: 16),
          HUFSlider(
            label: 'Senza valore',
            value: 30,
            onChanged: (_) {},
          ),
          const SizedBox(height: 24),
          const ShowcaseSectionTitle('Step'),
          HUFSlider(
            label: 'Step 10',
            value: _stepped,
            min: 0,
            max: 100,
            step: 10,
            showValue: true,
            onChanged: (v) => setState(() => _stepped = v),
          ),
          const SizedBox(height: 16),
          HUFRangeSlider(
            label: 'Range step 50',
            values: const RangeValues(100, 400),
            min: 0,
            max: 1000,
            step: 50,
            showValue: true,
            onChanged: (_) {},
          ),
          const SizedBox(height: 24),
          const ShowcaseSectionTitle('Min / Max'),
          HUFSlider(
            label: '0 – 10',
            value: 4,
            min: 0,
            max: 10,
            showValue: true,
            onChanged: (_) {},
          ),
          const SizedBox(height: 16),
          HUFRangeSlider(
            label: 'Anni',
            values: const RangeValues(2018, 2024),
            min: 2010,
            max: 2030,
            showValue: true,
            onChanged: (_) {},
          ),
          const SizedBox(height: 24),
          const ShowcaseSectionTitle('Disabled'),
          HUFSlider(
            label: 'Volume',
            value: 30,
            showValue: true,
            onChanged: null,
          ),
          const SizedBox(height: 16),
          HUFRangeSlider(
            label: 'Price Range',
            values: const RangeValues(100, 500),
            min: 0,
            max: 1000,
            showValue: true,
            valueFormatter: (v) => '${_usd(v.start)} – ${_usd(v.end)}',
            onChanged: null,
          ),
          const SizedBox(height: 24),
          const ShowcaseSectionTitle('Colori personalizzati'),
          HUFSlider(
            label: 'Verde',
            value: 60,
            showValue: true,
            activeColor: const Color(0xFF22C55E),
            onChanged: (_) {},
          ),
          const SizedBox(height: 16),
          HUFSlider(
            label: 'Viola',
            value: 40,
            showValue: true,
            activeColor: const Color(0xFFA855F7),
            onChanged: (_) {},
          ),
          const SizedBox(height: 16),
          HUFRangeSlider(
            label: 'Ciano',
            values: const RangeValues(20, 80),
            showValue: true,
            activeColor: const Color(0xFF38BDF8),
            onChanged: (_) {},
          ),
          const SizedBox(height: 24),
          for (final radiusEntry in showcaseRadiusPresets.entries) ...[
            ShowcaseSectionTitle('Radius · ${radiusEntry.key}'),
            ShowcaseThemeScope(
              borderRadius: radiusEntry.value,
              child: Column(
                children: [
                  HUFSlider(
                    label: 'Volume',
                    value: 45,
                    showValue: true,
                    onChanged: (_) {},
                  ),
                  const SizedBox(height: 16),
                  HUFRangeSlider(
                    label: 'Intervallo',
                    values: const RangeValues(25, 75),
                    showValue: true,
                    onChanged: (_) {},
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

  String _sizeLabel(HUFSliderSize size) {
    return switch (size) {
      HUFSliderSize.small => 'Small',
      HUFSliderSize.medium => 'Medium',
      HUFSliderSize.large => 'Large',
    };
  }
}
