import 'package:expensetracker/app/core/base/base_view.dart';
import 'package:expensetracker/app/core/values/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:expensetracker/app/data/model/expense.dart';
import 'package:expensetracker/app/core/values/expense_constants.dart';

import '../controllers/expense_controller.dart';

class ExpenseDetailsView extends BaseView<ExpenseController> {
  final Expense expense = Get.arguments as Expense;
  late final categoryIcon = ExpenseConstants.categoryIcons[expense.category] ?? '📦';

  // ExpenseDetailsView({super.key}){
  //
  // }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
    Widget? trailing,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.grey[600],
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  void _confirmDeleteExpense(Expense expense) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Expense'),
        content: const Text('Are you sure you want to delete this expense?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              Get.back(); // Go back to home
              // TODO: Call delete function from controller
              Get.snackbar('Success', 'Expense deleted successfully!');
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
        title: const Text(
          'Transaction Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ));
  }

  @override
  Widget body(BuildContext context) {

    return  Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Merchant
          _buildDetailItem(
            icon: Icons.shopping_cart,
            label: 'Merchant',
            value: expense.merchant,
          ),
          const SizedBox(height: 20),

          // Amount
          _buildDetailItem(
            icon: Icons.attach_money,
            label: 'Amount',
            value: '-${NumberFormat.currency(symbol: '৳', decimalDigits: 2).format(expense.amount)}',
          ),
          const SizedBox(height: 20),

          // Category
          _buildDetailItem(
            icon: Icons.category,
            label: 'Category',
            value: expense.category,
            trailing: Text(
              categoryIcon,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 20),

          // Date
          _buildDetailItem(
            icon: Icons.calendar_today,
            label: 'Date',
            value: DateFormat('yyyy-MM-dd').format(expense.date),
          ),
          const SizedBox(height: 20),

          // Notes (if available)
          if (expense.note != null && expense.note!.isNotEmpty)
            _buildDetailItem(
              icon: Icons.note,
              label: 'Notes',
              value: expense.note!,
            ),

          const Spacer(),

          // Actions Section
          const Text(
            'Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Get.snackbar('Info', 'Edit functionality coming soon!');
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Edit'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _confirmDeleteExpense(expense),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.colorPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}