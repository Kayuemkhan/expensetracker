import 'package:expensetracker/app/core/base/base_view.dart';
import 'package:flutter/material.dart';
import '../controllers/insight_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


class InsightsView extends BaseView<InsightController> {
  InsightsView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'Insights',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black87),
        onPressed: () => Get.back(),
      ),
    );
  }

  @override
  Widget body(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.onRefresh,
      color: Colors.blue,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Obx(() {
          if (controller.isLoading) {
            return const SizedBox(
              height: 400,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          return Column(
            children: [
              _buildImpulseSavingsCard(),
              _buildSpendingBreakdownSection(),
              _buildWeeklySummaryCard(),
              _buildMonthlySummaryCard(),
              const SizedBox(height: 100),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildImpulseSavingsCard() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.green.shade50,
                Colors.white,
              ],
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Savings from skipped impulse buys',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),

              Obx(() => Column(
                children: [
                  // Progress bar
                  LinearProgressIndicator(
                    value: controller.impulseSavingsProgress,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    minHeight: 8,
                  ),
                  const SizedBox(height: 12),

                  // Goal and current amount
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Goal: ${NumberFormat.currency(symbol: '৳', decimalDigits: 0).format(controller.impulseSavingsGoal)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        NumberFormat.currency(symbol: '৳', decimalDigits: 0).format(controller.impulseSavings),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpendingBreakdownSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Spending Breakdown',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          _buildImpulseDecisionsCard(),
          const SizedBox(height: 16),
          _buildSpendingByCategoryCard(),
        ],
      ),
    );
  }

  Widget _buildImpulseDecisionsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade50,
              Colors.white,
            ],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Impulse Decisions Over Time',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            Obx(() => Row(
              children: [
                Text(
                  '${controller.getTotalImpulseDecisions()}',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: controller.getImpulseDecisionGrowth() >= 0
                        ? Colors.green.shade100
                        : Colors.red.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Last 30 Days ${controller.getFormattedPercentage(controller.getImpulseDecisionGrowth())}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: controller.getImpulseDecisionGrowth() >= 0
                          ? Colors.green.shade700
                          : Colors.red.shade700,
                    ),
                  ),
                ),
              ],
            )),

            const SizedBox(height: 20),

            // Simple bar chart for weekly decisions
            Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: controller.weeklyImpulseDecisions.asMap().entries.map((entry) {
                final index = entry.key;
                final week = entry.value;
                final decisions = week['decisions'] as int;
                final maxDecisions = controller.getMaxWeeklyDecisions();
                final height = maxDecisions > 0 ? (decisions / maxDecisions * 60).clamp(8.0, 60.0) : 8.0;

                return Column(
                  children: [
                    Container(
                      width: 24,
                      height: height,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      week['week'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                );
              }).toList(),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildSpendingByCategoryCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.orange.shade50,
              Colors.white,
            ],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Spending by Category',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            Obx(() => Row(
              children: [
                Text(
                  NumberFormat.currency(symbol: '৳', decimalDigits: 0).format(controller.totalMonthlySpending),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: controller.spendingChangePercentage >= 0
                        ? Colors.red.shade100
                        : Colors.green.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'This Month ${controller.getFormattedPercentage(controller.spendingChangePercentage)}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: controller.spendingChangePercentage >= 0
                          ? Colors.red.shade700
                          : Colors.green.shade700,
                    ),
                  ),
                ),
              ],
            )),

            const SizedBox(height: 20),

            // Category list with progress bars
            Obx(() {
              final categories = controller.categorySpending.entries.toList();
              final maxAmount = categories.isEmpty ? 1.0 : categories.map((e) => e.value).reduce((a, b) => a > b ? a : b);

              return Column(
                children: categories.map((entry) {
                  final category = entry.key;
                  final amount = entry.value;
                  final progress = maxAmount > 0 ? amount / maxAmount : 0.0;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Text(
                          controller.getCategoryIcon(category),
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    category,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  Text(
                                    NumberFormat.currency(symbol: '৳', decimalDigits: 0).format(amount),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              LinearProgressIndicator(
                                value: progress,
                                backgroundColor: Colors.grey.shade200,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade300),
                                minHeight: 6,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklySummaryCard() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.purple.shade50,
                Colors.white,
              ],
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Weekly Summary',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),

              Obx(() => Row(
                children: [
                  Expanded(
                    child: _buildSummaryItem(
                      'Total\nSpending',
                      NumberFormat.currency(symbol: '৳', decimalDigits: 0)
                          .format(controller.weeklySummary['totalSpending'] ?? 0),
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 1,
                    color: Colors.grey.shade300,
                  ),
                  Expanded(
                    child: _buildSummaryItem(
                      'Top Category',
                      controller.weeklySummary['topCategory'] ?? 'None',
                    ),
                  ),
                ],
              )),

              const SizedBox(height: 16),

              Obx(() => _buildSummaryItem(
                'Impulse\nDecisions',
                '${controller.weeklySummary['impulseDecisions'] ?? 0}',
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonthlySummaryCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue.shade50,
                Colors.white,
              ],
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Monthly Summary',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),

              Obx(() => Row(
                children: [
                  Expanded(
                    child: _buildSummaryItem(
                      'Total\nSpending',
                      NumberFormat.currency(symbol: '৳', decimalDigits: 0)
                          .format(controller.monthlySummary['totalSpending'] ?? 0),
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 1,
                    color: Colors.grey.shade300,
                  ),
                  Expanded(
                    child: _buildSummaryItem(
                      'Top Category',
                      controller.monthlySummary['topCategory'] ?? 'None',
                    ),
                  ),
                ],
              )),

              const SizedBox(height: 16),

              Obx(() => _buildSummaryItem(
                'Impulse\nDecisions',
                '${controller.monthlySummary['impulseDecisions'] ?? 0}',
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
