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

  testWidgets('HUFButton senza isFullWidth non occupa tutta la larghezza', (
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

    final buttonWidth = tester.getSize(find.byType(HUFButton)).width;
    expect(buttonWidth, lessThan(parentWidth));
    expect(buttonWidth, greaterThan(0));
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
    const sharp = HUFBorderRadius.sharp;

    await tester.pumpWidget(
      _wrap(
        HUFButton.iconOnly(
          icon: const Icon(Icons.add),
          onPressed: () {},
        ),
        theme: HUFTheme.light(borderRadius: sharp),
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

    expect(radius.topLeft.x, sharp.md);
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

    expect(mid.colors.primary, isNot(light.colors.primary));
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
    const pill = HUFBorderRadius.pill;

    await tester.pumpWidget(
      _wrap(
        HUFButtonGroup(
          items: [
            HUFButtonGroupItem(label: 'A', onPressed: () {}),
            HUFButtonGroupItem(label: 'B', onPressed: () {}),
            HUFButtonGroupItem(label: 'C', onPressed: () {}),
          ],
        ),
        theme: HUFTheme.light(borderRadius: pill),
      ),
    );

    final inkWells = tester.widgetList<InkWell>(find.byType(InkWell)).toList();
    expect(inkWells.length, 3);

    final firstRadius = inkWells.first.borderRadius!;
    expect(firstRadius.topLeft.x, pill.md);
    expect(firstRadius.topRight.x, 0);

    final middleRadius = inkWells[1].borderRadius!;
    expect(middleRadius.topLeft.x, 0);
    expect(middleRadius.topRight.x, 0);

    final lastRadius = inkWells.last.borderRadius!;
    expect(lastRadius.topRight.x, pill.md);
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
    const sharp = HUFBorderRadius.sharp;

    await tester.pumpWidget(
      _wrap(
        const HUFCheckbox(
          value: false,
          onChanged: _noopBool,
          size: HUFCheckboxSize.medium,
        ),
        theme: HUFTheme.light(borderRadius: sharp),
      ),
    );

    final container = tester.widget<AnimatedContainer>(
      find.byType(AnimatedContainer),
    );
    final decoration = container.decoration! as BoxDecoration;
    final radius = decoration.borderRadius! as BorderRadius;

    expect(radius.topLeft.x, sharp.md);
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

  test('HUFThemeData sovrascrive i colori del tema', () {
    const customPrimary = Color(0xFF7C3AED);
    const data = HUFThemeData(
      light: HUFThemePalette(
        colors: HUFThemeColors(
          primary: customPrimary,
          primaryForeground: Color(0xFFFFFFFF),
          secondary: Color(0xFFE2E8F0),
          secondaryForeground: Color(0xFF0F172A),
          danger: Color(0xFFDC2626),
          dangerForeground: Color(0xFFFFFFFF),
          dangerSoft: Color(0xFFFEE2E2),
          dangerSoftForeground: Color(0xFFB91C1C),
          disabled: Color(0xFF94A3B8),
          disabledForeground: Color(0xFFFFFFFF),
          transparent: Colors.transparent,
        ),
      ),
    );

    final theme = HUFTheme.light(data: data);
    expect(theme.colors.primary, customPrimary);
  });
}

void _noop() {}

void _noopBool(bool _) {}
