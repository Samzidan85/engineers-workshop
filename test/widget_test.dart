import 'package:flutter_test/flutter_test.dart';

import 'package:engineers_workshop/main.dart';

void main() {
  testWidgets('App boots to the workshop screen', (WidgetTester tester) async {
    await tester.pumpWidget(const EngineerWorkshopApp());
    expect(find.byType(EngineerWorkshopApp), findsOneWidget);
  });
}
