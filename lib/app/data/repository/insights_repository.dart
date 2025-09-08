import 'package:expensetracker/app/data/local/database_helper.dart';
import 'package:expensetracker/app/data/model/impulse_item.dart';
import 'package:expensetracker/app/data/repository/expense_repository.dart';
import 'package:expensetracker/app/data/repository/impulse_repository.dart';

class InsightsRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final ExpenseRepository _expenseRepository = ExpenseRepository();
  final ImpulseRepository _impulseRepository = ImpulseRepository();

  // Expense Analytics
  Future<Map<String, double>> getExpensesByCategory({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final now = DateTime.now();
    final start = startDate ?? DateTime(now.year, now.month, 1);
    final end = endDate ?? now;

    final expenses = await _expenseRepository.getExpensesByDateRange(start, end);

    Map<String, double> categoryTotals = {};
    for (var expense in expenses) {
      categoryTotals[expense.category] =
          (categoryTotals[expense.category] ?? 0) + expense.amount;
    }

    return categoryTotals;
  }

  Future<double> getTotalSpending({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final now = DateTime.now();
    final start = startDate ?? DateTime(now.year, now.month, 1);
    final end = endDate ?? now;
    double total = 0.0;

    final expenses = await _expenseRepository.getExpensesByDateRange(start, end);
    for (var expense in expenses) {
      total += expense.amount;
    }
    return total;

  }

  Future<List<Map<String, dynamic>>> getWeeklySpending() async {
    final now = DateTime.now();
    final fourWeeksAgo = now.subtract(const Duration(days: 28));

    List<Map<String, dynamic>> weeklyData = [];

    for (int i = 0; i < 4; i++) {
      final weekStart = fourWeeksAgo.add(Duration(days: i * 7));
      final weekEnd = weekStart.add(const Duration(days: 6));

      final expenses = await _expenseRepository.getExpensesByDateRange(weekStart, weekEnd);
      final total = expenses.fold(0.0, (sum, expense) => sum + expense.amount);

      weeklyData.add({
        'week': 'Week ${i + 1}',
        'amount': total,
        'startDate': weekStart,
        'endDate': weekEnd,
      });
    }

    return weeklyData;
  }

  Future<Map<String, dynamic>> getSpendingComparison() async {
    final now = DateTime.now();

    // This month
    final thisMonthStart = DateTime(now.year, now.month, 1);
    final thisMonthTotal = await getTotalSpending(
      startDate: thisMonthStart,
      endDate: now,
    );

    // Last month
    final lastMonthStart = DateTime(now.year, now.month - 1, 1);
    final lastMonthEnd = DateTime(now.year, now.month, 0);
    final lastMonthTotal = await getTotalSpending(
      startDate: lastMonthStart,
      endDate: lastMonthEnd,
    );

    // Calculate percentage change
    double percentageChange = 0.0;
    if (lastMonthTotal > 0) {
      percentageChange = ((thisMonthTotal - lastMonthTotal) / lastMonthTotal) * 100;
    }

    return {
      'thisMonth': thisMonthTotal,
      'lastMonth': lastMonthTotal,
      'percentageChange': percentageChange,
    };
  }

  Future<String> getTopSpendingCategory({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final categoryTotals = await getExpensesByCategory(
      startDate: startDate,
      endDate: endDate,
    );

    if (categoryTotals.isEmpty) return 'None';

    return categoryTotals.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  // Impulse Purchase Analytics
  Future<double> getImpulseSavings() async {
    return await _impulseRepository.getTotalSavings();
  }

  Future<Map<String, int>> getImpulseStats() async {
    return await _impulseRepository.getStats();
  }

  Future<List<Map<String, dynamic>>> getWeeklyImpulseDecisions() async {
    final now = DateTime.now();
    final fourWeeksAgo = now.subtract(const Duration(days: 28));

    final allItems = await _impulseRepository.getAllImpulseItems();

    List<Map<String, dynamic>> weeklyData = [];

    for (int i = 0; i < 4; i++) {
      final weekStart = fourWeeksAgo.add(Duration(days: i * 7));
      final weekEnd = weekStart.add(const Duration(days: 6));

      final weekItems = allItems.where((item) {
        final decisionDate = item.decisionDate;
        return decisionDate != null &&
            decisionDate.isAfter(weekStart) &&
            decisionDate.isBefore(weekEnd.add(const Duration(days: 1)));
      }).toList();

      weeklyData.add({
        'week': 'Week ${i + 1}',
        'decisions': weekItems.length,
        'skipped': weekItems.where((item) => item.status == ImpulseStatus.skipped).length,
        'bought': weekItems.where((item) => item.status == ImpulseStatus.bought).length,
      });
    }

    return weeklyData;
  }

  Future<double> getImpulseSavingsGoalProgress() async {
    final totalSaved = await getImpulseSavings();
    final goal = 5000.0; // Default goal, could be configurable
    return (totalSaved / goal).clamp(0.0, 1.0);
  }

  // Combined Analytics
  Future<Map<String, dynamic>> getWeeklySummary() async {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));

    final weeklySpending = await getTotalSpending(
      startDate: weekStart,
      endDate: now,
    );

    final topCategory = await getTopSpendingCategory(
      startDate: weekStart,
      endDate: now,
    );

    final impulseItems = await _impulseRepository.getAllImpulseItems();
    final weeklyImpulseDecisions = impulseItems.where((item) {
      final decisionDate = item.decisionDate;
      return decisionDate != null &&
          decisionDate.isAfter(weekStart) &&
          decisionDate.isBefore(weekEnd.add(const Duration(days: 1)));
    }).length;

    return {
      'totalSpending': weeklySpending,
      'topCategory': topCategory,
      'impulseDecisions': weeklyImpulseDecisions,
    };
  }

  Future<Map<String, dynamic>> getMonthlySummary() async {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);

    final monthlySpending = await getTotalSpending(
      startDate: monthStart,
      endDate: now,
    );

    final topCategory = await getTopSpendingCategory(
      startDate: monthStart,
      endDate: now,
    );

    final impulseItems = await _impulseRepository.getAllImpulseItems();
    final monthlyImpulseDecisions = impulseItems.where((item) {
      final decisionDate = item.decisionDate;
      return decisionDate != null &&
          decisionDate.year == now.year &&
          decisionDate.month == now.month;
    }).length;

    return {
      'totalSpending': monthlySpending,
      'topCategory': topCategory,
      'impulseDecisions': monthlyImpulseDecisions,
    };
  }
}