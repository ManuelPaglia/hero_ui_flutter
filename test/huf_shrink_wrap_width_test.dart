import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hero_ui_flutter/hero_ui_flutter.dart';

/// Verifica il comportamento con vincoli tight orizzontali (caso ListView).
Widget _tightWidthList(Widget child, {double width = 400}) {
  return MaterialApp(
    theme: HUFTheme.light().toThemeData(),
    home: Scaffold(
      body: SizedBox(
        width: width,
        height: 200,
        child: ListView(children: [child]),
      ),
    ),
  );
}

void main() {
  group('larghezza intrinseca in ListView (vincoli tight)', () {
    testWidgets('HUFChip', (tester) async {
      await tester.pumpWidget(
        _tightWidthList(const HUFChip(label: 'Etichetta')),
      );

      final width = tester
          .getSize(
            find.descendant(
              of: find.byType(HUFChip),
              matching: find.byType(DecoratedBox),
            ),
          )
          .width;
      expect(width, lessThan(400));
    });

    testWidgets('HUFButton', (tester) async {
      await tester.pumpWidget(
        _tightWidthList(HUFButton(label: 'Azione', onPressed: () {})),
      );

      expect(tester.getSize(_buttonBackground()).width, lessThan(400));
    });

    testWidgets('HUFButton isFullWidth', (tester) async {
      await tester.pumpWidget(
        _tightWidthList(
          HUFButton(
            label: 'Largo',
            isFullWidth: true,
            onPressed: () {},
          ),
        ),
      );

      expect(tester.getSize(find.byType(HUFButton)).width, 400);
    });

    testWidgets('HUFButtonGroup', (tester) async {
      await tester.pumpWidget(
        _tightWidthList(
          HUFButtonGroup(
            items: [
              HUFButtonGroupItem(label: 'A', onPressed: () {}),
              HUFButtonGroupItem(label: 'B', onPressed: () {}),
            ],
          ),
        ),
      );

      final width = tester
          .getSize(
            find.descendant(
              of: find.byType(HUFButtonGroup),
              matching: find.byType(DecoratedBox),
            ).first,
          )
          .width;
      expect(width, lessThan(400));
    });
  });
}

Finder _buttonBackground() {
  return find.descendant(
    of: find.byType(HUFButton),
    matching: find.byType(AnimatedContainer),
  );
}
