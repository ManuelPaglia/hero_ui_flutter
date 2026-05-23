import 'package:flutter/material.dart';
import 'package:hero_ui_flutter/hero_ui_flutter.dart';

import '../example_app_scope.dart';
import 'showcase_shared.dart';

class SwitchCardsShowcasePage extends StatefulWidget {
  const SwitchCardsShowcasePage({super.key});

  @override
  State<SwitchCardsShowcasePage> createState() => _SwitchCardsShowcasePageState();
}

class _SwitchCardsShowcasePageState extends State<SwitchCardsShowcasePage> {
  Set<String> _groupActive = {'email'};
  bool _cardEmail = true;
  bool _cardSms = false;
  bool _cardCustom = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ShowcaseAppBar(title: 'Switch card'),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const ShowcaseSectionTitle('Stati'),
          HUFSwitchCard(
            value: true,
            onChanged: (_) {},
            title: 'Attiva',
            subtitle: 'Switch acceso',
            icon: const Icon(Icons.mail_outline_rounded),
          ),
          const SizedBox(height: 12),
          HUFSwitchCard(
            value: false,
            onChanged: (_) {},
            title: 'Spenta',
            subtitle: 'Switch spento',
            icon: const Icon(Icons.sms_outlined),
          ),
          const SizedBox(height: 12),
          HUFSwitchCard(
            value: true,
            onChanged: null,
            title: 'Disabilitata attiva',
            subtitle: 'Stato disabilitato',
            icon: const Icon(Icons.notifications_outlined),
          ),
          const SizedBox(height: 12),
          HUFSwitchCard(
            value: false,
            onChanged: null,
            title: 'Disabilitata',
            icon: const Icon(Icons.notifications_off_outlined),
          ),
          const SizedBox(height: 24),
          const ShowcaseSectionTitle('Switch card group'),
          const ShowcaseSubsectionTitle('Preferenze notifiche'),
          HUFSwitchCardGroup<String>(
            initialValues: _groupActive,
            onChanged: (values) => setState(() => _groupActive = values),
            children: const [
              HUFSwitchCard(
                optionValue: 'email',
                title: 'Email Notifications',
                subtitle: 'Receive updates via email',
                icon: Icon(Icons.mail_outline_rounded),
              ),
              HUFSwitchCard(
                optionValue: 'sms',
                title: 'SMS Notifications',
                subtitle: 'Get text message alerts',
                icon: Icon(Icons.sms_outlined),
              ),
              HUFSwitchCard(
                optionValue: 'push',
                title: 'Push Notifications',
                subtitle: 'Receive mobile app notifications',
                icon: Icon(Icons.notifications_outlined),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Attive: ${_groupActive.join(', ')}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          const SizedBox(height: 24),
          const ShowcaseSubsectionTitle('Layout united · con separatori'),
          HUFSwitchCardGroup<String>(
            layout: HUFControlCardLayout.united,
            showSeparators: true,
            initialValues: const {'email'},
            onChanged: (_) {},
            children: const [
              HUFSwitchCard(
                optionValue: 'email',
                title: 'Email Notifications',
                subtitle: 'Receive updates via email',
                icon: Icon(Icons.mail_outline_rounded),
              ),
              HUFSwitchCard(
                optionValue: 'sms',
                title: 'SMS Notifications',
                subtitle: 'Get text message alerts',
                icon: Icon(Icons.sms_outlined),
              ),
              HUFSwitchCard(
                optionValue: 'push',
                title: 'Push Notifications',
                subtitle: 'Receive mobile app notifications',
                icon: Icon(Icons.notifications_outlined),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const ShowcaseSubsectionTitle('Layout united · senza separatori'),
          HUFSwitchCardGroup<String>(
            layout: HUFControlCardLayout.united,
            showSeparators: false,
            initialValues: const {'email'},
            onChanged: (_) {},
            children: const [
              HUFSwitchCard(
                optionValue: 'email',
                title: 'Email Notifications',
                icon: Icon(Icons.mail_outline_rounded),
              ),
              HUFSwitchCard(
                optionValue: 'sms',
                title: 'SMS Notifications',
                icon: Icon(Icons.sms_outlined),
              ),
              HUFSwitchCard(
                optionValue: 'push',
                title: 'Push Notifications',
                icon: Icon(Icons.notifications_outlined),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const ShowcaseSectionTitle('Interattivi'),
          HUFSwitchCard(
            value: _cardEmail,
            onChanged: (v) => setState(() => _cardEmail = v),
            title: 'Email Notifications',
            subtitle: 'Receive updates via email',
            icon: const Icon(Icons.mail_outline_rounded),
          ),
          const SizedBox(height: 12),
          HUFSwitchCard(
            value: _cardSms,
            onChanged: (v) => setState(() => _cardSms = v),
            title: 'SMS Notifications',
            icon: const Icon(Icons.sms_outlined),
          ),
          const SizedBox(height: 24),
          const ShowcaseSubsectionTitle('Dimensioni'),
          for (final size in HUFSwitchSize.values) ...[
            HUFSwitchCard(
              value: true,
              onChanged: (_) {},
              size: size,
              title: _sizeLabel(size),
              subtitle: 'Sottotitolo opzionale',
              icon: const Icon(Icons.toggle_on_outlined),
            ),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 12),
          const ShowcaseSubsectionTitle('Override colori (widget)'),
          HUFSwitchCard(
            value: _cardCustom,
            onChanged: (v) => setState(() => _cardCustom = v),
            title: 'Verde custom',
            subtitle: 'activeColor personalizzato',
            icon: const Icon(Icons.eco_outlined),
            activeColor: const Color(0xFF059669),
          ),
          const SizedBox(height: 24),
          const ShowcaseSubsectionTitle('Icona nel thumb'),
          HUFSwitchCard(
            value: true,
            onChanged: (_) {},
            title: 'Modalità scura',
            subtitle: 'switchIcon nel thumb',
            icon: const Icon(Icons.dark_mode_outlined),
            switchIcon: const Icon(Icons.dark_mode, size: 14),
          ),
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
}
