import 'package:flutter/material.dart';
import 'package:hero_ui_flutter/hero_ui_flutter.dart';

import '../example_app_scope.dart';
import 'avatars_showcase_page.dart';
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
    required this.page,
  });

  final String title;
  final String actionLabel;
  final Widget page;
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const _entries = [
    _HomeShowcaseEntry(
      title: 'Avatar',
      actionLabel: 'Apri',
      page: AvatarsShowcasePage(),
    ),
    _HomeShowcaseEntry(
      title: 'Chip',
      actionLabel: 'Apri',
      page: ChipsShowcasePage(),
    ),
    _HomeShowcaseEntry(
      title: 'Bottoni',
      actionLabel: 'Apri',
      page: ButtonsShowcasePage(),
    ),
    _HomeShowcaseEntry(
      title: 'Button group',
      actionLabel: 'Apri',
      page: ButtonGroupsShowcasePage(),
    ),
    _HomeShowcaseEntry(
      title: 'Checkbox',
      actionLabel: 'Apri',
      page: CheckboxesShowcasePage(),
    ),
    _HomeShowcaseEntry(
      title: 'Card',
      actionLabel: 'Apri',
      page: CardsShowcasePage(),
    ),
    _HomeShowcaseEntry(
      title: 'Checkbox card',
      actionLabel: 'Apri',
      page: CheckboxCardsShowcasePage(),
    ),
    _HomeShowcaseEntry(
      title: 'Radio button',
      actionLabel: 'Apri',
      page: RadioButtonsShowcasePage(),
    ),
    _HomeShowcaseEntry(
      title: 'Slider',
      actionLabel: 'Apri',
      page: SlidersShowcasePage(),
    ),
    _HomeShowcaseEntry(
      title: 'Switch',
      actionLabel: 'Apri',
      page: SwitchesShowcasePage(),
    ),
  ];

  void _openShowcase(BuildContext context, _HomeShowcaseEntry entry) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => entry.page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ShowcaseAppBar(title: 'Hero UI Flutter'),
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
      radiusSize: HUFCardRadiusSize.medium,
      title: entry.title,
      actions: [
        HUFButton(
          label: entry.actionLabel,
          variant: HUFButtonVariant.primary,
          size: HUFButtonSize.medium,
          onPressed: onOpen,
        ),
      ],
    );
  }
}
