import 'package:flutter/material.dart';
import 'package:hero_ui_flutter/hero_ui_flutter.dart';

import 'showcase_shared.dart';

class CheckboxCardsShowcasePage extends StatefulWidget {
  const CheckboxCardsShowcasePage({
    required this.onToggleTheme,
    super.key,
  });

  final VoidCallback onToggleTheme;

  @override
  State<CheckboxCardsShowcasePage> createState() => _CheckboxCardsShowcasePageState();
}

class _CheckboxCardsShowcasePageState extends State<CheckboxCardsShowcasePage> {
  Set<String> _groupSelection = {'email'};
  Set<String> _singleSelection = {};
  bool _cardEmail = true;
  bool _cardSms = false;
  bool _cardCustom = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkbox card'),
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
          for (final radiusEntry in showcaseRadiusPresets.entries) ...[
            ShowcaseSectionTitle('Radius · ${radiusEntry.key}'),
            ShowcaseThemeScope(
              borderRadius: radiusEntry.value,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  HUFCheckboxCard(
                    value: true,
                    onChanged: (_) {},
                    title: 'Selezionata',
                    subtitle: 'Stato selezionato',
                    icon: const Icon(Icons.mail_outline_rounded),
                  ),
                  const SizedBox(height: 12),
                  HUFCheckboxCard(
                    value: false,
                    onChanged: (_) {},
                    title: 'Non selezionata',
                    subtitle: 'Stato non selezionato',
                    icon: const Icon(Icons.sms_outlined),
                  ),
                  const SizedBox(height: 12),
                  HUFCheckboxCard(
                    value: true,
                    onChanged: null,
                    title: 'Disabilitata selezionata',
                    subtitle: 'Stato disabilitato',
                    icon: const Icon(Icons.notifications_outlined),
                  ),
                  const SizedBox(height: 12),
                  HUFCheckboxCard(
                    value: false,
                    onChanged: null,
                    title: 'Disabilitata',
                    icon: const Icon(Icons.notifications_off_outlined),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
          const ShowcaseSectionTitle('Checkbox card group'),
          const ShowcaseSubsectionTitle('Notification preferences'),
          Text(
            'Choose how you want to receive updates',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(
                        alpha: 0.65,
                      ),
                ),
          ),
          const SizedBox(height: 16),
          const ShowcaseSubsectionTitle('Selezione multipla'),
          HUFCheckboxCardGroup<String>(
            initialValues: _groupSelection,
            onChanged: (values) => setState(() => _groupSelection = values),
            children: const [
              HUFCheckboxCard(
                optionValue: 'email',
                title: 'Email Notifications',
                subtitle: 'Receive updates via email',
                icon: Icon(Icons.mail_outline_rounded),
              ),
              HUFCheckboxCard(
                optionValue: 'sms',
                title: 'SMS Notifications',
                subtitle: 'Get text message alerts',
                icon: Icon(Icons.sms_outlined),
              ),
              HUFCheckboxCard(
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
              'Selezionati: ${_groupSelection.join(', ')}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          const SizedBox(height: 20),
          const ShowcaseSubsectionTitle('Selezione singola'),
          HUFCheckboxCardGroup<String>(
            multiSelect: false,
            initialValues: _singleSelection,
            onChanged: (values) => setState(() => _singleSelection = values),
            children: const [
              HUFCheckboxCard(
                optionValue: 'daily',
                title: 'Giornaliero',
                subtitle: 'Un riepilogo al giorno',
                icon: Icon(Icons.today_outlined),
              ),
              HUFCheckboxCard(
                optionValue: 'weekly',
                title: 'Settimanale',
                subtitle: 'Un riepilogo a settimana',
                icon: Icon(Icons.date_range_outlined),
              ),
              HUFCheckboxCard(
                optionValue: 'monthly',
                title: 'Mensile',
                subtitle: 'Un riepilogo al mese',
                icon: Icon(Icons.calendar_month_outlined),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              _singleSelection.isEmpty
                  ? 'Nessuna frequenza selezionata'
                  : 'Frequenza: ${_singleSelection.first}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          const SizedBox(height: 32),
          const ShowcaseSectionTitle('Interattivi'),
          HUFCheckboxCard(
            value: _cardEmail,
            onChanged: (v) => setState(() => _cardEmail = v),
            title: 'Email Notifications',
            subtitle: 'Receive updates via email',
            icon: const Icon(Icons.mail_outline_rounded),
          ),
          const SizedBox(height: 12),
          HUFCheckboxCard(
            value: _cardSms,
            onChanged: (v) => setState(() => _cardSms = v),
            title: 'SMS Notifications',
            icon: const Icon(Icons.sms_outlined),
          ),
          const SizedBox(height: 24),
          const ShowcaseSubsectionTitle('Dimensioni'),
          for (final size in HUFCheckboxSize.values) ...[
            HUFCheckboxCard(
              value: true,
              onChanged: (_) {},
              size: size,
              title: _sizeLabel(size),
              subtitle: 'Sottotitolo opzionale',
              icon: const Icon(Icons.check_circle_outline),
            ),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 12),
          const ShowcaseSubsectionTitle('Override colori (widget)'),
          HUFCheckboxCard(
            value: _cardCustom,
            onChanged: (v) => setState(() => _cardCustom = v),
            title: 'Verde custom',
            subtitle: 'activeColor e checkColor personalizzati',
            icon: const Icon(Icons.eco_outlined),
            activeColor: const Color(0xFF059669),
            checkColor: Colors.white,
            borderColor: const Color(0xFF059669),
          ),
          const SizedBox(height: 24),
          const ShowcaseSubsectionTitle('Icone checkbox custom'),
          HUFCheckboxCard(
            value: true,
            onChanged: (_) {},
            title: 'Preferiti',
            subtitle: 'checkedIcon personalizzata',
            icon: const Icon(Icons.bookmark_outline),
            checkedIcon: const Icon(Icons.favorite),
          ),
          const SizedBox(height: 12),
          HUFCheckboxCard(
            value: false,
            onChanged: (_) {},
            title: 'Toggle cuore',
            subtitle: 'checkedIcon e uncheckedIcon',
            icon: const Icon(Icons.bookmark_outline),
            uncheckedIcon: const Icon(Icons.favorite_border),
            checkedIcon: const Icon(Icons.favorite),
          ),
          const SizedBox(height: 12),
          HUFCheckboxCard(
            value: true,
            onChanged: (_) {},
            title: 'Stella',
            checkedIcon: const Icon(Icons.star_rounded),
          ),
        ],
      ),
    );
  }

  String _sizeLabel(HUFCheckboxSize size) {
    return switch (size) {
      HUFCheckboxSize.small => 'Small',
      HUFCheckboxSize.medium => 'Medium',
      HUFCheckboxSize.large => 'Large',
    };
  }
}
