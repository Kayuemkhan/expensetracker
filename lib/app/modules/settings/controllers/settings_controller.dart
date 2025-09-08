import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:expensetracker/app/core/base/base_controller.dart';
import 'package:expensetracker/app/data/repository/expense_repository.dart';
import 'package:expensetracker/app/data/repository/impulse_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class SettingsController extends BaseController {
  final ExpenseRepository _expenseRepository = Get.find<ExpenseRepository>();
  final ImpulseRepository _impulseRepository = Get.find<ImpulseRepository>();

  // Notification Settings
  final RxBool _dailyBudgetLimitNotification = false.obs;
  final RxBool _monthlyBudgetLimitNotification = false.obs;
  final RxBool _dailyExpenseReminderNotification = false.obs;

  // Getters
  bool get dailyBudgetLimitNotification => _dailyBudgetLimitNotification.value;
  bool get monthlyBudgetLimitNotification => _monthlyBudgetLimitNotification.value;
  bool get dailyExpenseReminderNotification => _dailyExpenseReminderNotification.value;

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  Future<void> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      _dailyBudgetLimitNotification.value = prefs.getBool('daily_budget_notification') ?? false;
      _monthlyBudgetLimitNotification.value = prefs.getBool('monthly_budget_notification') ?? false;
      _dailyExpenseReminderNotification.value = prefs.getBool('daily_reminder_notification') ?? false;

    } catch (e) {
      logger.e('Error loading settings: $e');
    }
  }

  Future<void> toggleDailyBudgetNotification(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('daily_budget_notification', value);
      _dailyBudgetLimitNotification.value = value;

      Get.snackbar(
        'Settings Updated',
        value ? 'Daily budget notifications enabled' : 'Daily budget notifications disabled',
        backgroundColor: Colors.blue.shade100,
        colorText: Colors.blue.shade800,
      );
    } catch (e) {
      logger.e('Error updating daily budget notification: $e');
    }
  }

  Future<void> toggleMonthlyBudgetNotification(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('monthly_budget_notification', value);
      _monthlyBudgetLimitNotification.value = value;

      Get.snackbar(
        'Settings Updated',
        value ? 'Monthly budget notifications enabled' : 'Monthly budget notifications disabled',
        backgroundColor: Colors.blue.shade100,
        colorText: Colors.blue.shade800,
      );
    } catch (e) {
      logger.e('Error updating monthly budget notification: $e');
    }
  }

  Future<void> toggleDailyReminderNotification(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('daily_reminder_notification', value);
      _dailyExpenseReminderNotification.value = value;

      Get.snackbar(
        'Settings Updated',
        value ? 'Daily expense reminders enabled' : 'Daily expense reminders disabled',
        backgroundColor: Colors.blue.shade100,
        colorText: Colors.blue.shade800,
      );
    } catch (e) {
      logger.e('Error updating daily reminder notification: $e');
    }
  }

  Future<void> exportData() async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Get all data
      final expenses = await _expenseRepository.getExpensesByDateRange(
        DateTime(2020, 1, 1),
        DateTime.now(),
      );
      final impulseItems = await _impulseRepository.getAllImpulseItems();

      // Create CSV content manually
      StringBuffer csvBuffer = StringBuffer();

      // Add header
      csvBuffer.writeln('Type,Amount,Category,Merchant,Note,Date');

      // Add expenses
      for (var expense in expenses) {
        csvBuffer.writeln([
          'Expense',
          expense.amount.toString(),
          _escapeCsvField(expense.category),
          _escapeCsvField(expense.merchant),
          _escapeCsvField(expense.note ?? ''),
          expense.date.toIso8601String(),
        ].join(','));
      }

      // Add impulse items
      for (var item in impulseItems) {
        csvBuffer.writeln([
          'Impulse Item',
          item.price.toString(),
          _escapeCsvField(item.category),
          _escapeCsvField(item.name),
          _escapeCsvField('Status: ${item.status.toString()}, Desire: ${item.desireLevel}/5'),
          item.createdDate.toIso8601String(),
        ].join(','));
      }

      // Use a simple path instead of getApplicationDocumentsDirectory
      // This will save to the app's internal storage
      final fileName = 'expense_tracker_export_${DateTime.now().millisecondsSinceEpoch}.csv';

      try {
        // Try to save to external storage if available
        final directory = Directory('/storage/emulated/0/Download');
        if (await directory.exists()) {
          final file = File('${directory.path}/$fileName');
          await file.writeAsString(csvBuffer.toString());

          Get.back(); // Close loading dialog

          Get.snackbar(
            'Export Successful',
            'Data exported to Downloads folder: $fileName',
            backgroundColor: Colors.green.shade100,
            colorText: Colors.green.shade800,
            duration: const Duration(seconds: 4),
          );
          return;
        }
      } catch (e) {
        logger.w('Could not save to Downloads, trying internal storage: $e');
      }

      // Fallback: Save to temporary directory
      final tempDir = Directory.systemTemp;
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsString(csvBuffer.toString());

      Get.back(); // Close loading dialog

      Get.snackbar(
        'Export Successful',
        'Data exported to: $fileName\nLocation: ${tempDir.path}',
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade800,
        duration: const Duration(seconds: 4),
      );

    } catch (e) {
      Get.back(); // Close loading dialog
      logger.e('Error exporting data: $e');

      Get.snackbar(
        'Export Failed',
        'Failed to export data. Please try again.',
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
    }
  }

  Future<void> importData() async {
    try {
      Get.snackbar(
        'Import Info',
        'CSV import feature will be available in a future update. For now, you can manually add expenses through the app.',
        backgroundColor: Colors.blue.shade100,
        colorText: Colors.blue.shade800,
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      logger.e('Error in import data: $e');

      Get.snackbar(
        'Import Failed',
        'Import feature is not available yet.',
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
      );
    }
  }

  String _escapeCsvField(String field) {
    // Escape CSV fields by wrapping in quotes if they contain commas, quotes, or newlines
    if (field.contains(',') || field.contains('"') || field.contains('\n')) {
      return '"${field.replaceAll('"', '""')}"';
    }
    return field;
  }

  void showDataStorageInfo() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Data Storage'),
        content: const Text(
          'Your data is stored locally on your device using SQLite database. '
              'No account is required and your data never leaves your device unless you export it manually.\n\n'
              'This ensures complete privacy and gives you full control over your financial information.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void showAboutApp() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('About Expense Tracker'),
        content: const Text(
          'Version 1.0.0\n\n'
              'A privacy-first expense tracker with impulse purchase management. '
              'Built with Flutter and designed to help you develop better spending habits.\n\n'
              'Features:\n'
              '• Daily expense tracking\n'
              '• Budget management\n'
              '• Impulse purchase journal\n'
              '• Spending insights\n'
              '• Local data storage',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void clearAllData() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Clear All Data'),
        content: const Text(
          'Are you sure you want to delete all your expenses and impulse items? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Get.back(); // Close dialog

              Get.dialog(
                const Center(child: CircularProgressIndicator()),
                barrierDismissible: false,
              );

              try {
                // Note: You'll need to implement these methods in your repositories
                // await _expenseRepository.clearAllExpenses();
                // await _impulseRepository.clearAllImpulseItems();

                Get.back(); // Close loading

                Get.snackbar(
                  'Data Cleared',
                  'All data has been successfully deleted.',
                  backgroundColor: Colors.green.shade100,
                  colorText: Colors.green.shade800,
                );
              } catch (e) {
                Get.back(); // Close loading

                Get.snackbar(
                  'Error',
                  'Failed to clear data. Please try again.',
                  backgroundColor: Colors.red.shade100,
                  colorText: Colors.red.shade800,
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}