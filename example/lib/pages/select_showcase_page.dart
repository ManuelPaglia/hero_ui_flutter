import 'package:flutter/material.dart';
import 'package:hero_ui_flutter/hero_ui_flutter.dart';

import '../example_app_scope.dart';
import 'showcase_shared.dart';

class SelectShowcasePage extends StatelessWidget {
  const SelectShowcasePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ShowcaseAppBar(title: 'Select'),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: const [
          ShowcaseSubsectionTitle('Full width'),
          _StateSelectDemo(),
          SizedBox(height: 32),
          ShowcaseSubsectionTitle('Con ricerca (search)'),
          _SearchableSelectDemo(),
          SizedBox(height: 32),
          ShowcaseSubsectionTitle('Sezioni'),
          _CountrySelectDemo(),
          SizedBox(height: 32),
          ShowcaseSubsectionTitle('Larghezza contenuto'),
          _ContentWidthSelectDemo(),
          SizedBox(height: 32),
          ShowcaseSubsectionTitle('Multipla'),
          _MultiCountrySelectDemo(),
          SizedBox(height: 32),
          ShowcaseSubsectionTitle('Voci con avatar'),
          _UserSelectDemo(),
        ],
      ),
    );
  }
}

class _SearchableSelectDemo extends StatefulWidget {
  const _SearchableSelectDemo();

  @override
  State<_SearchableSelectDemo> createState() => _SearchableSelectDemoState();
}

class _SearchableSelectDemoState extends State<_SearchableSelectDemo> {
  String? _value;

  static const _states = [
    HUFSelectItem(value: 'fl', label: 'Florida'),
    HUFSelectItem(value: 'de', label: 'Delaware'),
    HUFSelectItem(value: 'ca', label: 'California'),
    HUFSelectItem(value: 'tx', label: 'Texas'),
    HUFSelectItem(value: 'ny', label: 'New York'),
    HUFSelectItem(value: 'wa', label: 'Washington'),
  ];

  @override
  Widget build(BuildContext context) {
    return HUFSelect<String>(
      label: 'State',
      hintText: 'Cerca o seleziona uno stato',
      search: true,
      isFullWidth: true,
      items: _states,
      value: _value,
      onChanged: (v) => setState(() => _value = v),
    );
  }
}

class _StateSelectDemo extends StatefulWidget {
  const _StateSelectDemo();

  @override
  State<_StateSelectDemo> createState() => _StateSelectDemoState();
}

class _StateSelectDemoState extends State<_StateSelectDemo> {
  String? _value;

  static const _states = [
    HUFSelectItem(value: 'fl', label: 'Florida'),
    HUFSelectItem(value: 'de', label: 'Delaware'),
    HUFSelectItem(value: 'ca', label: 'California'),
    HUFSelectItem(value: 'tx', label: 'Texas'),
    HUFSelectItem(value: 'ny', label: 'New York'),
    HUFSelectItem(value: 'wa', label: 'Washington'),
  ];

  @override
  Widget build(BuildContext context) {
    return HUFSelect<String>(
      label: 'State',
      hintText: 'Select one',
      isFullWidth: true,
      items: _states,
      value: _value,
      onChanged: (v) => setState(() => _value = v),
    );
  }
}

class _CountrySelectDemo extends StatefulWidget {
  const _CountrySelectDemo();

  @override
  State<_CountrySelectDemo> createState() => _CountrySelectDemoState();
}

class _CountrySelectDemoState extends State<_CountrySelectDemo> {
  String? _value;

  static final _sections = <HUFSelectSection<String>>[
    const HUFSelectSection<String>(
      header: 'North America',
      items: [
        HUFSelectItem(value: 'us', label: 'United States'),
        HUFSelectItem(value: 'ca', label: 'Canada'),
        HUFSelectItem(value: 'mx', label: 'Mexico'),
      ],
    ),
    const HUFSelectSection<String>(
      header: 'Europe',
      showSeparatorBefore: true,
      items: [
        HUFSelectItem(value: 'uk', label: 'United Kingdom'),
        HUFSelectItem(value: 'fr', label: 'France'),
        HUFSelectItem(value: 'de', label: 'Germany'),
        HUFSelectItem(value: 'es', label: 'Spain'),
        HUFSelectItem(value: 'it', label: 'Italy'),
      ],
    ),
    const HUFSelectSection<String>(
      header: 'Asia',
      showSeparatorBefore: true,
      items: [
        HUFSelectItem(value: 'jp', label: 'Japan'),
        HUFSelectItem(value: 'cn', label: 'China'),
        HUFSelectItem(value: 'in', label: 'India'),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return HUFSelect<String>(
      label: 'Country',
      hintText: 'Select a country',
      isFullWidth: true,
      sections: _sections,
      value: _value,
      onChanged: (v) => setState(() => _value = v),
    );
  }
}

class _ContentWidthSelectDemo extends StatefulWidget {
  const _ContentWidthSelectDemo();

  @override
  State<_ContentWidthSelectDemo> createState() => _ContentWidthSelectDemoState();
}

class _ContentWidthSelectDemoState extends State<_ContentWidthSelectDemo> {
  String? _value;

  static const _items = [
    HUFSelectItem(value: 'a', label: 'Opzione A'),
    HUFSelectItem(value: 'b', label: 'Opzione B'),
    HUFSelectItem(value: 'c', label: 'Opzione C'),
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        HUFSelect<String>(
          label: 'Compatto',
          hintText: 'Scegli',
          items: _items,
          value: _value,
          onChanged: (v) => setState(() => _value = v),
        ),
        HUFSelect<String>(
          hintText: 'Senza label',
          items: _items,
          value: _value,
          onChanged: (v) => setState(() => _value = v),
        ),
      ],
    );
  }
}

class _MultiCountrySelectDemo extends StatefulWidget {
  const _MultiCountrySelectDemo();

  @override
  State<_MultiCountrySelectDemo> createState() => _MultiCountrySelectDemoState();
}

class _MultiCountrySelectDemoState extends State<_MultiCountrySelectDemo> {
  Set<String> _values = {'nz', 'es'};

  static const _countries = [
    HUFSelectItem(value: 'ar', label: 'Argentina'),
    HUFSelectItem(value: 've', label: 'Venezuela'),
    HUFSelectItem(value: 'jp', label: 'Japan'),
    HUFSelectItem(value: 'nz', label: 'New Zealand'),
    HUFSelectItem(value: 'es', label: 'Spain'),
    HUFSelectItem(value: 'br', label: 'Brazil'),
    HUFSelectItem(value: 'us', label: 'United States'),
    HUFSelectItem(value: 'fr', label: 'France'),
  ];

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: HUFSelect<String>(
        label: 'Countries',
        hintText: 'Select countries',
        isFullWidth: true,
        items: _countries,
        multiSelect: true,
        values: _values,
        onMultiChanged: (v) => setState(() => _values = v),
        placement: HUFSelectPlacement.top,
      ),
    );
  }
}

class _UserSelectDemo extends StatefulWidget {
  const _UserSelectDemo();

  @override
  State<_UserSelectDemo> createState() => _UserSelectDemoState();
}

class _UserSelectDemoState extends State<_UserSelectDemo> {
  String? _value;

  static final _users = [
    (
      id: 'bob',
      name: 'Bob',
      email: 'bob@heroui.com',
      initials: 'BO',
      color: HUFAvatarColor.accent,
    ),
    (
      id: 'fred',
      name: 'Fred',
      email: 'fred@heroui.com',
      initials: 'FR',
      color: HUFAvatarColor.success,
    ),
    (
      id: 'martha',
      name: 'Martha',
      email: 'martha@heroui.com',
      initials: 'MA',
      color: HUFAvatarColor.warning,
    ),
    (
      id: 'john',
      name: 'John',
      email: 'john@heroui.com',
      initials: 'JO',
      color: HUFAvatarColor.danger,
    ),
    (
      id: 'jane',
      name: 'Jane',
      email: 'jane@heroui.com',
      initials: 'JA',
      color: HUFAvatarColor.defaultColor,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: HUFSelect<String>(
        label: 'Team member',
        hintText: 'Select a user',
        isFullWidth: true,
        items: [
          for (final user in _users)
            HUFSelectItem(
              value: user.id,
              label: user.name,
              subtitle: user.email,
              leading: HUFAvatar(
                initials: user.initials,
                color: user.color,
                size: HUFAvatarSize.small,
              ),
            ),
        ],
        value: _value,
        onChanged: (v) => setState(() => _value = v),
        placement: HUFSelectPlacement.top,
      ),
    );
  }
}
