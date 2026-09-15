import 'package:expensetracker/app/data/model/impulse_item.dart';
import 'package:flutter_test/flutter_test.dart';

ImpulseItem _item({
  required DateTime createdDate,
  required DateTime cooldownEndDate,
  ImpulseStatus status = ImpulseStatus.waiting,
}) {
  return ImpulseItem(
    id: 1,
    name: 'Headphones',
    price: 3500,
    category: 'Electronics',
    desireLevel: 4,
    createdDate: createdDate,
    cooldownPeriod: cooldownEndDate.difference(createdDate),
    cooldownEndDate: cooldownEndDate,
    status: status,
    notes: 'Wait before buying',
  );
}

void main() {
  group('ImpulseItem', () {
    test('round-trips serializable fields and preserves the enum status', () {
      final createdDate = DateTime(2026, 9, 10, 8);
      final item = _item(
        createdDate: createdDate,
        cooldownEndDate: createdDate.add(const Duration(days: 7)),
        status: ImpulseStatus.skipped,
      );

      final result = ImpulseItem.fromJson(item.toJson());

      expect(result.id, item.id);
      expect(result.name, 'Headphones');
      expect(result.price, 3500);
      expect(result.cooldownPeriod, const Duration(days: 7));
      expect(result.status, ImpulseStatus.skipped);
      expect(result.notes, 'Wait before buying');
    });

    test('reports a completed cooldown with no remaining duration', () {
      final now = DateTime.now();
      final item = _item(
        createdDate: now.subtract(const Duration(hours: 2)),
        cooldownEndDate: now.subtract(const Duration(minutes: 1)),
      );

      expect(item.isCooldownComplete, isTrue);
      expect(item.remainingCooldown, Duration.zero);
      expect(item.progressPercentage, 100);
    });

    test('reports a future cooldown with bounded progress', () {
      final now = DateTime.now();
      final item = _item(
        createdDate: now.subtract(const Duration(hours: 1)),
        cooldownEndDate: now.add(const Duration(hours: 1)),
      );

      expect(item.isCooldownComplete, isFalse);
      expect(item.remainingCooldown, greaterThan(Duration.zero));
      expect(item.progressPercentage, inInclusiveRange(49.0, 51.0));
    });

    test('copyWith records a decision without changing the original item', () {
      final now = DateTime.now();
      final item = _item(
        createdDate: now,
        cooldownEndDate: now.add(const Duration(days: 1)),
      );
      final decisionDate = now.add(const Duration(days: 1));

      final result = item.copyWith(
        status: ImpulseStatus.bought,
        decisionDate: decisionDate,
      );

      expect(item.status, ImpulseStatus.waiting);
      expect(result.status, ImpulseStatus.bought);
      expect(result.decisionDate, decisionDate);
      expect(result.name, item.name);
    });
  });
}
