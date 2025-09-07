import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:expensetracker/app/core/base/base_controller.dart';
import 'package:expensetracker/app/data/repository/expense_repository.dart';
import 'package:expensetracker/app/data/model/expense.dart';
import 'package:expensetracker/app/core/values/expense_constants.dart';

class HomeController extends BaseController {
  final ExpenseRepository _expenseRepository = Get.put(ExpenseRepository());

  final RxList<Expense> _todayExpenses = RxList<Expense>();
  final RxDouble _dailyBudget = 0.0.obs;
  final RxDouble _todaySpent = 0.0.obs;
  final RxDouble _remainingBudget = 0.0.obs;
  final RxMap<String, double> _spendingTrend = RxMap<String, double>();
  final RxDouble _threeMonthTotal = 0.0.obs;
  final RxString _percentageChange = '0%'.obs;
  final RxBool _isLoadingBudget = true.obs;
  final RxBool _isLoadingExpenses = true.obs;

  List<Expense> get todayExpenses => _todayExpenses.toList();
  double get dailyBudget => _dailyBudget.value;
  double get todaySpent => _todaySpent.value;
  double get remainingBudget => _remainingBudget.value;
  Map<String, double> get spendingTrend => _spendingTrend;
  double get threeMonthTotal => _threeMonthTotal.value;
  String get percentageChange => _percentageChange.value;
  bool get isLoadingBudget => _isLoadingBudget.value;
  bool get isLoadingExpenses => _isLoadingExpenses.value;

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
        await _expenseRepository.setBudget(18000);
        await loadBudgetData();
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

      double total = trendData.values.fold(0.0, (sum, amount) => sum + amount);
      _threeMonthTotal.value = total;

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

      Get.back();
      Get.snackbar('Success', 'Expense added successfully!');

    } catch (e) {
      logger.e('Error adding expense: $e');
      Get.snackbar('Error', 'Failed to add expense. Please try again.');
    }
  }

  Future<void> deleteExpense(int expenseId) async {
    try {
      await _expenseRepository.deleteExpense(expenseId);

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
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 20,
          bottom: MediaQuery.of(Get.context!).viewInsets.bottom + 24,
        ),
        child: ListView(
          physics: ScrollPhysics(),
          children: [
            // Enhanced Handle Bar
            Center(
              child: Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.grey.shade300, Colors.grey.shade400],
                  ),
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Enhanced Title with Icon
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade400, Colors.blue.shade600],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.add_card_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Add Expense',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Enhanced Amount Field
            _buildStyledTextField(
              controller: amountController,
              label: 'Amount',
              prefixText: '৳ ',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              icon: Icons.attach_money_rounded,
              iconColor: Colors.green.shade600,
            ),
            const SizedBox(height: 20),

            // Enhanced Category Dropdown
            Obx(() => _buildStyledDropdown(
              value: selectedCategory.value,
              label: 'Category',
              icon: Icons.category_rounded,
              iconColor: Colors.purple.shade600,
              items: ExpenseConstants.categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color(ExpenseConstants.categoryColors[category] ?? 0xFF607D8B)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            ExpenseConstants.categoryIcons[category] ?? '📦',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          category,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) selectedCategory.value = value;
              },
            )),
            const SizedBox(height: 20),

            // Enhanced Merchant Field
            _buildStyledTextField(
              controller: merchantController,
              label: 'Merchant',
              icon: Icons.store_rounded,
              iconColor: Colors.orange.shade600,
            ),
            const SizedBox(height: 20),

            // Enhanced Note Field
            _buildStyledTextField(
              controller: noteController,
              label: 'Note (Optional)',
              icon: Icons.note_rounded,
              iconColor: Colors.blue.shade600,
              maxLines: 3,
            ),
            const SizedBox(height: 32),

            // Enhanced Action Buttons
            Row(
              children: [
                Expanded(
                  child: _buildCancelButton(),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: _buildSaveButton(),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildStyledTextField({
    required TextEditingController controller,
    required String label,
    String? prefixText,
    TextInputType? keyboardType,
    required IconData icon,
    required Color iconColor,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          labelText: label,
          prefixText: prefixText,
          prefixStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: iconColor,
          ),
          labelStyle: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: iconColor, width: 2),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildStyledDropdown({
    required String value,
    required String label,
    required IconData icon,
    required Color iconColor,
    required List<DropdownMenuItem<String>> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items,
        onChanged: onChanged,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: iconColor, width: 2),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
        dropdownColor: Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: 8,
        icon: Container(
          margin: const EdgeInsets.only(right: 12),
          child: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: iconColor,
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildCancelButton() {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Get.back(),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Colors.grey.shade50,
                ],
              ),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.close_rounded,
                    color: Colors.grey.shade600,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade400,
            Colors.blue.shade600,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.blue.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: addExpense,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(0.2),
                  Colors.transparent,
                ],
              ),
            ),
            child: const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.save_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Save Expense',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}