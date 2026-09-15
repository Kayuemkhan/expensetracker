import 'package:expensetracker/app/core/values/app_values.dart';
import 'package:expensetracker/app/data/model/budget.dart';
import 'package:expensetracker/app/data/repository/expense_repository.dart';
import 'package:expensetracker/app/modules/quick_expense/controllers/quick_expense_controller.dart';
import 'package:expensetracker/app/modules/quick_expense/views/quick_expense_view.dart';
import 'package:expensetracker/flavors/build_config.dart';
import 'package:expensetracker/flavors/env_config.dart';
import 'package:expensetracker/flavors/environment.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

class _FakeExpenseRepository extends ExpenseRepository {
  @override
  Future<Budget?> getCurrentBudget() async {
    return Budget(
      id: 1,
      monthlyAmount: 18000,
      dailyAmount: 600,
      month: DateTime.now(),
    );
  }

  @override
  Future<double> getTodaySpent() async => 125;
}

void main() {
  setUpAll(() {
    BuildConfig.instantiate(
      envType: Environment.DEVELOPMENT,
      envConfig: EnvConfig(appName: AppValues.appName, baseUrl: ''),
    );
  });

  setUp(() {
    Get.reset();
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('shows the Quick Expense form and current daily budget', (
    tester,
  ) async {
    final repository = _FakeExpenseRepository();
    Get.put<ExpenseRepository>(repository);
    Get.put(QuickExpenseController());

    await tester.pumpWidget(const GetMaterialApp(home: QuickExpenseView()));
    await tester.pumpAndSettle();

    expect(find.text('Amount'), findsOneWidget);
    expect(find.text('Description'), findsOneWidget);
    expect(find.text('Category'), findsOneWidget);
    expect(find.text('Date'), findsOneWidget);
    expect(find.text('Daily Budget'), findsOneWidget);
    expect(find.textContaining('Remaining:'), findsOneWidget);
  });

  testWidgets('lets the user select a supported expense category', (
    tester,
  ) async {
    final repository = _FakeExpenseRepository();
    Get.put<ExpenseRepository>(repository);
    Get.put(QuickExpenseController());

    await tester.pumpWidget(const GetMaterialApp(home: QuickExpenseView()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Food'));
    await tester.pumpAndSettle();

    expect(find.text('Transport'), findsOneWidget);

    await tester.tap(find.text('Transport'));
    await tester.pumpAndSettle();

    expect(find.text('Transport'), findsOneWidget);
  });
}
