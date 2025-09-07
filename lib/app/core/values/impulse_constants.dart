class ImpulseConstants {
  static const List<Duration> cooldownOptions = [
    Duration(hours: 24),    // 24 hours
    Duration(hours: 48),    // 48 hours
    Duration(days: 7),      // 7 days
  ];

  static  Map<Duration, String> cooldownLabels = {
    Duration(hours: 24): '24 Hours',
    Duration(hours: 48): '48 Hours',
    Duration(days: 7): '7 Days',
  };

  static const List<String> impulseCategories = [
    'Electronics',
    'Clothing',
    'Books',
    'Gadgets',
    'Home & Garden',
    'Sports',
    'Entertainment',
    'Food & Drinks',
    'Beauty',
    'Other',
  ];

  static const Map<String, String> impulseCategoryIcons = {
    'Electronics': '📱',
    'Clothing': '👕',
    'Books': '📚',
    'Gadgets': '🔧',
    'Home & Garden': '🏠',
    'Sports': '⚽',
    'Entertainment': '🎬',
    'Food & Drinks': '🍕',
    'Beauty': '💄',
    'Other': '📦',
  };

  static const Map<String, int> impulseCategoryColors = {
    'Electronics': 0xFF2196F3,
    'Clothing': 0xFFE91E63,
    'Books': 0xFF8BC34A,
    'Gadgets': 0xFFFF9800,
    'Home & Garden': 0xFF4CAF50,
    'Sports': 0xFFFF5722,
    'Entertainment': 0xFF9C27B0,
    'Food & Drinks': 0xFFFFC107,
    'Beauty': 0xFFE91E63,
    'Other': 0xFF607D8B,
  };
}