// app/modules/home/views/home_view.dart
import 'package:expensetracker/app/core/base/base_view.dart';
import 'package:expensetracker/app/core/values/app_values.dart';
import 'package:expensetracker/app/core/values/expense_constants.dart';
import 'package:expensetracker/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeView extends BaseView<HomeController> {
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'Today',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      actions: [
        IconButton(
          onPressed: () => controller.showAddExpenseBottomSheet(),
          icon: const Icon(
            Icons.add,
            color: Colors.black,
            size: 28,
          ),
        ),
      ],
    );
  }

  @override
  Widget body(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.onRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppValues.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDailyBudgetSection(),
            const SizedBox(height: 24),
            _buildExpensesSection(),
            const SizedBox(height: 24),
            _buildSpendingTrendSection(),
            const SizedBox(height: 100), // Bottom padding for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildDailyBudgetSection() {
    return Obx(() {
      if (controller.isLoadingBudget) {
        return const Card(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Center(child: CircularProgressIndicator()),
          ),
        );
      }

      final budgetProgress = controller.dailyBudget > 0
          ? controller.todaySpent / controller.dailyBudget
          : 0.0;

      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Daily Budget',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    NumberFormat.currency(symbol: '৳', decimalDigits: 0)
                        .format(controller.dailyBudget),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Progress bar
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: budgetProgress.clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: budgetProgress > 1.0 ? Colors.red : Colors.blue,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Text(
                '${NumberFormat.currency(symbol: '৳', decimalDigits: 0).format(controller.remainingBudget.abs())} ${controller.remainingBudget >= 0 ? 'remaining' : 'over budget'}',
                style: TextStyle(
                  fontSize: 16,
                  color: controller.remainingBudget >= 0 ? Colors.blue : Colors.red,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildExpensesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Expenses',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        Obx(() {
          if (controller.isLoadingExpenses) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.todayExpenses.isEmpty) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.receipt_long,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No expenses today',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap + to add your first expense',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.todayExpenses.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final expense = controller.todayExpenses[index];
              return _buildExpenseItem(expense);
            },
          );
        }),
      ],
    );
  }

  Widget _buildExpenseItem(expense) {
    final categoryIcon = ExpenseConstants.categoryIcons[expense.category] ?? '📦';
    final categoryColor = Color(ExpenseConstants.categoryColors[expense.category] ?? 0xFF607D8B);

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: categoryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              categoryIcon,
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ),
        title: Text(
          NumberFormat.currency(symbol: '৳', decimalDigits: 0).format(expense.amount),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              expense.category,
              style: const TextStyle(fontSize: 14),
            ),
            if (expense.merchant.isNotEmpty)
              Text(
                expense.merchant,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert, size: 20),
          onPressed: () => _showExpenseOptions(expense),
        ),
        onTap: () => controller.showExpenseDetails(expense),
      ),
    );
  }

  Widget _buildSpendingTrendSection() {
    return Obx(() {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Spending Trend',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Text(
                    NumberFormat.currency(symbol: '৳', decimalDigits: 0)
                        .format(controller.threeMonthTotal),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: controller.percentageChange.startsWith('-')
                          ? Colors.green.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      controller.percentageChange,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: controller.percentageChange.startsWith('-')
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Text(
                'Last 3 Months',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),

              const SizedBox(height: 20),

              // Simple trend visualization
              Container(
                height: 80,
                child: _buildSimpleTrendChart(),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildSimpleTrendChart() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          'Spending trend chart\n(Implementation needed)',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  void _showExpenseOptions(expense) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),

            ListTile(
              leading: const Icon(Icons.visibility),
              title: const Text('View Details'),
              onTap: () {
                Get.back();
                controller.showExpenseDetails(expense);
              },
            ),

            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit'),
              onTap: () {
                Get.back();
                // TODO: Implement edit functionality
                Get.snackbar('Info', 'Edit functionality coming soon!');
              },
            ),

            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                Get.back();
                _confirmDeleteExpense(expense);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteExpense(expense) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Expense'),
        content: const Text('Are you sure you want to delete this expense?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteExpense(expense.id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}