import 'package:expensetracker/app/data/local/database_helper.dart';
import 'package:expensetracker/app/data/model/expense.dart';
import 'package:expensetracker/app/data/model/budget.dart';

class ExpenseRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Expense operations
  Future<int> addExpense(Expense expense) async {
    return await _databaseHelper.insertExpense(expense);
  }

  Future<List<Expense>> getTodayExpenses() async {
    return await _databaseHelper.getExpensesByDate(DateTime.now());
  }

  Future<List<Expense>> getExpensesByDateRange(DateTime start, DateTime end) async {
    return await _databaseHelper.getExpensesByDateRange(start, end);
  }

  Future<double> getTodaySpent() async {
    return await _databaseHelper.getTotalSpentForDate(DateTime.now());
  }

  Future<Map<String, double>> getSpendingTrend() async {
    return await _databaseHelper.getSpendingTrendData();
  }

  Future<int> updateExpense(Expense expense) async {
    return await _databaseHelper.updateExpense(expense);
  }

  Future<int> deleteExpense(int id) async {
    return await _databaseHelper.deleteExpense(id);
  }

  Future<int> setBudget(double monthlyAmount) async {
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final dailyAmount = monthlyAmount / daysInMonth;

    final existingBudget = await _databaseHelper.getCurrentBudget();

    if (existingBudget != null) {
      final updatedBudget = Budget(
        id: existingBudget.id,
        monthlyAmount: monthlyAmount,
        dailyAmount: dailyAmount,
        month: currentMonth,
      );
      return await _databaseHelper.updateBudget(updatedBudget);
    } else {
      final newBudget = Budget(
        monthlyAmount: monthlyAmount,
        dailyAmount: dailyAmount,
        month: currentMonth,
      );
      return await _databaseHelper.insertBudget(newBudget);
    }
  }

  Future<Budget?> getCurrentBudget() async {
    return await _databaseHelper.getCurrentBudget();
  }
  Future<int> updateBudget(double monthlyAmount) async {
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final dailyAmount = monthlyAmount / daysInMonth;

    final existingBudget = await _databaseHelper.getCurrentBudget();

    if (existingBudget != null) {
      final updatedBudget = Budget(
        id: existingBudget.id,
        monthlyAmount: monthlyAmount,
        dailyAmount: dailyAmount,
        month: currentMonth,
      );
      return await _databaseHelper.updateBudget(updatedBudget);
    } else {
      return await setBudget(monthlyAmount);
    }
  }
  Future<double> getRemainingBudgetForToday() async {
    final budget = await getCurrentBudget();
    if (budget == null) return 0.0;

    final todaySpent = await getTodaySpent();
    return budget.dailyAmount - todaySpent;
  }
}