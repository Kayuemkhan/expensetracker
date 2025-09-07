class Budget {
  final int? id;
  final double monthlyAmount;
  final double dailyAmount;
  final DateTime month;

  Budget({
    this.id,
    required this.monthlyAmount,
    required this.dailyAmount,
    required this.month,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'monthlyAmount': monthlyAmount,
      'dailyAmount': dailyAmount,
      'month': month.millisecondsSinceEpoch,
    };
  }

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'],
      monthlyAmount: json['monthlyAmount'],
      dailyAmount: json['dailyAmount'],
      month: DateTime.fromMillisecondsSinceEpoch(json['month']),
    );
  }
}