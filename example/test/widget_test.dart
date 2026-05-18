import 'package:flutter_test/flutter_test.dart';
import 'package:hero_ui_flutter/hero_ui_flutter.dart';

import 'package:example/main.dart';

void main() {
  testWidgets('mostra la showcase dei pulsanti', (tester) async {
    await tester.pumpWidget(const HeroUIExampleApp(themeData: HUFThemeData.defaults));

    expect(find.text('Bottoni'), findsOneWidget);
    expect(find.text('Button group'), findsOneWidget);
  });
}
