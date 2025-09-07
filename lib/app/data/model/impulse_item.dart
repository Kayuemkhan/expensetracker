class ImpulseItem {
  final int? id;
  final String name;
  final double price;
  final String category;
  final int desireLevel; // 1-5 stars
  final DateTime createdDate;
  final Duration cooldownPeriod;
  final DateTime cooldownEndDate;
  final ImpulseStatus status;
  final DateTime? decisionDate;
  final String? notes;

  ImpulseItem({
    this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.desireLevel,
    required this.createdDate,
    required this.cooldownPeriod,
    required this.cooldownEndDate,
    this.status = ImpulseStatus.waiting,
    this.decisionDate,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'category': category,
      'desireLevel': desireLevel,
      'createdDate': createdDate.millisecondsSinceEpoch,
      'cooldownPeriodHours': cooldownPeriod.inHours,
      'cooldownEndDate': cooldownEndDate.millisecondsSinceEpoch,
      'status': status.index,
      'decisionDate': decisionDate?.millisecondsSinceEpoch,
      'notes': notes,
    };
  }

  factory ImpulseItem.fromJson(Map<String, dynamic> json) {
    return ImpulseItem(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      category: json['category'],
      desireLevel: json['desireLevel'],
      createdDate: DateTime.fromMillisecondsSinceEpoch(json['createdDate']),
      cooldownPeriod: Duration(hours: json['cooldownPeriodHours']),
      cooldownEndDate: DateTime.fromMillisecondsSinceEpoch(json['cooldownEndDate']),
      status: ImpulseStatus.values[json['status']],
      decisionDate: json['decisionDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['decisionDate'])
          : null,
      notes: json['notes'],
    );
  }

  ImpulseItem copyWith({
    int? id,
    String? name,
    double? price,
    String? category,
    int? desireLevel,
    DateTime? createdDate,
    Duration? cooldownPeriod,
    DateTime? cooldownEndDate,
    ImpulseStatus? status,
    DateTime? decisionDate,
    String? notes,
  }) {
    return ImpulseItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      category: category ?? this.category,
      desireLevel: desireLevel ?? this.desireLevel,
      createdDate: createdDate ?? this.createdDate,
      cooldownPeriod: cooldownPeriod ?? this.cooldownPeriod,
      cooldownEndDate: cooldownEndDate ?? this.cooldownEndDate,
      status: status ?? this.status,
      decisionDate: decisionDate ?? this.decisionDate,
      notes: notes ?? this.notes,
    );
  }

  bool get isCooldownComplete => DateTime.now().isAfter(cooldownEndDate);

  Duration get remainingCooldown {
    if (isCooldownComplete) return Duration.zero;
    return cooldownEndDate.difference(DateTime.now());
  }

  double get progressPercentage {
    final totalDuration = cooldownEndDate.difference(createdDate);
    final elapsed = DateTime.now().difference(createdDate);
    final progress = elapsed.inMilliseconds / totalDuration.inMilliseconds;
    return (progress * 100).clamp(0.0, 100.0);
  }
}

enum ImpulseStatus {
  waiting,    // Still in cooldown
  bought,     // User decided to buy
  skipped,    // User decided to skip
}