import 'package:flutter/material.dart';
import 'package:hero_ui_flutter/hero_ui_flutter.dart';

import '../example_app_scope.dart';
import 'showcase_shared.dart';

class RadioButtonCardsShowcasePage extends StatefulWidget {
  const RadioButtonCardsShowcasePage({super.key});

  @override
  State<RadioButtonCardsShowcasePage> createState() =>
      _RadioButtonCardsShowcasePageState();
}

class _RadioButtonCardsShowcasePageState extends State<RadioButtonCardsShowcasePage> {
  String? _groupSelection = 'email';
  String? _planSelection = 'pro';
  bool _cardSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ShowcaseAppBar(title: 'Radio button card'),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const ShowcaseSectionTitle('Stati'),
          HUFRadioButtonCard(
            value: true,
            onChanged: (_) {},
            title: 'Selezionata',
            subtitle: 'Stato selezionato',
            icon: const Icon(Icons.mail_outline_rounded),
          ),
          const SizedBox(height: 12),
          HUFRadioButtonCard(
            value: false,
            onChanged: (_) {},
            title: 'Non selezionata',
            subtitle: 'Stato non selezionato',
            icon: const Icon(Icons.sms_outlined),
          ),
          const SizedBox(height: 12),
          HUFRadioButtonCard(
            value: true,
            onChanged: null,
            title: 'Disabilitata selezionata',
            subtitle: 'Stato disabilitato',
            icon: const Icon(Icons.notifications_outlined),
          ),
          const SizedBox(height: 12),
          HUFRadioButtonCard(
            value: false,
            onChanged: null,
            title: 'Disabilitata',
            icon: const Icon(Icons.notifications_off_outlined),
          ),
          const SizedBox(height: 24),
          const ShowcaseSectionTitle('Radio button card group'),
          const ShowcaseSubsectionTitle('Canale preferito'),
          HUFRadioButtonCardGroup<String>(
            initialValue: _groupSelection,
            onChanged: (value) => setState(() => _groupSelection = value),
            children: const [
              HUFRadioButtonCard(
                optionValue: 'email',
                title: 'Email',
                subtitle: 'Ricevi aggiornamenti via email',
                icon: Icon(Icons.mail_outline_rounded),
              ),
              HUFRadioButtonCard(
                optionValue: 'sms',
                title: 'SMS',
                subtitle: 'Messaggi di testo',
                icon: Icon(Icons.sms_outlined),
              ),
              HUFRadioButtonCard(
                optionValue: 'push',
                title: 'Push',
                subtitle: 'Notifiche app',
                icon: Icon(Icons.notifications_outlined),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Selezionato: ${_groupSelection ?? 'nessuno'}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          const SizedBox(height: 24),
          const ShowcaseSubsectionTitle('Piano di abbonamento'),
          HUFRadioButtonCardGroup<String>(
            initialValue: _planSelection,
            onChanged: (value) => setState(() => _planSelection = value),
            children: const [
              HUFRadioButtonCard(
                optionValue: 'basic',
                title: 'Basic',
                subtitle: 'Gratuito · funzionalità essenziali',
                icon: Icon(Icons.star_outline_rounded),
              ),
              HUFRadioButtonCard(
                optionValue: 'pro',
                title: 'Pro',
                subtitle: '€9.99/mese · tutte le funzionalità',
                icon: Icon(Icons.workspace_premium_outlined),
              ),
              HUFRadioButtonCard(
                optionValue: 'enterprise',
                title: 'Enterprise',
                subtitle: 'Contattaci · team e SLA',
                icon: Icon(Icons.business_outlined),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const ShowcaseSubsectionTitle('Layout united · con separatori'),
          HUFRadioButtonCardGroup<String>(
            layout: HUFControlCardLayout.united,
            showSeparators: true,
            initialValue: 'pro',
            onChanged: (_) {},
            children: const [
              HUFRadioButtonCard(
                optionValue: 'basic',
                title: 'Basic',
                subtitle: 'Gratuito',
                icon: Icon(Icons.star_outline_rounded),
              ),
              HUFRadioButtonCard(
                optionValue: 'pro',
                title: 'Pro',
                subtitle: '€9.99/mese',
                icon: Icon(Icons.workspace_premium_outlined),
              ),
              HUFRadioButtonCard(
                optionValue: 'enterprise',
                title: 'Enterprise',
                subtitle: 'Contattaci',
                icon: Icon(Icons.business_outlined),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const ShowcaseSubsectionTitle('Layout united · senza separatori'),
          HUFRadioButtonCardGroup<String>(
            layout: HUFControlCardLayout.united,
            showSeparators: false,
            initialValue: 'email',
            onChanged: (_) {},
            children: const [
              HUFRadioButtonCard(
                optionValue: 'email',
                title: 'Email',
                icon: Icon(Icons.mail_outline_rounded),
              ),
              HUFRadioButtonCard(
                optionValue: 'sms',
                title: 'SMS',
                icon: Icon(Icons.sms_outlined),
              ),
              HUFRadioButtonCard(
                optionValue: 'push',
                title: 'Push',
                icon: Icon(Icons.notifications_outlined),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const ShowcaseSectionTitle('Interattivi'),
          HUFRadioButtonCard(
            value: _cardSelected,
            onChanged: (v) => setState(() => _cardSelected = v),
            title: 'Accetto i termini',
            subtitle: 'Tocca la card per selezionare',
            icon: const Icon(Icons.gavel_outlined),
          ),
          const SizedBox(height: 24),
          const ShowcaseSubsectionTitle('Dimensioni'),
          for (final size in HUFRadioButtonSize.values) ...[
            HUFRadioButtonCard(
              value: true,
              onChanged: (_) {},
              size: size,
              title: _sizeLabel(size),
              subtitle: 'Sottotitolo opzionale',
              icon: const Icon(Icons.radio_button_checked_outlined),
            ),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 12),
          const ShowcaseSubsectionTitle('Override colori (widget)'),
          HUFRadioButtonCard(
            value: true,
            onChanged: (_) {},
            title: 'Viola custom',
            subtitle: 'activeColor personalizzato',
            icon: const Icon(Icons.palette_outlined),
            activeColor: const Color(0xFF7C3AED),
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
}
