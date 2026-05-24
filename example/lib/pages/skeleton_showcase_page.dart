import 'package:flutter/material.dart';
import 'package:hero_ui_flutter/hero_ui_flutter.dart';

import '../example_app_scope.dart';
import 'showcase_shared.dart';

class SkeletonShowcasePage extends StatefulWidget {
  const SkeletonShowcasePage({super.key});

  @override
  State<SkeletonShowcasePage> createState() => _SkeletonShowcasePageState();
}

class _SkeletonShowcasePageState extends State<SkeletonShowcasePage> {
  bool _active = true;
  HUFSkeletonAnimation _animation = HUFSkeletonAnimation.shimmer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ShowcaseAppBar(title: 'Skeleton'),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Row(
            children: [
              Expanded(
                child: HUFButton(
                  label: _active ? 'Disattiva skeleton' : 'Attiva skeleton',
                  variant: HUFButtonVariant.primary,
                  onPressed: () => setState(() => _active = !_active),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const ShowcaseSectionTitle('Animazione'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final animation in HUFSkeletonAnimation.values)
                HUFButton(
                  label: animation.name,
                  size: HUFButtonSize.small,
                  variant: _animation == animation
                      ? HUFButtonVariant.primary
                      : HUFButtonVariant.outlined,
                  onPressed: () => setState(() => _animation = animation),
                ),
            ],
          ),
          const SizedBox(height: 24),
          HUFSkeleton(
            active: _active,
            animation: _animation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const ShowcaseSectionTitle('Avatar e chip'),
                const Row(
                  children: [
                    HUFAvatar(initials: 'AB'),
                    SizedBox(width: 12),
                    HUFAvatar(initials: 'CD', size: HUFAvatarSize.large),
                    SizedBox(width: 12),
                    HUFChip(label: 'Etichetta', icon: Icon(Icons.tag)),
                  ],
                ),
                const SizedBox(height: 12),
                HUFAvatarGroup(
                  children: const [
                    HUFAvatar(initials: 'A'),
                    HUFAvatar(initials: 'B'),
                    HUFAvatar(initials: 'C'),
                  ],
                ),
                const SizedBox(height: 32),
                const ShowcaseSectionTitle('Bottoni'),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    HUFButton(
                      label: 'Primary',
                      onPressed: () {},
                    ),
                    HUFButton.iconOnly(
                      icon: const Icon(Icons.settings),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                HUFButton(
                  label: 'Full width',
                  isFullWidth: true,
                  onPressed: () {},
                ),
                const SizedBox(height: 12),
                HUFButtonGroup(
                  items: [
                    HUFButtonGroupItem(label: 'Uno', onPressed: () {}),
                    HUFButtonGroupItem(label: 'Due', onPressed: () {}),
                    HUFButtonGroupItem(
                      icon: const Icon(Icons.more_horiz),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                const ShowcaseSectionTitle('Form'),
                const HUFInput(
                  label: 'Email',
                  hintText: 'nome@esempio.it',
                  isFullWidth: true,
                ),
                const SizedBox(height: 16),
                HUFSelect<String>(
                  label: 'Paese',
                  placeholder: 'Seleziona',
                  isFullWidth: true,
                  items: const [
                    HUFSelectItem(value: 'it', label: 'Italia'),
                    HUFSelectItem(value: 'fr', label: 'Francia'),
                  ],
                ),
                const SizedBox(height: 32),
                const ShowcaseSectionTitle('Controlli'),
                HUFCheckbox(
                  value: true,
                  onChanged: _noopBool,
                  label: 'Checkbox con label',
                ),
                const SizedBox(height: 12),
                HUFRadioButton(
                  value: true,
                  onChanged: _noopBool,
                  label: 'Radio con label',
                ),
                const SizedBox(height: 12),
                HUFSwitch(
                  value: true,
                  onChanged: _noopBool,
                  label: 'Switch con label',
                ),
                const SizedBox(height: 32),
                const ShowcaseSectionTitle('Progress e slider'),
                const HUFProgress(
                  label: 'Completamento',
                  value: 65,
                  showValue: true,
                ),
                const SizedBox(height: 16),
                HUFSlider(
                  label: 'Volume',
                  value: 40,
                  showValue: true,
                  onChanged: (_) {},
                ),
                const SizedBox(height: 32),
                const ShowcaseSectionTitle('Tabs e separatori'),
                const ShowcaseSubsectionTitle('Tabs full width'),
                HUFTabs<String>(
                  items: const [
                    HUFTabItem(label: 'Panoramica', value: 'overview'),
                    HUFTabItem(label: 'Dettagli', value: 'details'),
                    HUFTabItem(label: 'Impostazioni', value: 'settings'),
                  ],
                  initialValue: 'overview',
                ),
                const SizedBox(height: 16),
                const ShowcaseSubsectionTitle('Tabs larghezza contenuto'),
                HUFTabs<String>(
                  fullWidth: false,
                  items: const [
                    HUFTabItem(label: 'Panoramica', value: 'overview'),
                    HUFTabItem(label: 'Dettagli', value: 'details'),
                    HUFTabItem(label: 'Impostazioni', value: 'settings'),
                  ],
                  initialValue: 'overview',
                ),
                const SizedBox(height: 16),
                const HUFSeparator(),
                const SizedBox(height: 32),
                const ShowcaseSectionTitle('Card'),
                HUFCard(
                  title: 'Titolo card',
                  subtitle: 'Sottotitolo descrittivo',
                  content: const Text('Contenuto della card.'),
                  actions: [
                    HUFButton(
                      label: 'Azione',
                      variant: HUFButtonVariant.outlined,
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                HUFCheckboxCard(
                  title: 'Piano base',
                  subtitle: 'Per team piccoli',
                  value: true,
                  onChanged: _noopBool,
                ),
                const SizedBox(height: 12),
                HUFRadioButtonCard(
                  title: 'Piano pro',
                  subtitle: 'Per team in crescita',
                  value: false,
                  onChanged: _noopBool,
                ),
                const SizedBox(height: 12),
                HUFSwitchCard(
                  title: 'Notifiche',
                  subtitle: 'Email e push',
                  value: true,
                  onChanged: _noopBool,
                ),
                const SizedBox(height: 32),
                const ShowcaseSectionTitle('Accordion'),
                HUFAccordion<String>(
                  initialExpanded: const {'one'},
                  children: [
                    HUFAccordionItem(
                      optionValue: 'one',
                      title: 'Sezione uno',
                      content: const Text('Contenuto espandibile.'),
                    ),
                    HUFAccordionItem(
                      optionValue: 'two',
                      title: 'Sezione due',
                      content: const Text('Altro contenuto.'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void _noopBool(bool _) {}
