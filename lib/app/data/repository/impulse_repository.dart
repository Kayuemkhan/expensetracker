import 'package:expensetracker/app/data/local/database_helper.dart';
import 'package:expensetracker/app/data/model/impulse_item.dart';

class ImpulseRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Add new impulse item
  Future<int> addImpulseItem(ImpulseItem item) async {
    return await _databaseHelper.insertImpulseItem(item);
  }

  // Get all impulse items
  Future<List<ImpulseItem>> getAllImpulseItems() async {
    return await _databaseHelper.getAllImpulseItems();
  }

  // Get items by status
  Future<List<ImpulseItem>> getItemsByStatus(ImpulseStatus status) async {
    return await _databaseHelper.getImpulseItemsByStatus(status);
  }

  // Get waiting items (still in cooldown)
  Future<List<ImpulseItem>> getWaitingItems() async {
    return await _databaseHelper.getWaitingImpulseItems();
  }

  // Get completed items (bought or skipped)
  Future<List<ImpulseItem>> getCompletedItems() async {
    return await _databaseHelper.getCompletedImpulseItems();
  }

  // Make decision on impulse item
  Future<int> makeDecision(int itemId, ImpulseStatus decision) async {
    final items = await getAllImpulseItems();
    final item = items.firstWhere((item) => item.id == itemId);

    final updatedItem = item.copyWith(
      status: decision,
      decisionDate: DateTime.now(),
    );

    return await _databaseHelper.updateImpulseItem(updatedItem);
  }

  // Update impulse item
  Future<int> updateImpulseItem(ImpulseItem item) async {
    return await _databaseHelper.updateImpulseItem(item);
  }

  // Delete impulse item
  Future<int> deleteImpulseItem(int id) async {
    return await _databaseHelper.deleteImpulseItem(id);
  }

  // Get total savings from skipped items
  Future<double> getTotalSavings() async {
    return await _databaseHelper.getTotalSavedFromSkippedItems();
  }

  // Get statistics
  Future<Map<String, int>> getStats() async {
    return await _databaseHelper.getImpulseItemStats();
  }

  // Get items that completed cooldown recently (for notifications)
  Future<List<ImpulseItem>> getRecentlyCompletedCooldowns() async {
    final waitingItems = await getWaitingItems();
    final now = DateTime.now();

    return waitingItems.where((item) {
      final completedAt = item.cooldownEndDate;
      final timeSinceCompleted = now.difference(completedAt);

      // Items that completed in the last hour
      return completedAt.isBefore(now) && timeSinceCompleted.inHours < 1;
    }).toList();
  }

  // Get success rate (percentage of items skipped vs bought)
  Future<double> getSuccessRate() async {
    final stats = await getStats();
    final total = stats['bought']! + stats['skipped']!;

    if (total == 0) return 0.0;

    return (stats['skipped']! / total) * 100;
  }
}