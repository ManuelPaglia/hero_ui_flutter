import 'package:flutter/material.dart';
import 'package:hero_ui_flutter/hero_ui_flutter.dart';

import '../example_app_scope.dart';
import 'showcase_shared.dart';

class BoxItemsShowcasePage extends StatefulWidget {
  const BoxItemsShowcasePage({super.key});

  @override
  State<BoxItemsShowcasePage> createState() => _BoxItemsShowcasePageState();
}

class _BoxItemsShowcasePageState extends State<BoxItemsShowcasePage> {
  bool _notifications = true;
  bool _checkbox = true;
  bool _switchOn = false;
  bool _radio = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ShowcaseAppBar(title: 'Box item / Box list'),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const ShowcaseSectionTitle('HUFBoxItem'),
          HUFBoxItem(
            title: 'Profilo',
            subtitle: 'Modifica nome, email e avatar',
            icon: const Icon(Icons.person_outline_rounded),
            highlighted: true,
            onTap: () {},
            action: const Icon(Icons.chevron_right_rounded),
          ),
          const SizedBox(height: 12),
          HUFBoxItem(
            title: 'Sicurezza',
            subtitle: 'Password e autenticazione a due fattori',
            icon: const Icon(Icons.lock_outline_rounded),
            onTap: () {},
            action: HUFChip(
              label: 'Attivo',
              size: HUFChipSize.small,
              variant: HUFChipVariant.outlined,
            ),
          ),
          const SizedBox(height: 32),
          const ShowcaseSectionTitle('HUFBoxList · separated'),
          HUFBoxList(
            children: [
              HUFBoxItem(
                title: 'Notifiche push',
                subtitle: 'Ricevi aggiornamenti in tempo reale',
                icon: const Icon(Icons.notifications_outlined),
                highlighted: _notifications,
                onTap: () => setState(() => _notifications = !_notifications),
                action: Icon(
                  _notifications
                      ? Icons.notifications_active_outlined
                      : Icons.notifications_off_outlined,
                ),
              ),
              HUFBoxItem(
                title: 'Lingua',
                subtitle: 'Italiano',
                icon: const Icon(Icons.language_outlined),
                onTap: () {},
                action: const Text('IT'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const ShowcaseSubsectionTitle('Mix control card'),
          HUFBoxList(
            children: [
              HUFCheckboxCard(
                title: 'Checkbox',
                value: _checkbox,
                onChanged: (v) => setState(() => _checkbox = v),
                icon: const Icon(Icons.check_box_outlined),
              ),
              HUFSwitchCard(
                title: 'Switch',
                value: _switchOn,
                onChanged: (v) => setState(() => _switchOn = v),
                icon: const Icon(Icons.toggle_on_outlined),
              ),
              HUFRadioButtonCard(
                title: 'Radio',
                value: _radio,
                onChanged: (v) => setState(() => _radio = v),
                icon: const Icon(Icons.radio_button_checked_outlined),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const ShowcaseSubsectionTitle('United · mix con separatori'),
          HUFBoxList(
            layout: HUFBoxListLayout.united,
            showSeparators: true,
            children: [
              HUFCheckboxCard(
                title: 'Email',
                subtitle: 'Aggiornamenti via email',
                value: _checkbox,
                onChanged: (v) => setState(() => _checkbox = v),
                icon: const Icon(Icons.mail_outline_rounded),
              ),
              HUFSwitchCard(
                title: 'Push',
                subtitle: 'Notifiche app',
                value: _switchOn,
                onChanged: (v) => setState(() => _switchOn = v),
                icon: const Icon(Icons.notifications_outlined),
              ),
              HUFRadioButtonCard(
                title: 'SMS',
                subtitle: 'Messaggi di testo',
                value: _radio,
                onChanged: (v) => setState(() => _radio = v),
                icon: const Icon(Icons.sms_outlined),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const ShowcaseSubsectionTitle('United · gruppo checkbox'),
          HUFCheckboxCardGroup<String>(
            layout: HUFBoxListLayout.united,
            showSeparators: false,
            initialValues: const {'daily'},
            onChanged: (_) {},
            children: const [
              HUFCheckboxCard(
                optionValue: 'daily',
                title: 'Giornaliero',
                icon: Icon(Icons.today_outlined),
              ),
              HUFCheckboxCard(
                optionValue: 'weekly',
                title: 'Settimanale',
                icon: Icon(Icons.date_range_outlined),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
