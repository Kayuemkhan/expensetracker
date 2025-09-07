class Expense {
  final int? id;
  final double amount;
  final String category;
  final String? note;
  final DateTime date;
  final String merchant;

  Expense({
    this.id,
    required this.amount,
    required this.category,
    this.note,
    required this.date,
    required this.merchant,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'category': category,
      'note': note,
      'date': date.millisecondsSinceEpoch,
      'merchant': merchant,
    };
  }

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      amount: json['amount'],
      category: json['category'],
      note: json['note'],
      date: DateTime.fromMillisecondsSinceEpoch(json['date']),
      merchant: json['merchant'],
    );
  }

  Expense copyWith({
    int? id,
    double? amount,
    String? category,
    String? note,
    DateTime? date,
    String? merchant,
  }) {
    return Expense(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      note: note ?? this.note,
      date: date ?? this.date,
      merchant: merchant ?? this.merchant,
    );
  }
}

