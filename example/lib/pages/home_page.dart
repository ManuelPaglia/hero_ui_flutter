import 'package:flutter/material.dart';
import 'package:hero_ui_flutter/hero_ui_flutter.dart';

import 'button_groups_showcase_page.dart';
import 'buttons_showcase_page.dart';
import 'chips_showcase_page.dart';
import 'cards_showcase_page.dart';
import 'checkbox_cards_showcase_page.dart';
import 'checkboxes_showcase_page.dart';
import 'radio_buttons_showcase_page.dart';
import 'sliders_showcase_page.dart';
import 'switches_showcase_page.dart';

class _HomeShowcaseEntry {
  const _HomeShowcaseEntry({
    required this.title,
    required this.actionLabel,
    required this.pageBuilder,
  });

  final String title;
  final String actionLabel;
  final Widget Function(VoidCallback onToggleTheme) pageBuilder;
}

class HomePage extends StatelessWidget {
  const HomePage({
    required this.onToggleTheme,
    super.key,
  });

  final VoidCallback onToggleTheme;

  static const _entries = [
    _HomeShowcaseEntry(
      title: 'Chip',
      actionLabel: 'Apri',
      pageBuilder: _chipsPage,
    ),
    _HomeShowcaseEntry(
      title: 'Bottoni',
      actionLabel: 'Apri',
      pageBuilder: _buttonsPage,
    ),
    _HomeShowcaseEntry(
      title: 'Button group',
      actionLabel: 'Apri',
      pageBuilder: _buttonGroupsPage,
    ),
    _HomeShowcaseEntry(
      title: 'Checkbox',
      actionLabel: 'Apri',
      pageBuilder: _checkboxesPage,
    ),
    _HomeShowcaseEntry(
      title: 'Card',
      actionLabel: 'Apri',
      pageBuilder: _cardsPage,
    ),
    _HomeShowcaseEntry(
      title: 'Checkbox card',
      actionLabel: 'Apri',
      pageBuilder: _checkboxCardsPage,
    ),
    _HomeShowcaseEntry(
      title: 'Radio button',
      actionLabel: 'Apri',
      pageBuilder: _radioButtonsPage,
    ),
    _HomeShowcaseEntry(
      title: 'Slider',
      actionLabel: 'Apri',
      pageBuilder: _slidersPage,
    ),
    _HomeShowcaseEntry(
      title: 'Switch',
      actionLabel: 'Apri',
      pageBuilder: _switchesPage,
    ),
  ];

  static Widget _chipsPage(VoidCallback onToggleTheme) =>
      ChipsShowcasePage(onToggleTheme: onToggleTheme);

  static Widget _buttonsPage(VoidCallback onToggleTheme) =>
      ButtonsShowcasePage(onToggleTheme: onToggleTheme);

  static Widget _buttonGroupsPage(VoidCallback onToggleTheme) =>
      ButtonGroupsShowcasePage(onToggleTheme: onToggleTheme);

  static Widget _checkboxesPage(VoidCallback onToggleTheme) =>
      CheckboxesShowcasePage(onToggleTheme: onToggleTheme);

  static Widget _cardsPage(VoidCallback onToggleTheme) =>
      CardsShowcasePage(onToggleTheme: onToggleTheme);

  static Widget _checkboxCardsPage(VoidCallback onToggleTheme) =>
      CheckboxCardsShowcasePage(onToggleTheme: onToggleTheme);

  static Widget _radioButtonsPage(VoidCallback onToggleTheme) =>
      RadioButtonsShowcasePage(onToggleTheme: onToggleTheme);

  static Widget _slidersPage(VoidCallback onToggleTheme) =>
      SlidersShowcasePage(onToggleTheme: onToggleTheme);

  static Widget _switchesPage(VoidCallback onToggleTheme) =>
      SwitchesShowcasePage(onToggleTheme: onToggleTheme);

  void _openShowcase(BuildContext context, _HomeShowcaseEntry entry) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => entry.pageBuilder(onToggleTheme),
      ),
    );
  }

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
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Componenti',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),
          for (var i = 0; i < _entries.length; i += 2) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _HomeShowcaseCard(
                    entry: _entries[i],
                    onOpen: () => _openShowcase(context, _entries[i]),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: i + 1 < _entries.length
                      ? _HomeShowcaseCard(
                          entry: _entries[i + 1],
                          onOpen: () =>
                              _openShowcase(context, _entries[i + 1]),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
            if (i + 2 < _entries.length) const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}

class _HomeShowcaseCard extends StatelessWidget {
  const _HomeShowcaseCard({
    required this.entry,
    required this.onOpen,
  });

  final _HomeShowcaseEntry entry;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return HUFCard(
      style: HUFCardStyle.card,
      radiusSize: HUFCardRadiusSize.small,
      title: entry.title,
      actions: [
        HUFButton(
          label: entry.actionLabel,
          variant: HUFButtonVariant.primary,
          size: HUFButtonSize.small,
          onPressed: onOpen,
        ),
      ],
    );
  }
}
