import 'package:expensetracker/app/data/model/budget.dart';
import 'package:expensetracker/app/data/model/expense.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Expense model', () {
    test('serializes, deserializes, and preserves every field', () {
      final date = DateTime(2026, 9, 15, 10, 30);
      final expense = Expense(
        id: 7,
        amount: 250.50,
        category: 'Food',
        merchant: 'Lunch Corner',
        note: 'Team lunch',
        date: date,
      );

      final result = Expense.fromJson(expense.toJson());

      expect(result.id, 7);
      expect(result.amount, 250.50);
      expect(result.category, 'Food');
      expect(result.merchant, 'Lunch Corner');
      expect(result.note, 'Team lunch');
      expect(result.date, date);
    });

    test('copyWith changes only the supplied values', () {
      final original = Expense(
        id: 7,
        amount: 250,
        category: 'Food',
        merchant: 'Lunch Corner',
        note: 'Team lunch',
        date: DateTime(2026, 9, 15),
      );

      final result = original.copyWith(amount: 400, category: 'Transport');

      expect(result.id, original.id);
      expect(result.amount, 400);
      expect(result.category, 'Transport');
      expect(result.merchant, original.merchant);
      expect(result.note, original.note);
      expect(result.date, original.date);
    });
  });

  group('Budget model', () {
    test('round-trips its month and calculated amounts through JSON', () {
      final budget = Budget(
        id: 3,
        monthlyAmount: 9000,
        dailyAmount: 300,
        month: DateTime(2026, 9),
      );

      final result = Budget.fromJson(budget.toJson());

      expect(result.id, 3);
      expect(result.monthlyAmount, 9000);
      expect(result.dailyAmount, 300);
      expect(result.month, DateTime(2026, 9));
    });
  });
}
