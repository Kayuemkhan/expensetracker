import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:expensetracker/app/core/base/base_controller.dart';
import 'package:expensetracker/app/data/repository/impulse_repository.dart';
import 'package:expensetracker/app/data/model/impulse_item.dart';
import 'package:expensetracker/app/core/values/impulse_constants.dart';
import 'dart:async';

// app/modules/journal/controllers/journal_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:expensetracker/app/core/base/base_controller.dart';
import 'package:expensetracker/app/data/repository/impulse_repository.dart';
import 'package:expensetracker/app/data/model/impulse_item.dart';
import 'package:expensetracker/app/core/values/impulse_constants.dart';
import 'dart:async';

import '../../../services/notification_service.dart';

class JournalController extends BaseController {
  final ImpulseRepository _impulseRepository = Get.find<ImpulseRepository>();

  // Tab management
  final RxInt currentTabIndex = 0.obs;

  // Data observables
  final RxList<ImpulseItem> _waitingItems = RxList<ImpulseItem>();
  final RxList<ImpulseItem> _completedItems = RxList<ImpulseItem>();
  final RxDouble _totalSavings = 0.0.obs;
  final RxMap<String, int> _stats = RxMap<String, int>();
  final RxBool _isLoading = true.obs;

  // Form controllers for adding new impulse item
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final RxString selectedCategory = ImpulseConstants.impulseCategories.first.obs;
  final RxInt selectedDesireLevel = 3.obs;
  final Rx<Duration> selectedCooldown = ImpulseConstants.cooldownOptions.first.obs;

  // Timer for updating countdown
  Timer? _countdownTimer;

  // Getters
  List<ImpulseItem> get waitingItems => _waitingItems.toList();
  List<ImpulseItem> get completedItems => _completedItems.toList();
  double get totalSavings => _totalSavings.value;
  Map<String, int> get stats => _stats;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    loadJournalData();
    _startCountdownTimer();
  }

  @override
  void onClose() {
    nameController.dispose();
    priceController.dispose();
    notesController.dispose();
    _countdownTimer?.cancel();
    super.onClose();
  }

  Future<void> loadJournalData() async {
    try {
      _isLoading.value = true;

      await Future.wait([
        loadWaitingItems(),
        loadCompletedItems(),
        loadSavings(),
        loadStats(),
      ]);
    } catch (e) {
      logger.e('Error loading journal data: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> loadWaitingItems() async {
    try {
      final items = await _impulseRepository.getWaitingItems();
      _waitingItems.assignAll(items);
    } catch (e) {
      logger.e('Error loading waiting items: $e');
    }
  }

  Future<void> loadCompletedItems() async {
    try {
      final items = await _impulseRepository.getCompletedItems();
      _completedItems.assignAll(items);
    } catch (e) {
      logger.e('Error loading completed items: $e');
    }
  }

  Future<void> loadSavings() async {
    try {
      final savings = await _impulseRepository.getTotalSavings();
      _totalSavings.value = savings;
    } catch (e) {
      logger.e('Error loading savings: $e');
    }
  }

  Future<void> loadStats() async {
    try {
      final statistics = await _impulseRepository.getStats();
      _stats.assignAll(statistics);
    } catch (e) {
      logger.e('Error loading stats: $e');
    }
  }

  void _startCountdownTimer() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Force refresh of waiting items to update countdown displays
      _waitingItems.refresh();
    });
  }

  Future<void> addImpulseItem() async {
    if (!_validateForm()) return;

    try {
      final now = DateTime.now();
      final cooldownEnd = now.add(selectedCooldown.value);

      final item = ImpulseItem(
        name: nameController.text.trim(),
        price: double.parse(priceController.text),
        category: selectedCategory.value,
        desireLevel: selectedDesireLevel.value,
        createdDate: now,
        cooldownPeriod: selectedCooldown.value,
        cooldownEndDate: cooldownEnd,
        notes: notesController.text.trim().isEmpty ? null : notesController.text.trim(),
      );

      final itemId = await _impulseRepository.addImpulseItem(item);

      // Schedule notification for cooldown completion
      try {
        if (Get.isRegistered<NotificationService>()) {
          final notificationService = Get.find<NotificationService>();
          await notificationService.scheduleImpulseCooldownNotification(
            itemId: itemId,
            itemName: item.name,
            scheduledTime: cooldownEnd,
          );
        }
      } catch (e) {
        logger.w('Failed to schedule notification: $e');
      }

      // Clear form
      _clearForm();

      // Reload data
      await loadJournalData();

      Get.back(); // Close bottom sheet
      Get.snackbar(
        'Success',
        'Impulse item added! Cooldown started.',
        backgroundColor: Colors.blue.shade100,
        colorText: Colors.blue.shade800,
      );

    } catch (e) {
      logger.e('Error adding impulse item: $e');
      Get.snackbar(
        'Error',
        'Failed to add item. Please try again.',
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
    }
  }

  Future<void> makeDecision(int itemId, ImpulseStatus decision) async {
    try {
      await _impulseRepository.makeDecision(itemId, decision);

      // Cancel notification since decision is made
      try {
        if (Get.isRegistered<NotificationService>()) {
          final notificationService = Get.find<NotificationService>();
          await notificationService.cancelImpulseNotification(itemId);
        }
      } catch (e) {
        logger.w('Failed to cancel notification: $e');
      }

      // Check for savings milestone if item was skipped
      if (decision == ImpulseStatus.skipped) {
        await _checkSavingsMilestone();
      }

      // Reload data
      await loadJournalData();

      final message = decision == ImpulseStatus.bought
          ? 'Item purchased!'
          : 'Great job! Money saved 💰';

      final color = decision == ImpulseStatus.bought
          ? Colors.orange
          : Colors.green;

      Get.snackbar(
        decision == ImpulseStatus.bought ? 'Purchase Made' : 'Money Saved!',
        message,
        backgroundColor: color.shade100,
        colorText: color.shade800,
      );

    } catch (e) {
      logger.e('Error making decision: $e');
      Get.snackbar(
        'Error',
        'Failed to update item. Please try again.',
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
    }
  }

  Future<void> _checkSavingsMilestone() async {
    try {
      final totalSaved = await _impulseRepository.getTotalSavings();

      // Check if we hit a milestone (every 1000, 5000, 10000)
      final milestones = [1000, 5000, 10000, 20000, 50000];

      for (final milestone in milestones) {
        if (totalSaved >= milestone && (totalSaved - milestone) < 1000) {
          if (Get.isRegistered<NotificationService>()) {
            final notificationService = Get.find<NotificationService>();
            await notificationService.showSavingsMilestoneNotification(totalSaved);
          }
          break;
        }
      }
    } catch (e) {
      logger.w('Failed to check savings milestone: $e');
    }
  }

  Future<void> deleteImpulseItem(int itemId) async {
    try {
      await _impulseRepository.deleteImpulseItem(itemId);

      // Reload data
      await loadJournalData();

      Get.snackbar(
        'Success',
        'Item deleted successfully!',
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade800,
      );

    } catch (e) {
      logger.e('Error deleting impulse item: $e');
      Get.snackbar(
        'Error',
        'Failed to delete item. Please try again.',
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
    }
  }

  void showAddImpulseBottomSheet() {
    _clearForm();
    Get.bottomSheet(
      _buildAddImpulseBottomSheet(),
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  void changeTab(int index) {
    currentTabIndex.value = index;
  }

  Future<void> onRefresh() async {
    await loadJournalData();
  }

  bool _validateForm() {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter an item name',
        backgroundColor: Colors.orange.shade100,
        colorText: Colors.orange.shade800,
      );
      return false;
    }

    final price = double.tryParse(priceController.text);
    if (price == null || price <= 0) {
      Get.snackbar(
        'Validation Error',
        'Please enter a valid price',
        backgroundColor: Colors.orange.shade100,
        colorText: Colors.orange.shade800,
      );
      return false;
    }

    return true;
  }

  void _clearForm() {
    nameController.clear();
    priceController.clear();
    notesController.clear();
    selectedCategory.value = ImpulseConstants.impulseCategories.first;
    selectedDesireLevel.value = 3;
    selectedCooldown.value = ImpulseConstants.cooldownOptions.first;
  }

  Widget _buildAddImpulseBottomSheet() {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(Get.context!).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Title
          const Text(
            'Add Impulse Item',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // Item name
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Item Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // Price
          TextField(
            controller: priceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Price',
              prefixText: '৳ ',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // Category dropdown
          Obx(() => DropdownButtonFormField<String>(
            value: selectedCategory.value,
            decoration: const InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(),
            ),
            items: ImpulseConstants.impulseCategories.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Row(
                  children: [
                    Text(
                      ImpulseConstants.impulseCategoryIcons[category] ?? '📦',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 8),
                    Text(category),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) selectedCategory.value = value;
            },
          )),
          const SizedBox(height: 16),

          // Desire level
          Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Desire Level: ${selectedDesireLevel.value} stars'),
              Slider(
                value: selectedDesireLevel.value.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                onChanged: (value) => selectedDesireLevel.value = value.toInt(),
              ),
            ],
          )),
          const SizedBox(height: 16),

          // Cooldown period
          Obx(() => DropdownButtonFormField<Duration>(
            value: selectedCooldown.value,
            decoration: const InputDecoration(
              labelText: 'Cooldown Period',
              border: OutlineInputBorder(),
            ),
            items: ImpulseConstants.cooldownOptions.map((duration) {
              return DropdownMenuItem(
                value: duration,
                child: Text(ImpulseConstants.cooldownLabels[duration]!),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) selectedCooldown.value = value;
            },
          )),
          const SizedBox(height: 16),

          // Notes
          TextField(
            controller: notesController,
            decoration: const InputDecoration(
              labelText: 'Notes (Optional)',
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 24),

          // Buttons
          Row(
            children: [
              Expanded(
                child: _buildCancelButton(),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: _buildStartCooldownButton(),
              ),
            ],
          ),
          const SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }
  Widget _buildCancelButton() {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Get.back(),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Colors.grey.shade50,
                ],
              ),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.close_rounded,
                    color: Colors.grey.shade600,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStartCooldownButton() {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.purple.shade400,
            Colors.purple.shade600,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.purple.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: addImpulseItem,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(0.2),
                  Colors.transparent,
                ],
              ),
            ),
            child: const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.timer_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Start Cooldown',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}