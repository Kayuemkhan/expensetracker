import 'package:expensetracker/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('launches, records an expense, and opens the Journal tab', (
    tester,
  ) async {
    app.main();
    await tester.pump();

    expect(find.text('Welcome to'), findsOneWidget);
    expect(find.text('Expense'), findsOneWidget);
    expect(find.text('Tracker'), findsOneWidget);

    await tester.pump(const Duration(seconds: 6));
    await tester.pumpAndSettle();

    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Daily Budget'), findsOneWidget);

    final merchant =
        'Integration Lunch ${DateTime.now().microsecondsSinceEpoch}';

    await tester.tap(find.byIcon(Icons.add).first);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), '250');
    await tester.enterText(find.byType(TextField).at(1), merchant);
    await tester.tap(find.text('Save Expense'));
    await tester.pumpAndSettle();

    expect(find.text(merchant), findsOneWidget);

    await tester.tap(find.text('Journal'));
    await tester.pumpAndSettle();

    expect(find.text('Impulse Journal'), findsOneWidget);
    expect(find.text('Money Saved'), findsOneWidget);
  });
}
