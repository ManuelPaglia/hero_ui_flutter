import 'package:flutter/material.dart';
import 'package:hero_ui_flutter/hero_ui_flutter.dart';

import '../example_app_scope.dart';
import 'showcase_shared.dart';

class AccordionShowcasePage extends StatefulWidget {
  const AccordionShowcasePage({super.key});

  @override
  State<AccordionShowcasePage> createState() => _AccordionShowcasePageState();
}

class _AccordionShowcasePageState extends State<AccordionShowcasePage> {
  Set<String> _cardMultiExpanded = {'order'};
  Set<String> _ghostMultiExpanded = {'order'};
  Set<String> _singleExpanded = {'order'};
  bool _standaloneExpanded = false;

  static const _faqItems = [
    (
      id: 'order',
      title: 'How do I place an order?',
      leading: Icons.shopping_bag_outlined,
      content:
          'Browse our catalog, add items to your cart, and proceed to checkout. '
          'You can pay with credit card, PayPal, or other supported methods.',
    ),
    (
      id: 'modify',
      title: 'Can I modify or cancel my order?',
      leading: Icons.receipt_long_outlined,
      content:
          'Orders can be modified or cancelled within 30 minutes of placement. '
          'After that, contact support for assistance.',
    ),
    (
      id: 'payment',
      title: 'What payment methods do you accept?',
      leading: Icons.credit_card_outlined,
      content:
          'We accept Visa, Mastercard, American Express, PayPal, and Apple Pay.',
    ),
    (
      id: 'shipping',
      title: 'How long does shipping take?',
      leading: Icons.local_shipping_outlined,
      content:
          'Standard shipping takes 3–5 business days. Express options are available at checkout.',
    ),
    (
      id: 'returns',
      title: 'What is your return policy?',
      leading: Icons.replay_outlined,
      content:
          'Returns are accepted within 30 days of delivery. Items must be unused and in original packaging.',
    ),
    (
      id: 'support',
      title: 'How can I contact support?',
      leading: Icons.support_agent_outlined,
      content:
          'Reach us via email at support@example.com or through the live chat in the app.',
    ),
  ];

  List<HUFAccordionItem> _buildFaqItems() {
    return [
      for (final item in _faqItems)
        HUFAccordionItem(
          optionValue: item.id,
          title: item.title,
          leading: Icon(item.leading),
          content: Text(item.content),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ShowcaseAppBar(title: 'Accordion'),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const ShowcaseSectionTitle('Card'),
          const ShowcaseSubsectionTitle('Con separatori · multipli aperti'),
          HUFAccordion<String>(
            variant: HUFAccordionVariant.card,
            showSeparators: true,
            allowMultiple: true,
            expanded: _cardMultiExpanded,
            onExpansionChanged: (values) =>
                setState(() => _cardMultiExpanded = values),
            children: _buildFaqItems(),
          ),
          const SizedBox(height: 24),
          const ShowcaseSubsectionTitle('Senza separatori'),
          HUFAccordion<String>(
            variant: HUFAccordionVariant.card,
            showSeparators: false,
            initialExpanded: const {'order'},
            children: _buildFaqItems().take(3).toList(),
          ),
          const SizedBox(height: 24),
          const ShowcaseSubsectionTitle('Singolo aperto (allowMultiple: false)'),
          HUFAccordion<String>(
            variant: HUFAccordionVariant.card,
            showSeparators: true,
            allowMultiple: false,
            expanded: _singleExpanded,
            onExpansionChanged: (values) =>
                setState(() => _singleExpanded = values),
            children: _buildFaqItems().take(4).toList(),
          ),
          const SizedBox(height: 32),
          const ShowcaseSectionTitle('Ghost'),
          const ShowcaseSubsectionTitle('Con separatori · multipli aperti'),
          HUFAccordion<String>(
            variant: HUFAccordionVariant.ghost,
            showSeparators: true,
            allowMultiple: true,
            expanded: _ghostMultiExpanded,
            onExpansionChanged: (values) =>
                setState(() => _ghostMultiExpanded = values),
            children: _buildFaqItems(),
          ),
          const SizedBox(height: 24),
          const ShowcaseSubsectionTitle('Senza separatori'),
          HUFAccordion<String>(
            variant: HUFAccordionVariant.ghost,
            showSeparators: false,
            initialExpanded: const {'order'},
            children: _buildFaqItems().take(3).toList(),
          ),
          const SizedBox(height: 32),
          const ShowcaseSectionTitle('Icone personalizzate'),
          HUFAccordion<String>(
            variant: HUFAccordionVariant.card,
            showSeparators: true,
            children: [
              HUFAccordionItem(
                optionValue: 'plus',
                title: 'Using Plus/Minus Icon',
                expandIcon: const Icon(Icons.add),
                collapseIcon: const Icon(Icons.remove),
                content: const Text(
                  'Icone plus/minus personalizzate per questo item.',
                ),
              ),
              HUFAccordionItem(
                optionValue: 'caret',
                title: 'Using Caret Icon',
                expandIcon: Icon(Icons.expand_circle_down_outlined),
                collapseIcon: Icon(Icons.expand_circle_down),
                content: const Text(
                  'Icone caret in cerchio per questo item.',
                ),
              ),
              HUFAccordionItem(
                optionValue: 'arrow',
                title: 'Using Arrow Icon',
                expandIcon: const Icon(Icons.unfold_more),
                collapseIcon: const Icon(Icons.unfold_less),
                content: const Text(
                  'Icone freccia doppia per questo item.',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const ShowcaseSubsectionTitle('Icone di gruppo (chevron default)'),
          HUFAccordion<String>(
            variant: HUFAccordionVariant.card,
            showSeparators: true,
            expandIcon: const Icon(Icons.keyboard_arrow_down),
            collapseIcon: const Icon(Icons.keyboard_arrow_up),
            children: [
              HUFAccordionItem(
                optionValue: 'a',
                title: 'Item con icona di gruppo',
                content: const Text('Chevron condiviso dal gruppo.'),
              ),
              HUFAccordionItem(
                optionValue: 'b',
                title: 'Secondo item',
                content: const Text('Stesse icone del gruppo.'),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const ShowcaseSectionTitle('Uso singolo'),
          HUFAccordionItem(
            title: 'Item standalone',
            isExpanded: _standaloneExpanded,
            onExpansionChanged: (expanded) =>
                setState(() => _standaloneExpanded = expanded),
            leading: const Icon(Icons.help_outline),
            content: const Text(
              'Un singolo HUFAccordionItem fuori dal gruppo, con stato locale.',
            ),
          ),
        ],
      ),
    );
  }
}
