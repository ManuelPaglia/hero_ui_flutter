import 'package:flutter_test/flutter_test.dart';

import 'package:example/main.dart';

void main() {
  testWidgets('mostra la home dei componenti', (tester) async {
    await tester.pumpWidget(const HeroUIExampleApp());

    expect(find.text('Bottoni'), findsOneWidget);
    expect(find.text('Button group'), findsOneWidget);
  });
}
