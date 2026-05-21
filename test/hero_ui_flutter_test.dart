import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hero_ui_flutter/hero_ui_flutter.dart';

Widget _wrap(Widget child, {HUFTheme? theme}) {
  final huf = theme ?? HUFTheme.light();
  return MaterialApp(
    theme: huf.toThemeData(),
    home: Scaffold(body: child),
  );
}

void main() {
  testWidgets('HUFButton mostra la label e risponde al tap', (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      _wrap(
        HUFButton(
          label: 'Continua',
          onPressed: () => tapped = true,
        ),
      ),
    );

    expect(find.text('Continua'), findsOneWidget);

    await tester.tap(find.text('Continua'));
    await tester.pump();

    expect(tapped, isTrue);
  });

  testWidgets('HUFButton senza isFullWidth non espande lo sfondo', (
    tester,
  ) async {
    const parentWidth = 400.0;

    await tester.pumpWidget(
      _wrap(
        SizedBox(
          width: parentWidth,
          child: Column(
            children: [
              HUFButton(label: 'Compatto', onPressed: () {}),
            ],
          ),
        ),
      ),
    );

    final backgroundWidth = tester.getSize(_buttonBackgroundFinder()).width;
    expect(backgroundWidth, lessThan(parentWidth));
    expect(backgroundWidth, greaterThan(0));
  });

  testWidgets('HUFButton in ListView non espande lo sfondo senza isFullWidth', (
    tester,
  ) async {
    const parentWidth = 400.0;

    await tester.pumpWidget(
      _wrap(
        SizedBox(
          width: parentWidth,
          height: 200,
          child: ListView(
            children: [
              HUFButton(
                label: 'Primary · Medium',
                icon: const Icon(Icons.arrow_forward),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );

    final backgroundWidth = tester.getSize(_buttonBackgroundFinder()).width;
    expect(backgroundWidth, lessThan(parentWidth));
    expect(backgroundWidth, greaterThan(0));
  });

  testWidgets('HUFButton con isFullWidth occupa tutta la larghezza', (
    tester,
  ) async {
    const parentWidth = 400.0;

    await tester.pumpWidget(
      _wrap(
        SizedBox(
          width: parentWidth,
          child: Column(
            children: [
              HUFButton(
                label: 'Largo',
                isFullWidth: true,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );

    expect(
      tester.getSize(find.byType(HUFButton)).width,
      parentWidth,
    );
  });

  testWidgets('HUFButton disabilitato non invoca onPressed', (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      _wrap(
        HUFButton(
          label: 'Disabilitato',
          onPressed: null,
        ),
      ),
    );

    await tester.tap(find.text('Disabilitato'));
    await tester.pump();

    expect(tapped, isFalse);
  });

  testWidgets('HUFButton in loading mostra lo spinner', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const HUFButton(
          label: 'Caricamento',
          isLoading: true,
          onPressed: _noop,
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('iconOnly ha dimensioni uniformi tra le varianti', (tester) async {
    await tester.pumpWidget(
      _wrap(
        Wrap(
          children: [
            HUFButton.iconOnly(icon: const Icon(Icons.add), onPressed: () {}),
            HUFButton.iconOnly(
              icon: const Icon(Icons.favorite_border),
              variant: HUFButtonVariant.dangerSoft,
              onPressed: () {},
            ),
            const HUFButton.iconOnly(
              icon: Icon(Icons.lock_outline),
              onPressed: null,
            ),
            HUFButton.iconOnly(
              icon: const Icon(Icons.settings_outlined),
              variant: HUFButtonVariant.outlined,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );

    final containers = tester
        .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
        .toList();

    expect(containers.length, 4);
    for (final container in containers) {
      expect(container.constraints?.maxWidth, 44);
      expect(container.constraints?.maxHeight, 44);
    }
  });

  testWidgets('HUFButton.iconOnly mostra solo l\'icona', (tester) async {
    await tester.pumpWidget(
      _wrap(
        HUFButton.iconOnly(
          icon: const Icon(Icons.add),
          variant: HUFButtonVariant.danger,
          onPressed: () {},
        ),
      ),
    );

    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.byType(Text), findsNothing);
  });

  testWidgets('primary e danger hanno ombra glowing', (tester) async {
    await tester.pumpWidget(
      _wrap(
        Column(
          children: [
            HUFButton(label: 'Primary', onPressed: () {}),
            HUFButton(
              label: 'Danger',
              variant: HUFButtonVariant.danger,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );

    final containers = tester.widgetList<AnimatedContainer>(
      find.byType(AnimatedContainer),
    );

    final withGlow = containers.where((c) {
      final decoration = c.decoration as BoxDecoration?;
      return decoration?.boxShadow?.isNotEmpty ?? false;
    });

    expect(withGlow.length, 2);
  });

  testWidgets('outlined ha bordo, ghost no', (tester) async {
    await tester.pumpWidget(
      _wrap(
        Column(
          children: [
            HUFButton(
              label: 'Outlined',
              variant: HUFButtonVariant.outlined,
              onPressed: () {},
            ),
            HUFButton(
              label: 'Ghost',
              variant: HUFButtonVariant.ghost,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );

    BoxDecoration decorationFor(String label) {
      final container = tester.widget<AnimatedContainer>(
        find.descendant(
          of: find.widgetWithText(HUFButton, label),
          matching: find.byType(AnimatedContainer),
        ),
      );
      return container.decoration! as BoxDecoration;
    }

    expect(decorationFor('Outlined').border, isNotNull);
    expect(decorationFor('Ghost').border, isNull);
  });

  testWidgets('iconOnly usa il border radius del tema', (tester) async {
    const small = HUFBorderRadius.small;

    await tester.pumpWidget(
      _wrap(
        HUFButton.iconOnly(
          icon: const Icon(Icons.add),
          onPressed: () {},
        ),
        theme: HUFTheme.light(borderRadius: small),
      ),
    );

    final container = tester.widget<AnimatedContainer>(
      find.descendant(
        of: find.byType(HUFButton),
        matching: find.byType(AnimatedContainer),
      ),
    );
    final decoration = container.decoration! as BoxDecoration;
    final radius = decoration.borderRadius! as BorderRadius;

    expect(radius.topLeft.x, small.value);
  });

  testWidgets('variante danger usa i colori del tema', (tester) async {
    final theme = HUFTheme.light();

    await tester.pumpWidget(
      _wrap(
        HUFButton(
          label: 'Elimina',
          variant: HUFButtonVariant.danger,
          onPressed: () {},
        ),
        theme: theme,
      ),
    );

    final container = tester.widget<AnimatedContainer>(
      find.descendant(
        of: find.byType(HUFButton),
        matching: find.byType(AnimatedContainer),
      ),
    );

    final decoration = container.decoration! as BoxDecoration;
    expect(decoration.color, theme.colors.danger);
  });

  testWidgets('dark mode applica la palette scura', (tester) async {
    final theme = HUFTheme.dark();

    await tester.pumpWidget(
      _wrap(
        HUFButton(
          label: 'Primary',
          onPressed: () {},
        ),
        theme: theme,
      ),
    );

    final container = tester.widget<AnimatedContainer>(
      find.descendant(
        of: find.byType(HUFButton),
        matching: find.byType(AnimatedContainer),
      ),
    );

    final decoration = container.decoration! as BoxDecoration;
    expect(decoration.color, theme.colors.primary);
  });

  test('HUFTheme.lerp interpola colori e radius', () {
    final light = HUFTheme.light();
    final dark = HUFTheme.dark();
    final mid = light.lerp(dark, 0.5);

    expect(mid.colors.secondary, isNot(light.colors.secondary));
    expect(mid.borderRadius.md, light.borderRadius.md);
  });

  testWidgets('HUFButtonGroup invoca onPressed per segmento', (tester) async {
    var firstTapped = false;
    var secondTapped = false;

    await tester.pumpWidget(
      _wrap(
        HUFButtonGroup(
          items: [
            HUFButtonGroupItem(
              label: 'Sinistra',
              onPressed: () => firstTapped = true,
            ),
            HUFButtonGroupItem(
              label: 'Destra',
              onPressed: () => secondTapped = true,
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.text('Sinistra'));
    await tester.pump();
    expect(firstTapped, isTrue);
    expect(secondTapped, isFalse);

    await tester.tap(find.text('Destra'));
    await tester.pump();
    expect(secondTapped, isTrue);
  });

  testWidgets('HUFButtonGroup applica radius solo agli estremi', (tester) async {
    const rounded = HUFBorderRadius(value: 999);

    await tester.pumpWidget(
      _wrap(
        HUFButtonGroup(
          items: [
            HUFButtonGroupItem(label: 'A', onPressed: () {}),
            HUFButtonGroupItem(label: 'B', onPressed: () {}),
            HUFButtonGroupItem(label: 'C', onPressed: () {}),
          ],
        ),
        theme: HUFTheme.light(borderRadius: rounded),
      ),
    );

    final inkWells = tester.widgetList<InkWell>(find.byType(InkWell)).toList();
    expect(inkWells.length, 3);

    final firstRadius = inkWells.first.borderRadius!;
    expect(firstRadius.topLeft.x, rounded.value);
    expect(firstRadius.topRight.x, 0);

    final middleRadius = inkWells[1].borderRadius!;
    expect(middleRadius.topLeft.x, 0);
    expect(middleRadius.topRight.x, 0);

    final lastRadius = inkWells.last.borderRadius!;
    expect(lastRadius.topRight.x, rounded.value);
    expect(lastRadius.topLeft.x, 0);
  });

  testWidgets(
    'bottoni e button group con/senza shadow hanno la stessa altezza layout',
    (tester) async {
      await tester.pumpWidget(
        _wrap(
          Wrap(
            children: [
              HUFButton(label: 'Primary', onPressed: () {}),
              HUFButton(
                label: 'Secondary',
                variant: HUFButtonVariant.secondary,
                onPressed: () {},
              ),
              HUFButtonGroup(
                items: [
                  HUFButtonGroupItem(label: 'A', onPressed: () {}),
                  HUFButtonGroupItem(label: 'B', onPressed: () {}),
                ],
              ),
              HUFButtonGroup(
                variant: HUFButtonVariant.danger,
                items: [
                  HUFButtonGroupItem(label: 'C', onPressed: () {}),
                  HUFButtonGroupItem(label: 'D', onPressed: () {}),
                ],
              ),
            ],
          ),
        ),
      );

      final heights = <double>[
        tester.getSize(find.widgetWithText(HUFButton, 'Primary')).height,
        tester.getSize(find.widgetWithText(HUFButton, 'Secondary')).height,
        tester.getSize(find.byType(HUFButtonGroup).at(0)).height,
        tester.getSize(find.byType(HUFButtonGroup).at(1)).height,
      ];

      expect(heights.toSet().length, 1);
    },
  );

  test('HUFButtonGroup richiede almeno 2 elementi', () {
    expect(
      () => HUFButtonGroup(items: [HUFButtonGroupItem(label: 'Solo', onPressed: () {})]),
      throwsAssertionError,
    );
  });

  testWidgets('HUFCheckbox risponde al tap e inverte value', (tester) async {
    var value = false;

    await tester.pumpWidget(
      _wrap(
        StatefulBuilder(
          builder: (context, setState) {
            return HUFCheckbox(
              value: value,
              onChanged: (v) => setState(() => value = v),
            );
          },
        ),
      ),
    );

    expect(value, isFalse);

    await tester.tap(find.byType(HUFCheckbox));
    await tester.pump();

    expect(value, isTrue);
  });

  testWidgets('HUFCheckbox disabilitato non invoca onChanged', (tester) async {
    var value = false;

    await tester.pumpWidget(
      _wrap(
        HUFCheckbox(
          value: value,
          onChanged: null,
        ),
      ),
    );

    await tester.tap(find.byType(HUFCheckbox));
    await tester.pump();

    expect(value, isFalse);
  });

  testWidgets('HUFCheckbox selezionato usa primary del tema', (tester) async {
    final theme = HUFTheme.light();

    await tester.pumpWidget(
      _wrap(
        const HUFCheckbox(
          value: true,
          onChanged: _noopBool,
        ),
        theme: theme,
      ),
    );

    final container = tester.widget<AnimatedContainer>(
      find.byType(AnimatedContainer),
    );
    final decoration = container.decoration! as BoxDecoration;

    expect(decoration.color, theme.colors.primary);
  });

  testWidgets('HUFCheckbox applica border radius del tema', (tester) async {
    const small = HUFBorderRadius.small;

    await tester.pumpWidget(
      _wrap(
        const HUFCheckbox(
          value: false,
          onChanged: _noopBool,
          size: HUFCheckboxSize.medium,
        ),
        theme: HUFTheme.light(borderRadius: small),
      ),
    );

    final container = tester.widget<AnimatedContainer>(
      find.byType(AnimatedContainer),
    );
    final decoration = container.decoration! as BoxDecoration;
    final radius = decoration.borderRadius! as BorderRadius;

    expect(radius.topLeft.x, small.value);
  });

  testWidgets('HUFCheckbox selezionato ha glow, non selezionato no', (tester) async {
    await tester.pumpWidget(
      _wrap(
        Row(
          children: [
            const HUFCheckbox(value: true, onChanged: _noopBool),
            const HUFCheckbox(value: false, onChanged: _noopBool),
          ],
        ),
      ),
    );

    final containers = tester.widgetList<AnimatedContainer>(
      find.byType(AnimatedContainer),
    ).toList();

    expect(containers.length, 2);

    BoxDecoration decorationAt(int index) {
      return containers[index].decoration! as BoxDecoration;
    }

    expect(decorationAt(0).boxShadow, isNotNull);
    expect(decorationAt(0).boxShadow, isNotEmpty);
    expect(decorationAt(1).boxShadow, isNull);
  });

  testWidgets(
    'checkbox selezionati e non selezionati hanno la stessa altezza layout',
    (tester) async {
      await tester.pumpWidget(
        _wrap(
          const Row(
            children: [
              HUFCheckbox(value: true, onChanged: _noopBool),
              HUFCheckbox(value: false, onChanged: _noopBool),
            ],
          ),
        ),
      );

      final checkboxFinder = find.byType(HUFCheckbox);
      final checkedHeight = tester.getSize(checkboxFinder.at(0)).height;
      final uncheckedHeight = tester.getSize(checkboxFinder.at(1)).height;

      expect(checkedHeight, uncheckedHeight);
    },
  );

  testWidgets('HUFCheckbox glowSize modifica blur e padding layout', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const Row(
          children: [
            HUFCheckbox(
              value: true,
              onChanged: _noopBool,
              glowSize: HUFGlowSize.small,
            ),
            HUFCheckbox(
              value: true,
              onChanged: _noopBool,
              glowSize: HUFGlowSize.large,
            ),
          ],
        ),
      ),
    );

    final containers = tester.widgetList<AnimatedContainer>(
      find.byType(AnimatedContainer),
    ).toList();

    final smallShadow = (containers[0].decoration! as BoxDecoration).boxShadow!;
    final largeShadow = (containers[1].decoration! as BoxDecoration).boxShadow!;

    expect(smallShadow.first.blurRadius, lessThan(largeShadow.first.blurRadius));

    final paddings = tester.widgetList<Padding>(
      find.ancestor(
        of: find.byType(AnimatedContainer),
        matching: find.byType(Padding),
      ),
    ).toList();

    expect(paddings[0].padding, hufGlowLayoutPaddingFor(HUFGlowSize.small));
    expect(paddings[1].padding, hufGlowLayoutPaddingFor(HUFGlowSize.large));
  });

  testWidgets('HUFCheckboxGroup gestisce selezione multipla internamente', (
    tester,
  ) async {
    Set<String>? lastSelection;

    await tester.pumpWidget(
      _wrap(
        HUFCheckboxGroup<String>(
          initialValues: {'a'},
          onChanged: (values) => lastSelection = values,
          children: const [
            HUFCheckbox(optionValue: 'a', label: 'Opzione A'),
            HUFCheckbox(optionValue: 'b', label: 'Opzione B'),
          ],
        ),
      ),
    );

    expect(lastSelection, isNull);
    expect(find.byIcon(Icons.check_rounded), findsOneWidget);

    await tester.tap(find.text('Opzione B'));
    await tester.pump();

    expect(lastSelection, {'a', 'b'});
    expect(find.byIcon(Icons.check_rounded), findsNWidgets(2));

    await tester.tap(find.text('Opzione A'));
    await tester.pump();

    expect(lastSelection, {'b'});
    expect(find.byIcon(Icons.check_rounded), findsOneWidget);
  });

  testWidgets('HUFCheckboxGroup single select consente una sola opzione', (
    tester,
  ) async {
    Set<int>? lastSelection;

    await tester.pumpWidget(
      _wrap(
        HUFCheckboxGroup<int>(
          multiSelect: false,
          onChanged: (values) => lastSelection = values,
          children: const [
            HUFCheckbox(optionValue: 1, label: 'Uno'),
            HUFCheckbox(optionValue: 2, label: 'Due'),
          ],
        ),
      ),
    );

    await tester.tap(find.text('Uno'));
    await tester.pump();
    expect(lastSelection, {1});

    await tester.tap(find.text('Due'));
    await tester.pump();
    expect(lastSelection, {2});
    expect(find.byIcon(Icons.check_rounded), findsOneWidget);
  });

  testWidgets('HUFCheckboxGroup elemento disabilitato non cambia selezione', (
    tester,
  ) async {
    Set<String>? lastSelection;

    await tester.pumpWidget(
      _wrap(
        HUFCheckboxGroup<String>(
          onChanged: (values) => lastSelection = values,
          children: const [
            HUFCheckbox(optionValue: 'on', label: 'Attivo'),
            HUFCheckbox(
              optionValue: 'off',
              label: 'Disabilitato',
              enabled: false,
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.text('Disabilitato'));
    await tester.pump();

    expect(lastSelection, isNull);
  });

  test('HUFCheckboxGroup richiede almeno un elemento', () {
    expect(
      () => HUFCheckboxGroup<String>(children: []),
      throwsAssertionError,
    );
  });

  testWidgets('HUFCheckboxCard risponde al tap e inverte value', (tester) async {
    var value = false;

    await tester.pumpWidget(
      _wrap(
        StatefulBuilder(
          builder: (context, setState) {
            return HUFCheckboxCard(
              title: 'Email',
              subtitle: 'Ricevi aggiornamenti',
              value: value,
              onChanged: (v) => setState(() => value = v),
            );
          },
        ),
      ),
    );

    expect(value, isFalse);

    await tester.tap(find.byType(HUFCheckboxCard));
    await tester.pump();

    expect(value, isTrue);
  });

  testWidgets('HUFCheckboxCard disabilitata non invoca onChanged', (tester) async {
    var value = false;

    await tester.pumpWidget(
      _wrap(
        HUFCheckboxCard(
          title: 'Disabilitata',
          value: value,
          onChanged: null,
        ),
      ),
    );

    await tester.tap(find.byType(HUFCheckboxCard));
    await tester.pump();

    expect(value, isFalse);
  });

  testWidgets('HUFCheckboxCard selezionata usa primary del tema', (tester) async {
    final theme = HUFTheme.dark();

    await tester.pumpWidget(
      _wrap(
        const HUFCheckboxCard(
          title: 'Push',
          value: true,
          onChanged: _noopBool,
        ),
        theme: theme,
      ),
    );

    final containers = tester.widgetList<AnimatedContainer>(
      find.byType(AnimatedContainer),
    ).toList();

    final indicator = containers.last;
    final decoration = indicator.decoration! as BoxDecoration;

    expect(decoration.color, theme.colors.primary);
  });

  testWidgets('HUFCheckboxCardGroup gestisce selezione multipla', (tester) async {
    Set<String>? lastSelection;

    await tester.pumpWidget(
      _wrap(
        HUFCheckboxCardGroup<String>(
          initialValues: {'email'},
          onChanged: (values) => lastSelection = values,
          children: const [
            HUFCheckboxCard(
              optionValue: 'email',
              title: 'Email',
            ),
            HUFCheckboxCard(
              optionValue: 'sms',
              title: 'SMS',
            ),
          ],
        ),
      ),
    );

    expect(lastSelection, isNull);
    expect(find.byIcon(Icons.check_rounded), findsOneWidget);

    await tester.tap(find.text('SMS'));
    await tester.pump();

    expect(lastSelection, {'email', 'sms'});
    expect(find.byIcon(Icons.check_rounded), findsNWidgets(2));
  });

  testWidgets('HUFCheckboxCardGroup single select consente una sola opzione', (
    tester,
  ) async {
    Set<String>? lastSelection;

    await tester.pumpWidget(
      _wrap(
        HUFCheckboxCardGroup<String>(
          multiSelect: false,
          onChanged: (values) => lastSelection = values,
          children: const [
            HUFCheckboxCard(optionValue: 'email', title: 'Email'),
            HUFCheckboxCard(optionValue: 'sms', title: 'SMS'),
          ],
        ),
      ),
    );

    await tester.tap(find.text('Email'));
    await tester.pump();
    expect(lastSelection, {'email'});

    await tester.tap(find.text('SMS'));
    await tester.pump();
    expect(lastSelection, {'sms'});
    expect(find.byIcon(Icons.check_rounded), findsOneWidget);
  });

  test('HUFCheckboxCardGroup richiede almeno un elemento', () {
    expect(
      () => HUFCheckboxCardGroup<String>(children: []),
      throwsAssertionError,
    );
  });

  testWidgets('HUFRadioButton seleziona al tap', (tester) async {
    var value = false;

    await tester.pumpWidget(
      _wrap(
        StatefulBuilder(
          builder: (context, setState) {
            return HUFRadioButton(
              value: value,
              onChanged: (v) => setState(() => value = v),
            );
          },
        ),
      ),
    );

    expect(value, isFalse);

    await tester.tap(find.byType(HUFRadioButton));
    await tester.pump();

    expect(value, isTrue);
  });

  testWidgets('HUFRadioButton selezionato non si deseleziona al tap', (
    tester,
  ) async {
    var changed = false;

    await tester.pumpWidget(
      _wrap(
        HUFRadioButton(
          value: true,
          onChanged: (_) => changed = true,
        ),
      ),
    );

    await tester.tap(find.byType(HUFRadioButton));
    await tester.pump();

    expect(changed, isFalse);
  });

  testWidgets('HUFRadioButton disabilitato non invoca onChanged', (tester) async {
    var value = false;

    await tester.pumpWidget(
      _wrap(
        HUFRadioButton(
          value: value,
          onChanged: null,
        ),
      ),
    );

    await tester.tap(find.byType(HUFRadioButton));
    await tester.pump();

    expect(value, isFalse);
  });

  testWidgets('HUFRadioButton selezionato ha glow, non selezionato no', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const Row(
          children: [
            HUFRadioButton(value: true, onChanged: _noopBool),
            HUFRadioButton(value: false, onChanged: _noopBool),
          ],
        ),
      ),
    );

    final containers = tester.widgetList<AnimatedContainer>(
      find.byType(AnimatedContainer),
    ).toList();

    BoxDecoration outerDecorationAt(int index) {
      return containers[index * 2].decoration! as BoxDecoration;
    }

    expect(outerDecorationAt(0).boxShadow, isNotNull);
    expect(outerDecorationAt(0).boxShadow, isNotEmpty);
    expect(outerDecorationAt(1).boxShadow, isNull);
  });

  testWidgets('HUFRadioButtonGroup gestisce selezione singola', (tester) async {
    String? lastSelection;

    await tester.pumpWidget(
      _wrap(
        HUFRadioButtonGroup<String>(
          initialValue: 'a',
          onChanged: (value) => lastSelection = value,
          children: const [
            HUFRadioButton(optionValue: 'a', label: 'Opzione A'),
            HUFRadioButton(optionValue: 'b', label: 'Opzione B'),
          ],
        ),
      ),
    );

    expect(lastSelection, isNull);

    await tester.tap(find.text('Opzione B'));
    await tester.pump();

    expect(lastSelection, 'b');

    await tester.tap(find.text('Opzione A'));
    await tester.pump();

    expect(lastSelection, 'a');
  });

  testWidgets('HUFRadioButtonGroup elemento disabilitato non cambia selezione', (
    tester,
  ) async {
    String? lastSelection;

    await tester.pumpWidget(
      _wrap(
        HUFRadioButtonGroup<String>(
          onChanged: (value) => lastSelection = value,
          children: const [
            HUFRadioButton(optionValue: 'on', label: 'Attivo'),
            HUFRadioButton(
              optionValue: 'off',
              label: 'Disabilitato',
              enabled: false,
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.text('Disabilitato'));
    await tester.pump();

    expect(lastSelection, isNull);
  });

  test('HUFRadioButtonGroup richiede almeno un elemento', () {
    expect(
      () => HUFRadioButtonGroup<String>(children: []),
      throwsAssertionError,
    );
  });

  testWidgets('HUFRadioButton non selezionato usa bordo neutro e sfondo card', (
    tester,
  ) async {
    final theme = HUFTheme.light();

    await tester.pumpWidget(
      _wrap(
        const HUFRadioButton(value: false, onChanged: _noopBool),
        theme: theme,
      ),
    );

    final container = tester.widget<AnimatedContainer>(
      find.byType(AnimatedContainer).first,
    );
    final decoration = container.decoration! as BoxDecoration;
    final border = decoration.border! as Border;

    expect(decoration.color, theme.colors.card);
    expect(border.top.color, theme.colors.border);
    expect(decoration.boxShadow, isNull);
  });

  testWidgets('HUFRadioButton selezionato usa pallino primaryForeground', (
    tester,
  ) async {
    final theme = HUFTheme.light();

    await tester.pumpWidget(
      _wrap(
        const HUFRadioButton(value: true, onChanged: _noopBool),
        theme: theme,
      ),
    );

    final dot = tester.widget<AnimatedContainer>(
      find.descendant(
        of: find.byType(HUFRadioButton),
        matching: find.byType(AnimatedContainer),
      ).last,
    );
    final decoration = dot.decoration! as BoxDecoration;

    expect(decoration.color, theme.colors.primaryForeground);
  });

  testWidgets('HUFRadioButton selezionato mostra sempre il pallino (tutti i preset)',
      (tester) async {
    for (final preset in HUFThemePreset.values) {
      for (final brightness in Brightness.values) {
        final theme = brightness == Brightness.light
            ? HUFTheme.light(data: HUFThemeData(theme: preset))
            : HUFTheme.dark(data: HUFThemeData(theme: preset));

        await tester.pumpWidget(
          _wrap(
            const HUFRadioButton(value: true, onChanged: _noopBool),
            theme: theme,
          ),
        );

        expect(
          find.descendant(
            of: find.byType(HUFRadioButton),
            matching: find.byType(AnimatedContainer),
          ),
          findsNWidgets(2),
          reason: 'preset=$preset brightness=$brightness',
        );
      }
    }
  });

  testWidgets('HUFRadioButton selezionato usa bordo spesso (tutte le size)',
      (tester) async {
    for (final size in HUFRadioButtonSize.values) {
      final expectedWidth = switch (size) {
        HUFRadioButtonSize.small => 4.0,
        HUFRadioButtonSize.medium => 5.0,
        HUFRadioButtonSize.large => 6.0,
      };

      await tester.pumpWidget(
        _wrap(
          HUFRadioButton(
            value: true,
            onChanged: _noopBool,
            size: size,
          ),
        ),
      );

      final container = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer).first,
      );
      final decoration = container.decoration! as BoxDecoration;
      final border = decoration.border! as Border;

      expect(border.top.width, expectedWidth, reason: 'size=$size');
    }
  });

  testWidgets('HUFRadioButton rispetta override activeColor', (tester) async {
    const custom = Color(0xFF059669);

    await tester.pumpWidget(
      _wrap(
        const HUFRadioButton(
          value: true,
          onChanged: _noopBool,
          activeColor: custom,
        ),
      ),
    );

    final container = tester.widget<AnimatedContainer>(
      find.byType(AnimatedContainer).first,
    );
    final decoration = container.decoration! as BoxDecoration;
    final border = decoration.border! as Border;

    expect(border.top.color, custom);
  });

  testWidgets('HUFCheckbox mostra checkedIcon e uncheckedIcon custom', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const Row(
          children: [
            HUFCheckbox(
              value: true,
              onChanged: _noopBool,
              checkedIcon: Icon(Icons.favorite),
            ),
            HUFCheckbox(
              value: false,
              onChanged: _noopBool,
              uncheckedIcon: Icon(Icons.favorite_border),
            ),
          ],
        ),
      ),
    );

    expect(find.byIcon(Icons.favorite), findsOneWidget);
    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    expect(find.byIcon(Icons.check_rounded), findsNothing);
  });

  testWidgets('HUFCheckbox rispetta override activeColor', (tester) async {
    const custom = Color(0xFF059669);

    await tester.pumpWidget(
      _wrap(
        const HUFCheckbox(
          value: true,
          onChanged: _noopBool,
          activeColor: custom,
        ),
      ),
    );

    final container = tester.widget<AnimatedContainer>(
      find.byType(AnimatedContainer),
    );
    final decoration = container.decoration! as BoxDecoration;

    expect(decoration.color, custom);
  });

  test('HUFThemeData sovrascrive glowSize per tutti i componenti', () {
    const data = HUFThemeData(glowSize: HUFGlowSize.large);
    final theme = HUFTheme.light(data: data);

    expect(theme.glowSize, HUFGlowSize.large);
    expect(
      data.resolveGlowSize(Brightness.light),
      HUFGlowSize.large,
    );
  });

  testWidgets('HUFButton usa glowSize dal tema', (tester) async {
    await tester.pumpWidget(
      _wrap(
        HUFButton(label: 'Primary', onPressed: () {}),
        theme: HUFTheme.light(
          data: const HUFThemeData(glowSize: HUFGlowSize.small),
        ),
      ),
    );

    final container = tester.widget<AnimatedContainer>(
      find.descendant(
        of: find.byType(HUFButton),
        matching: find.byType(AnimatedContainer),
      ),
    );
    final shadow = (container.decoration! as BoxDecoration).boxShadow!;

    expect(shadow.first.blurRadius, 8);
  });

  testWidgets('HUFChip non espande lo sfondo a tutta la larghezza del parent', (
    tester,
  ) async {
    const parentWidth = 400.0;

    await tester.pumpWidget(
      _wrap(
        SizedBox(
          width: parentWidth,
          child: Column(
            children: const [
              HUFChip(label: 'Bozza'),
            ],
          ),
        ),
      ),
    );

    final decorationFinder = find.descendant(
      of: find.byType(HUFChip),
      matching: find.byType(DecoratedBox),
    );
    final decorationWidth = tester.getSize(decorationFinder).width;

    expect(decorationWidth, lessThan(parentWidth));
    expect(decorationWidth, greaterThan(0));
  });

  testWidgets('HUFChip in ListView non espande lo sfondo a tutta la riga', (
    tester,
  ) async {
    const parentWidth = 400.0;

    await tester.pumpWidget(
      _wrap(
        SizedBox(
          width: parentWidth,
          height: 200,
          child: ListView(
            children: const [
              HUFChip(
                label: 'Primary · Medium',
                icon: Icon(Icons.label_outline),
              ),
            ],
          ),
        ),
      ),
    );

    final decorationFinder = find.descendant(
      of: find.byType(HUFChip),
      matching: find.byType(DecoratedBox),
    );
    final decorationWidth = tester.getSize(decorationFinder).width;

    expect(decorationWidth, lessThan(parentWidth));
    expect(decorationWidth, greaterThan(0));
  });

  testWidgets('HUFButtonGroup non espande lo sfondo a tutta la riga', (
    tester,
  ) async {
    const parentWidth = 400.0;

    await tester.pumpWidget(
      _wrap(
        SizedBox(
          width: parentWidth,
          height: 200,
          child: ListView(
            children: [
              HUFButtonGroup(
                items: [
                  HUFButtonGroupItem(label: 'Sinistra', onPressed: () {}),
                  HUFButtonGroupItem(label: 'Destra', onPressed: () {}),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    final decorationWidth = tester
        .getSize(
          find.descendant(
            of: find.byType(HUFButtonGroup),
            matching: find.byType(DecoratedBox),
          ).first,
        )
        .width;

    expect(decorationWidth, lessThan(parentWidth));
    expect(decorationWidth, greaterThan(0));
  });

  testWidgets('HUFChip mostra la label', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const HUFChip(label: 'Bozza'),
      ),
    );

    expect(find.text('Bozza'), findsOneWidget);
  });

  testWidgets('HUFChip è più basso del pulsante alla stessa size', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        Column(
          children: [
            HUFButton(label: 'Btn', size: HUFButtonSize.medium, onPressed: () {}),
            const HUFChip(label: 'Chip', size: HUFChipSize.medium),
          ],
        ),
      ),
    );

    final buttonHeight = tester.getSize(find.byType(HUFButton)).height;
    final chipHeight = tester.getSize(find.byType(HUFChip)).height;

    expect(chipHeight, lessThan(buttonHeight));
  });

  testWidgets('HUFSwitch risponde al tap', (tester) async {
    var isOn = false;

    await tester.pumpWidget(
      _wrap(
        StatefulBuilder(
          builder: (context, setState) {
            return HUFSwitch(
              value: isOn,
              onChanged: (v) => setState(() => isOn = v),
            );
          },
        ),
      ),
    );

    await tester.tap(find.byType(HUFSwitch));
    await tester.pumpAndSettle();

    expect(isOn, isTrue);
  });

  testWidgets('HUFSwitchGroup gestisce più switch indipendenti', (tester) async {
    await tester.pumpWidget(
      _wrap(
        HUFSwitchGroup<String>(
          initialValues: const {'a'},
          children: const [
            HUFSwitch(optionValue: 'a', icon: Icon(Icons.check_rounded)),
            HUFSwitch(optionValue: 'b', icon: Icon(Icons.check_rounded)),
          ],
        ),
      ),
    );

    expect(find.byType(HUFSwitch), findsNWidgets(2));

    await tester.tap(find.byType(HUFSwitch).last);
    await tester.pumpAndSettle();
  });

  testWidgets('HUFSlider mostra label e valore opzionale', (tester) async {
    await tester.pumpWidget(
      _wrap(
        HUFSlider(
          label: 'Volume',
          value: 30,
          showValue: true,
          onChanged: _noopDouble,
        ),
      ),
    );

    expect(find.text('Volume'), findsOneWidget);
    expect(find.text('30'), findsOneWidget);
  });

  testWidgets('HUFSlider disabilitato non invoca onChanged', (tester) async {
    var changed = false;

    await tester.pumpWidget(
      _wrap(
        HUFSlider(
          label: 'Volume',
          value: 30,
          onChanged: null,
        ),
      ),
    );

    await tester.tap(find.text('Volume'));
    await tester.pump();

    expect(changed, isFalse);
  });

  testWidgets('HUFRangeSlider mostra label e intervallo', (tester) async {
    await tester.pumpWidget(
      _wrap(
        SizedBox(
          width: 400,
          child: HUFRangeSlider(
            label: 'Price Range',
            values: const RangeValues(100, 500),
            min: 0,
            max: 1000,
            showValue: true,
            valueFormatter: (v) => '${v.start.toInt()}-${v.end.toInt()}',
            onChanged: _noopRange,
          ),
        ),
      ),
    );

    expect(find.text('Price Range'), findsOneWidget);
    expect(find.text('100-500'), findsOneWidget);
  });

  testWidgets('HUFSlider applica border radius del tema', (tester) async {
    const small = HUFBorderRadius.small;

    await tester.pumpWidget(
      _wrap(
        HUFSlider(
          label: 'Volume',
          value: 30,
          onChanged: _noopDouble,
        ),
        theme: HUFTheme.light(borderRadius: small),
      ),
    );

    final clip = tester.widget<ClipRRect>(find.byType(ClipRRect));
    expect(clip.borderRadius, BorderRadius.circular(small.value));
  });

  testWidgets(
    'HUFSlider mantiene il valore dopo il drag se il parent non aggiorna value',
    (tester) async {
      await tester.pumpWidget(
        _wrap(
          HUFSlider(
            label: 'Volume',
            value: 10,
            showValue: true,
            onChanged: _noopDouble,
          ),
        ),
      );

      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(HUFSlider)),
      );
      await gesture.moveBy(const Offset(160, 0));
      await gesture.up();
      await tester.pump();

      expect(find.text('10'), findsNothing);
    },
  );

  testWidgets('HUFSlider con step mostra valori discreti', (tester) async {
    await tester.pumpWidget(
      _wrap(
        HUFSlider(
          label: 'Step',
          value: 50,
          min: 0,
          max: 100,
          step: 10,
          showValue: true,
          onChanged: _noopDouble,
        ),
      ),
    );

    expect(find.text('50'), findsOneWidget);
  });

  testWidgets('HUFCard con una action la espande a tutta la larghezza', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        SizedBox(
          width: 280,
          child: HUFCard(
            title: 'Titolo',
            actions: [
              HUFButton(label: 'Apri', onPressed: () {}),
            ],
          ),
        ),
      ),
    );

    final button = tester.widget<HUFButton>(find.byType(HUFButton));
    expect(button.isFullWidth, isTrue);
  });

  testWidgets('HUFCard mostra titolo, sottotitolo e contenuto', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const HUFCard(
          title: 'Titolo',
          subtitle: 'Sottotitolo',
          content: Text('Corpo'),
        ),
      ),
    );

    expect(find.text('Titolo'), findsOneWidget);
    expect(find.text('Sottotitolo'), findsOneWidget);
    expect(find.text('Corpo'), findsOneWidget);
  });

  testWidgets('HUFCard orizzontale dispone immagine e testo in riga', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        HUFCard(
          orientation: HUFCardOrientation.horizontal,
          title: 'Orizzontale',
          image: Container(color: Colors.red, width: 48, height: 48),
        ),
      ),
    );

    expect(find.byType(Row), findsWidgets);
    expect(find.text('Orizzontale'), findsOneWidget);
  });

  test('hufCardMetricsFor applica padding e gap fissi indipendentemente dal preset', () {
    final small = hufCardMetricsFor(
      HUFCardRadiusSize.medium,
      HUFBorderRadius.small,
    );
    final large = hufCardMetricsFor(
      HUFCardRadiusSize.medium,
      HUFBorderRadius.large,
    );

    expect(small.padding, kHufCardPadding);
    expect(large.padding, kHufCardPadding);
    expect(small.sectionGap, kHufCardSectionGap);
    expect(large.sectionGap, kHufCardSectionGap);
    expect(large.horizontalImageExtent, kHufCardHorizontalImageExtent);
    expect(small.borderRadius, HUFBorderRadius.small.value);
    expect(large.borderRadius, HUFBorderRadius.large.value);
    expect(
      hufCardEffectiveOuterRadius(
        borderRadius: small.borderRadius,
        width: 320,
      ),
      small.borderRadius,
    );
  });

  testWidgets('HUFCard mantiene altezza ragionevole con radius grande', (tester) async {
    final huf = HUFTheme.light().copyWith(borderRadius: HUFBorderRadius.large);

    await tester.pumpWidget(
      MaterialApp(
        theme: huf.toThemeData(),
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 320,
              child: HUFCard(
                title: 'Large radius card',
                subtitle: 'Sottotitolo',
                content: const Text('Contenuto'),
              ),
            ),
          ),
        ),
      ),
    );

    final height = tester.getSize(find.byType(HUFCard)).height;
    expect(height, lessThan(300));
    expect(height, greaterThan(50));
  });

  testWidgets('HUFCard risolve lo sfondo in base allo stile', (tester) async {
    const theme = HUFTheme(
      brightness: Brightness.light,
      colors: HUFThemeColors.light,
      borderRadius: HUFBorderRadius.medium,
      glowSize: HUFGlowSize.none,
    );

    await tester.pumpWidget(
      _wrap(
        const HUFCard(
          style: HUFCardStyle.cardSecondary,
          title: 'Card',
        ),
        theme: theme,
      ),
    );

    final decorated = tester.widget<DecoratedBox>(
      find.descendant(
        of: find.byType(HUFCard),
        matching: find.byType(DecoratedBox),
      ).first,
    );
    final decoration = decorated.decoration! as BoxDecoration;
    expect(decoration.color, HUFThemeColors.light.cardSecondary);
  });

  test('HUFThemeData sovrascrive i colori del tema', () {
    const customPrimary = Color(0xFF7C3AED);
    const data = HUFThemeData(
      light: HUFThemePalette(
        colors: HUFThemeColors(
          background: Color(0xFFF4F5F6),
          border: Color(0xFFDDDEDF),
          primary: customPrimary,
          primaryForeground: Color(0xFFFFFFFF),
          secondary: Color(0xFFE2E8F0),
          secondaryForeground: Color(0xFF0F172A),
          danger: Color(0xFFDC2626),
          dangerForeground: Color(0xFFFFFFFF),
          dangerSoft: Color(0xFFFEE2E2),
          dangerSoftForeground: Color(0xFFB91C1C),
          success: Color(0xFF15C964),
          successForeground: Color(0xFF161917),
          warning: Color(0xFFF5A523),
          warningForeground: Color(0xFF1A1815),
          disabled: Color(0xFF94A3B8),
          disabledForeground: Color(0xFFFFFFFF),
          transparent: Colors.transparent,
          card: Color(0xFFFFFFFF),
          cardSecondary: Color(0xFFF8FAFC),
          cardTertiary: Color(0xFFF1F5F9),
          cardForeground: Color(0xFF0F172A),
          cardMutedForeground: Color(0xFF64748B),
        ),
      ),
    );

    final theme = HUFTheme.light(data: data);
    expect(theme.colors.primary, customPrimary);
  });

  test('HUFThemeData.theme risolve un preset integrato', () {
    const data = HUFThemeData(theme: HUFThemePreset.sky);
    final theme = HUFTheme.light(data: data);
    expect(theme.colors.primary, const Color(0xFF00CBFF));
    expect(theme.borderRadius.value, 8);
  });

  test('HUFThemeData.preset shortcut', () {
    const data = HUFThemeData.preset(HUFThemePreset.netflix);
    expect(
      data.resolveBorderRadius(Brightness.light),
      HUFBorderRadius.extraSmall,
    );
  });

  test('override borderRadius ha priorità sul preset', () {
    const data = HUFThemeData(
      theme: HUFThemePreset.sky,
      borderRadius: HUFBorderRadius.large,
    );
    expect(
      data.resolveBorderRadius(Brightness.light),
      HUFBorderRadius.large,
    );
  });

  testWidgets('HUFAvatar mostra le iniziali normalizzate', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const HUFAvatar(initials: 'ag'),
      ),
    );

    expect(find.text('AG'), findsOneWidget);
  });

  testWidgets('HUFAvatar rispetta le dimensioni per size', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const HUFAvatar(
          initials: 'AG',
          size: HUFAvatarSize.large,
        ),
      ),
    );

    final size = tester.getSize(_avatarDecoratedBoxFinder());
    expect(size.width, 48);
    expect(size.height, 48);
  });

  testWidgets('HUFAvatar variant default usa secondary e primary', (tester) async {
    final theme = HUFTheme.light();

    await tester.pumpWidget(
      _wrap(
        const HUFAvatar(initials: 'AG'),
        theme: theme,
      ),
    );

    final decorated = tester.widget<DecoratedBox>(
      find.descendant(
        of: find.byType(HUFAvatar),
        matching: find.byType(DecoratedBox),
      ),
    );
    final decoration = decorated.decoration! as BoxDecoration;

    expect(decoration.color, theme.colors.secondary);
  });

  testWidgets('HUFAvatar accetta colori personalizzati', (tester) async {
    const bg = Color(0xFF1E3A5F);
    const fg = Color(0xFF60A5FA);

    await tester.pumpWidget(
      _wrap(
        const HUFAvatar(
          initials: 'AG',
          backgroundColor: bg,
          foregroundColor: fg,
        ),
      ),
    );

    final decorated = tester.widget<DecoratedBox>(
      find.descendant(
        of: find.byType(HUFAvatar),
        matching: find.byType(DecoratedBox),
      ),
    );
    final decoration = decorated.decoration! as BoxDecoration;

    expect(decoration.color, bg);
    expect(
      tester.widget<Text>(find.text('AG')).style?.color,
      fg,
    );
  });

  testWidgets('HUFAvatarGroup con max mostra contatore overflow', (tester) async {
    await tester.pumpWidget(
      _wrap(
        HUFAvatarGroup(
          max: 4,
          children: const [
            HUFAvatar(initials: 'A1'),
            HUFAvatar(initials: 'A2'),
            HUFAvatar(initials: 'A3'),
            HUFAvatar(initials: 'A4'),
            HUFAvatar(initials: 'A5'),
          ],
        ),
      ),
    );

    expect(find.text('A1'), findsOneWidget);
    expect(find.text('A2'), findsOneWidget);
    expect(find.text('A3'), findsOneWidget);
    expect(find.text('A4'), findsNothing);
    expect(find.text('A5'), findsNothing);
    expect(find.text('+2'), findsOneWidget);
  });

  testWidgets('HUFAvatarGroup senza max mostra tutti gli avatar', (tester) async {
    await tester.pumpWidget(
      _wrap(
        HUFAvatarGroup(
          children: const [
            HUFAvatar(initials: 'A1'),
            HUFAvatar(initials: 'A2'),
            HUFAvatar(initials: 'A3'),
          ],
        ),
      ),
    );

    expect(find.text('A1'), findsOneWidget);
    expect(find.text('A2'), findsOneWidget);
    expect(find.text('A3'), findsOneWidget);
    expect(find.textContaining('+'), findsNothing);
  });

  testWidgets('HUFAvatar applica border radius del tema', (tester) async {
    const small = HUFBorderRadius.small;

    await tester.pumpWidget(
      _wrap(
        const HUFAvatar(
          initials: 'AG',
          size: HUFAvatarSize.medium,
        ),
        theme: HUFTheme.light(borderRadius: small),
      ),
    );

    final decorated = tester.widget<DecoratedBox>(_avatarDecoratedBoxFinder());
    final decoration = decorated.decoration! as BoxDecoration;
    final radius = decoration.borderRadius! as BorderRadius;

    expect(radius.topLeft.x, small.value);
  });

  testWidgets('HUFAvatar con badge numerico mostra il conteggio', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const HUFAvatar(
          initials: 'AG',
          badge: HUFAvatarBadge.count(5),
        ),
      ),
    );

    expect(find.text('5'), findsOneWidget);
  });

  testWidgets('HUFAvatar con badge dot non mostra testo aggiuntivo', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const HUFAvatar(
          initials: 'AG',
          badge: HUFAvatarBadge.dot(),
        ),
      ),
    );

    expect(find.text('AG'), findsOneWidget);
    expect(find.byType(Text), findsOneWidget);
  });

  testWidgets('HUFAvatar badge default usa success del tema', (tester) async {
    final theme = HUFTheme.light();

    await tester.pumpWidget(
      _wrap(
        const HUFAvatar(
          initials: 'AG',
          badge: HUFAvatarBadge.dot(),
        ),
        theme: theme,
      ),
    );

    final badges = tester.widgetList<DecoratedBox>(
      find.descendant(
        of: find.byType(HUFAvatar),
        matching: find.byType(DecoratedBox),
      ),
    ).toList();

    expect(badges.length, greaterThan(1));
    final badgeDecoration = badges.last.decoration! as BoxDecoration;
    expect(badgeDecoration.color, theme.colors.success);
  });

  testWidgets('HUFAvatar badge new e old mostrano etichetta', (tester) async {
    await tester.pumpWidget(
      _wrap(
        Column(
          children: const [
            HUFAvatar(initials: 'AG', badge: HUFAvatarBadge.newLabel),
            HUFAvatar(initials: 'AG', badge: HUFAvatarBadge.oldLabel),
          ],
        ),
      ),
    );

    expect(find.text('New'), findsOneWidget);
    expect(find.text('Old'), findsOneWidget);
  });

  testWidgets('HUFAvatar con immagine non espande in ListView', (tester) async {
    const parentWidth = 400.0;

    await tester.pumpWidget(
      _wrap(
        SizedBox(
          width: parentWidth,
          height: 200,
          child: ListView(
            children: const [
              HUFAvatar(
                image: NetworkImage(
                  'https://example.com/avatar.jpg',
                ),
              ),
            ],
          ),
        ),
      ),
    );

    expect(tester.getSize(_avatarDecoratedBoxFinder()).width, 40);
    expect(tester.getSize(_avatarDecoratedBoxFinder()).height, 40);
  });

  testWidgets('HUFAvatar badge dot e count hanno la stessa dimensione', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        Row(
          children: const [
            HUFAvatar(initials: 'AG', badge: HUFAvatarBadge.dot()),
            HUFAvatar(initials: 'AG', badge: HUFAvatarBadge.count(5)),
          ],
        ),
      ),
    );

    final badges = tester.widgetList<SizedBox>(
      find.descendant(
        of: find.byType(HUFAvatar),
        matching: find.byWidgetPredicate(
          (widget) => widget is SizedBox && widget.width == widget.height,
        ),
      ),
    ).where((box) => box.width != null && box.width! <= 24).toList();

    expect(badges.length, greaterThanOrEqualTo(2));
    expect(badges.first.width, badges.last.width);
    expect(badges.first.height, badges.last.height);
  });

  testWidgets('HUFAvatar badge icon mostra l\'icona', (tester) async {
    await tester.pumpWidget(
      _wrap(
        HUFAvatar(
          initials: 'AG',
          badge: HUFAvatarBadge.icon(
            Icon(Icons.check_rounded),
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.check_rounded), findsOneWidget);
  });

  test('HUFAvatarGroup richiede almeno un avatar', () {
    expect(
      () => HUFAvatarGroup(children: []),
      throwsAssertionError,
    );
  });

  testWidgets('HUFAlert mostra titolo e descrizione', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const HUFAlert(
          title: 'Titolo alert',
          description: 'Descrizione secondaria',
          icon: Icon(Icons.info_outline),
        ),
      ),
    );

    expect(find.text('Titolo alert'), findsOneWidget);
    expect(find.text('Descrizione secondaria'), findsOneWidget);
  });

  testWidgets('HUFAlert usa card del tema per lo sfondo', (tester) async {
    final theme = HUFTheme.light();

    await tester.pumpWidget(
      _wrap(
        const HUFAlert(title: 'Test'),
        theme: theme,
      ),
    );

    final decorated = tester.widget<DecoratedBox>(_alertDecoratedBoxFinder());
    final decoration = decorated.decoration! as BoxDecoration;
    expect(decoration.color, theme.colors.card);
  });

  testWidgets('HUFAlert accent usa colore semantico per il titolo', (
    tester,
  ) async {
    final theme = HUFTheme.light();

    await tester.pumpWidget(
      _wrap(
        const HUFAlert(
          title: 'Errore',
          color: HUFAlertColor.danger,
        ),
        theme: theme,
      ),
    );

    final title = tester.widget<Text>(find.text('Errore'));
    expect(title.style?.color, theme.colors.danger);
  });

  testWidgets('HUFAlert con showCloseButton mostra icona close', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        HUFAlert(
          title: 'Chiudibile',
          showCloseButton: true,
          onDismiss: () {},
        ),
      ),
    );

    expect(find.byIcon(Icons.close), findsOneWidget);
  });

  testWidgets('HUFAlert in ListView non occupa tutta la larghezza', (
    tester,
  ) async {
    const parentWidth = 400.0;

    await tester.pumpWidget(
      _wrap(
        SizedBox(
          width: parentWidth,
          child: ListView(
            children: const [
              HUFAlert(
                title: 'Titolo compatto',
                description: 'Breve',
              ),
            ],
          ),
        ),
      ),
    );

    final alertWidth = tester.getSize(_alertDecoratedBoxFinder()).width;
    expect(alertWidth, lessThan(parentWidth));
    expect(alertWidth, greaterThan(0));
  });

  testWidgets('HUFAlert action mostra label azione', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const HUFAlert(
          title: 'Aggiornamento',
          action: HUFAlertAction(label: 'Refresh'),
        ),
      ),
    );

    expect(find.text('Refresh'), findsOneWidget);
    expect(find.byIcon(Icons.close), findsNothing);
  });

  testWidgets('hufShowAlert e hufDismissAlert gestiscono overlay', (
    tester,
  ) async {
    late BuildContext capturedContext;

    await tester.pumpWidget(
      _wrapWithAlertOverlay(
        Builder(
          builder: (context) {
            capturedContext = context;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    final id = hufShowAlert(
      capturedContext,
      options: HUFShowAlertOptions(
        title: 'Overlay alert',
        showCloseButton: true,
      ),
    );

    await tester.pump();
    expect(find.text('Overlay alert'), findsOneWidget);

    hufDismissAlert(capturedContext, id);
    await tester.pump();
    expect(find.text('Overlay alert'), findsNothing);
  });

  testWidgets('HUFAccordionItem standalone si espande al tap', (tester) async {
    await tester.pumpWidget(
      _wrap(const _StandaloneAccordionTest()),
    );

    expect(find.text('Risposta FAQ'), findsNothing);

    await tester.tap(find.text('Domanda FAQ'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Risposta FAQ'), findsOneWidget);
  });

  testWidgets('HUFAccordion allowMultiple mantiene più item aperti', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        HUFAccordion<String>(
          allowMultiple: true,
          initialExpanded: const {'a'},
          children: const [
            HUFAccordionItem(
              optionValue: 'a',
              title: 'Primo',
              content: Text('Contenuto primo'),
            ),
            HUFAccordionItem(
              optionValue: 'b',
              title: 'Secondo',
              content: Text('Contenuto secondo'),
            ),
          ],
        ),
      ),
    );

    expect(find.text('Contenuto primo'), findsOneWidget);
    expect(find.text('Contenuto secondo'), findsNothing);

    await tester.tap(find.text('Secondo'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Contenuto primo'), findsOneWidget);
    expect(find.text('Contenuto secondo'), findsOneWidget);
  });

  testWidgets('HUFAccordion allowMultiple false chiude il precedente', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        HUFAccordion<String>(
          allowMultiple: false,
          initialExpanded: const {'a'},
          children: const [
            HUFAccordionItem(
              optionValue: 'a',
              title: 'Primo',
              content: Text('Contenuto primo'),
            ),
            HUFAccordionItem(
              optionValue: 'b',
              title: 'Secondo',
              content: Text('Contenuto secondo'),
            ),
          ],
        ),
      ),
    );

    expect(find.text('Contenuto primo'), findsOneWidget);

    await tester.tap(find.text('Secondo'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Contenuto primo'), findsNothing);
    expect(find.text('Contenuto secondo'), findsOneWidget);
  });

  testWidgets('HUFAccordion card usa sfondo card e radius del tema', (
    tester,
  ) async {
    const customRadius = 20.0;
    final theme = HUFTheme.light().copyWith(
      borderRadius: const HUFBorderRadius(value: customRadius),
    );

    await tester.pumpWidget(
      _wrap(
        HUFAccordion<String>(
          variant: HUFAccordionVariant.card,
          children: const [
            HUFAccordionItem(
              optionValue: 'a',
              title: 'Item card',
              content: Text('Contenuto'),
            ),
          ],
        ),
        theme: theme,
      ),
    );

    final decorated = tester.widget<DecoratedBox>(
      find.descendant(
        of: find.byType(HUFAccordion<String>),
        matching: find.byType(DecoratedBox).first,
      ),
    );

    expect(
      (decorated.decoration as BoxDecoration).color,
      theme.colors.card,
    );
    expect(
      (decorated.decoration as BoxDecoration).borderRadius,
      BorderRadius.circular(customRadius),
    );
  });

  testWidgets('HUFAccordion ghost non avvolge in card decorata', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        HUFAccordion<String>(
          variant: HUFAccordionVariant.ghost,
          children: const [
            HUFAccordionItem(
              optionValue: 'a',
              title: 'Item ghost',
              content: Text('Contenuto ghost'),
            ),
          ],
        ),
      ),
    );

    expect(find.byType(HUFAccordion<String>), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(HUFAccordion<String>),
        matching: find.byType(DecoratedBox),
      ),
      findsNothing,
    );
  });
}

void _noop() {}

void _noopBool(bool _) {}

void _noopDouble(double _) {}

void _noopRange(RangeValues _) {}

Finder _buttonBackgroundFinder() {
  return find.descendant(
    of: find.byType(HUFButton),
    matching: find.byType(AnimatedContainer),
  );
}

Finder _avatarDecoratedBoxFinder() {
  return find.descendant(
    of: find.byType(HUFAvatar),
    matching: find.byType(DecoratedBox),
  );
}

Widget _wrapWithAlertOverlay(Widget child, {HUFTheme? theme}) {
  final huf = theme ?? HUFTheme.light();
  return MaterialApp(
    theme: huf.toThemeData(),
    builder: (context, appChild) => HUFAlertOverlay(child: appChild!),
    home: Scaffold(body: child),
  );
}

Finder _alertDecoratedBoxFinder() {
  return find.descendant(
    of: find.byType(HUFAlert),
    matching: find.byType(DecoratedBox),
  );
}

class _StandaloneAccordionTest extends StatefulWidget {
  const _StandaloneAccordionTest();

  @override
  State<_StandaloneAccordionTest> createState() => _StandaloneAccordionTestState();
}

class _StandaloneAccordionTestState extends State<_StandaloneAccordionTest> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return HUFAccordionItem(
      title: 'Domanda FAQ',
      isExpanded: _expanded,
      onExpansionChanged: (value) => setState(() => _expanded = value),
      content: const Text('Risposta FAQ'),
    );
  }
}

