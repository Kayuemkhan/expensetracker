import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:expensetracker/app/core/base/base_controller.dart';
import 'package:expensetracker/app/data/repository/expense_repository.dart';
import 'package:expensetracker/app/data/model/expense.dart';
import 'package:expensetracker/app/core/values/expense_constants.dart';

class HomeController extends BaseController {
  final ExpenseRepository _expenseRepository = Get.put(ExpenseRepository());

  // Observables
  final RxList<Expense> _todayExpenses = RxList<Expense>();
  final RxDouble _dailyBudget = 0.0.obs;
  final RxDouble _todaySpent = 0.0.obs;
  final RxDouble _remainingBudget = 0.0.obs;
  final RxMap<String, double> _spendingTrend = RxMap<String, double>();
  final RxDouble _threeMonthTotal = 0.0.obs;
  final RxString _percentageChange = '0%'.obs;
  final RxBool _isLoadingBudget = true.obs;
  final RxBool _isLoadingExpenses = true.obs;

  // Getters
  List<Expense> get todayExpenses => _todayExpenses.toList();
  double get dailyBudget => _dailyBudget.value;
  double get todaySpent => _todaySpent.value;
  double get remainingBudget => _remainingBudget.value;
  Map<String, double> get spendingTrend => _spendingTrend;
  double get threeMonthTotal => _threeMonthTotal.value;
  String get percentageChange => _percentageChange.value;
  bool get isLoadingBudget => _isLoadingBudget.value;
  bool get isLoadingExpenses => _isLoadingExpenses.value;

  // Form controllers for adding expense
  final TextEditingController amountController = TextEditingController();
  final TextEditingController merchantController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final RxString selectedCategory = ExpenseConstants.categories.first.obs;

  @override
  void onInit() {
    super.onInit();
    loadHomeData();
  }

  @override
  void onClose() {
    amountController.dispose();
    merchantController.dispose();
    noteController.dispose();
    super.onClose();
  }

  Future<void> loadHomeData() async {
    await Future.wait([
      loadBudgetData(),
      loadTodayExpenses(),
      loadSpendingTrend(),
    ]);
  }

  Future<void> loadBudgetData() async {
    try {
      _isLoadingBudget.value = true;

      final budget = await _expenseRepository.getCurrentBudget();
      final todaySpent = await _expenseRepository.getTodaySpent();

      if (budget != null) {
        _dailyBudget.value = budget.dailyAmount;
        _todaySpent.value = todaySpent;
        _remainingBudget.value = budget.dailyAmount - todaySpent;
      } else {
        // Set default budget if none exists
        await _expenseRepository.setBudget(18000); // Default 600 * 30 days
        await loadBudgetData(); // Reload after setting default
      }
    } catch (e) {
      logger.e('Error loading budget data: $e');
    } finally {
      _isLoadingBudget.value = false;
    }
  }

  Future<void> loadTodayExpenses() async {
    try {
      _isLoadingExpenses.value = true;
      final expenses = await _expenseRepository.getTodayExpenses();
      _todayExpenses.assignAll(expenses);
    } catch (e) {
      logger.e('Error loading today expenses: $e');
    } finally {
      _isLoadingExpenses.value = false;
    }
  }

  Future<void> loadSpendingTrend() async {
    try {
      final trendData = await _expenseRepository.getSpendingTrend();
      _spendingTrend.assignAll(trendData);

      // Calculate total and percentage change
      double total = trendData.values.fold(0.0, (sum, amount) => sum + amount);
      _threeMonthTotal.value = total;

      // Calculate percentage change (simplified - comparing first and last month)
      if (trendData.length >= 2) {
        final values = trendData.values.toList();
        final firstMonth = values.first;
        final lastMonth = values.last;

        if (firstMonth > 0) {
          final change = ((lastMonth - firstMonth) / firstMonth * 100);
          _percentageChange.value = '${change.toStringAsFixed(0)}%';
        }
      }
    } catch (e) {
      logger.e('Error loading spending trend: $e');
    }
  }

  Future<void> addExpense() async {
    if (!_validateExpenseForm()) return;

    try {
      final expense = Expense(
        amount: double.parse(amountController.text),
        category: selectedCategory.value,
        merchant: merchantController.text.trim(),
        note: noteController.text.trim().isEmpty ? null : noteController.text.trim(),
        date: DateTime.now(),
      );

      await _expenseRepository.addExpense(expense);

      _clearExpenseForm();

      await Future.wait([
        loadBudgetData(),
        loadTodayExpenses(),
      ]);

      Get.back(); // Close bottom sheet
      Get.snackbar('Success', 'Expense added successfully!');

    } catch (e) {
      logger.e('Error adding expense: $e');
      Get.snackbar('Error', 'Failed to add expense. Please try again.');
    }
  }

  Future<void> deleteExpense(int expenseId) async {
    try {
      await _expenseRepository.deleteExpense(expenseId);

      // Reload data
      await Future.wait([
        loadBudgetData(),
        loadTodayExpenses(),
      ]);

      Get.snackbar('Success', 'Expense deleted successfully!');
    } catch (e) {
      logger.e('Error deleting expense: $e');
      Get.snackbar('Error', 'Failed to delete expense. Please try again.');
    }
  }

  void showAddExpenseBottomSheet() {
    _clearExpenseForm();
    Get.bottomSheet(
      _buildAddExpenseBottomSheet(),
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  void showExpenseDetails(Expense expense) {
    Get.toNamed('/expense-details', arguments: expense);
  }

  Future<void> onRefresh() async {
    await loadHomeData();
  }

  bool _validateExpenseForm() {
    if (amountController.text.isEmpty) {
      Get.snackbar('Validation Error', 'Please enter an amount');
      return false;
    }

    if (double.tryParse(amountController.text) == null) {
      Get.snackbar('Validation Error', 'Please enter a valid amount');
      return false;
    }

    if (merchantController.text.trim().isEmpty) {
      Get.snackbar('Validation Error', 'Please enter a merchant name');
      return false;
    }

    return true;
  }

  void _clearExpenseForm() {
    amountController.clear();
    merchantController.clear();
    noteController.clear();
    selectedCategory.value = ExpenseConstants.categories.first;
  }

  Widget _buildAddExpenseBottomSheet() {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(Get.context!).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Title
          const Text(
            'Add Expense',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // Amount field
          TextField(
            controller: amountController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Amount',
              prefixText: '৳ ',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // Category dropdown
          Obx(() => DropdownButtonFormField<String>(
            value: selectedCategory.value,
            decoration: const InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(),
            ),
            items: ExpenseConstants.categories.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Row(
                  children: [
                    Text(
                      ExpenseConstants.categoryIcons[category] ?? '📦',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 8),
                    Text(category),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) selectedCategory.value = value;
            },
          )),
          const SizedBox(height: 16),

          // Merchant field
          TextField(
            controller: merchantController,
            decoration: const InputDecoration(
              labelText: 'Merchant',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // Note field
          TextField(
            controller: noteController,
            decoration: const InputDecoration(
              labelText: 'Note (Optional)',
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 24),

          // Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Get.back(),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: addExpense,
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}