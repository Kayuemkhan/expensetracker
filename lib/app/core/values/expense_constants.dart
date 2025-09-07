// app/core/values/expense_constants.dart
class ExpenseConstants {
  static const List<String> categories = [
    'Food',
    'Rent',
    'Transport',
    'Shopping',
    'Utilities',
    'Other',
  ];

  static const Map<String, String> categoryIcons = {
    'Food': '🍴',
    'Rent': '🏠',
    'Transport': '🚌',
    'Shopping': '🛒',
    'Utilities': '💡',
    'Other': '📦',
  };

  static const Map<String, int> categoryColors = {
    'Food': 0xFF4CAF50,
    'Rent': 0xFF2196F3,
    'Transport': 0xFFFF9800,
    'Shopping': 0xFFE91E63,
    'Utilities': 0xFF9C27B0,
    'Other': 0xFF607D8B,
  };
}

