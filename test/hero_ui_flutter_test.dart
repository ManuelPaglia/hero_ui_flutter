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
