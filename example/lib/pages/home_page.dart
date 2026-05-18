import 'package:flutter/material.dart';
import 'package:hero_ui_flutter/hero_ui_flutter.dart';

import 'button_groups_showcase_page.dart';
import 'buttons_showcase_page.dart';
import 'chips_showcase_page.dart';
import 'checkbox_cards_showcase_page.dart';
import 'checkboxes_showcase_page.dart';
import 'radio_buttons_showcase_page.dart';
import 'sliders_showcase_page.dart';
import 'switches_showcase_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    required this.onToggleTheme,
    super.key,
  });

  final VoidCallback onToggleTheme;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hero UI Flutter'),
        actions: [
          IconButton(
            onPressed: onToggleTheme,
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            tooltip: isDark ? 'Light mode' : 'Dark mode',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Componenti',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 32),
            HUFButton(
              label: 'Chip',
              variant: HUFButtonVariant.ghost,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => ChipsShowcasePage(
                      onToggleTheme: onToggleTheme,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            HUFButton(
              label: 'Bottoni',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => ButtonsShowcasePage(
                      onToggleTheme: onToggleTheme,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            HUFButton(
              label: 'Button group',
              variant: HUFButtonVariant.secondary,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => ButtonGroupsShowcasePage(
                      onToggleTheme: onToggleTheme,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            HUFButton(
              label: 'Checkbox',
              variant: HUFButtonVariant.outlined,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => CheckboxesShowcasePage(
                      onToggleTheme: onToggleTheme,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            HUFButton(
              label: 'Checkbox card',
              variant: HUFButtonVariant.ghost,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => CheckboxCardsShowcasePage(
                      onToggleTheme: onToggleTheme,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            HUFButton(
              label: 'Radio button',
              variant: HUFButtonVariant.outlined,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => RadioButtonsShowcasePage(
                      onToggleTheme: onToggleTheme,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            HUFButton(
              label: 'Slider',
              variant: HUFButtonVariant.secondary,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => SlidersShowcasePage(
                      onToggleTheme: onToggleTheme,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            HUFButton(
              label: 'Switch',
              variant: HUFButtonVariant.secondary,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => SwitchesShowcasePage(
                      onToggleTheme: onToggleTheme,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
