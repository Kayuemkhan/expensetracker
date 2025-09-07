import 'package:get/get.dart';
import 'package:expensetracker/app/modules/quick_expense/controllers/quick_expense_controller.dart';
import 'package:expensetracker/app/data/repository/expense_repository.dart';

class QuickExpenseBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ExpenseRepository>()) {
      Get.lazyPut<ExpenseRepository>(() => ExpenseRepository());
    }

    Get.lazyPut<QuickExpenseController>(() => QuickExpenseController());
  }
}