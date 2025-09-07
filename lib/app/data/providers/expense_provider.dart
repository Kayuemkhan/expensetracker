import 'package:get/get.dart';
import 'package:expensetracker/app/data/repository/expense_repository.dart';

class ExpenseProvider extends GetxService {
  static ExpenseProvider get to => Get.find();

  late final ExpenseRepository _expenseRepository;

  @override
  Future<void> onInit() async {
    super.onInit();
    _expenseRepository = ExpenseRepository();

    // Initialize database
    await _expenseRepository.getCurrentBudget();
  }

  ExpenseRepository get expenseRepository => _expenseRepository;
}