import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:expensetracker/app/core/base/base_controller.dart';
import 'package:expensetracker/app/data/repository/expense_repository.dart';
import 'package:expensetracker/app/data/model/expense.dart';
import 'package:expensetracker/app/core/values/expense_constants.dart';

class QuickExpenseController extends BaseController {
  final ExpenseRepository _expenseRepository = Get.find<ExpenseRepository>();

  // Form controllers
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // Observables
  final RxString selectedCategory = ExpenseConstants.categories.first.obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  // Budget data
  final RxDouble _dailyBudget = 0.0.obs;
  final RxDouble _todaySpent = 0.0.obs;
  final RxDouble _remainingBudget = 0.0.obs;
  final RxBool _isLoadingBudget = true.obs;

  // Getters
  double get dailyBudget => _dailyBudget.value;
  double get todaySpent => _todaySpent.value;
  double get remainingBudget => _remainingBudget.value;
  bool get isLoadingBudget => _isLoadingBudget.value;

  @override
  void onInit() {
    super.onInit();
    loadBudgetData();
  }

  @override
  void onClose() {
    amountController.dispose();
    descriptionController.dispose();
    super.onClose();
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

  Future<void> selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: selectedDate.value,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
    }
  }

  Future<void> addExpense() async {
    if (!_validateForm()) return;

    try {
      final expense = Expense(
        amount: double.parse(amountController.text),
        category: selectedCategory.value,
        merchant: descriptionController.text.trim(),
        note: null, // Using merchant field for description as per your design
        date: selectedDate.value,
      );

      await _expenseRepository.addExpense(expense);

      // Clear form
      _clearForm();

      // Show success message
      Get.snackbar(
        'Success',
        'Expense added successfully!',
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade800,
        duration: const Duration(seconds: 2),
      );

      // Go back to previous screen
      Get.back();

    } catch (e) {
      logger.e('Error adding expense: $e');
      Get.snackbar(
        'Error',
        'Failed to add expense. Please try again.',
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
    }
  }

  bool _validateForm() {
    if (amountController.text.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter an amount',
        backgroundColor: Colors.orange.shade100,
        colorText: Colors.orange.shade800,
      );
      return false;
    }

    final amount = double.tryParse(amountController.text);
    if (amount == null || amount <= 0) {
      Get.snackbar(
        'Validation Error',
        'Please enter a valid amount',
        backgroundColor: Colors.orange.shade100,
        colorText: Colors.orange.shade800,
      );
      return false;
    }

    if (descriptionController.text.trim().isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter a description',
        backgroundColor: Colors.orange.shade100,
        colorText: Colors.orange.shade800,
      );
      return false;
    }

    return true;
  }

  void _clearForm() {
    amountController.clear();
    descriptionController.clear();
    selectedCategory.value = ExpenseConstants.categories.first;
    selectedDate.value = DateTime.now();
  }
}