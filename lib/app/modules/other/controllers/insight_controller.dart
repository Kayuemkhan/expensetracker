import 'package:expensetracker/app/core/base/base_controller.dart';
import 'package:get/get.dart';


// app/modules/insights/controllers/insights_controller.dart
import 'package:get/get.dart';
import 'package:expensetracker/app/core/base/base_controller.dart';
import 'package:expensetracker/app/data/repository/insights_repository.dart';

class InsightController extends BaseController {
  final InsightsRepository _insightsRepository = Get.find<InsightsRepository>();

  // Observables
  final RxBool _isLoading = true.obs;

  // Impulse Savings
  final RxDouble _impulseSavings = 0.0.obs;
  final RxDouble _impulseSavingsGoal = 5000.0.obs;
  final RxDouble _impulseSavingsProgress = 0.0.obs;

  // Spending Breakdown
  final RxList<Map<String, dynamic>> _weeklySpending = RxList<Map<String, dynamic>>();
  final RxList<Map<String, dynamic>> _weeklyImpulseDecisions = RxList<Map<String, dynamic>>();
  final RxMap<String, double> _categorySpending = RxMap<String, double>();
  final RxDouble _totalMonthlySpending = 0.0.obs;
  final RxDouble _spendingChangePercentage = 0.0.obs;

  // Summary Data
  final RxMap<String, dynamic> _weeklySummary = RxMap<String, dynamic>();
  final RxMap<String, dynamic> _monthlySummary = RxMap<String, dynamic>();

  // Getters
  bool get isLoading => _isLoading.value;
  double get impulseSavings => _impulseSavings.value;
  double get impulseSavingsGoal => _impulseSavingsGoal.value;
  double get impulseSavingsProgress => _impulseSavingsProgress.value;
  List<Map<String, dynamic>> get weeklySpending => _weeklySpending.toList();
  List<Map<String, dynamic>> get weeklyImpulseDecisions => _weeklyImpulseDecisions.toList();
  Map<String, double> get categorySpending => _categorySpending;
  double get totalMonthlySpending => _totalMonthlySpending.value;
  double get spendingChangePercentage => _spendingChangePercentage.value;
  Map<String, dynamic> get weeklySummary => _weeklySummary;
  Map<String, dynamic> get monthlySummary => _monthlySummary;

  @override
  void onInit() {
    super.onInit();
    loadInsightsData();
  }

  Future<void> loadInsightsData() async {
    try {
      _isLoading.value = true;

      await Future.wait([
        loadImpulseSavingsData(),
        loadSpendingBreakdown(),
        loadWeeklyData(),
        loadSummaryData(),
      ]);
    } catch (e) {
      logger.e('Error loading insights data: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> loadImpulseSavingsData() async {
    try {
      final savings = await _insightsRepository.getImpulseSavings();
      final progress = await _insightsRepository.getImpulseSavingsGoalProgress();

      _impulseSavings.value = savings;
      _impulseSavingsProgress.value = progress;
    } catch (e) {
      logger.e('Error loading impulse savings data: $e');
    }
  }

  Future<void> loadSpendingBreakdown() async {
    try {
      // Category spending for current month
      final categoryData = await _insightsRepository.getExpensesByCategory();
      _categorySpending.assignAll(categoryData);

      // Monthly total and comparison
      final spendingComparison = await _insightsRepository.getSpendingComparison();
      _totalMonthlySpending.value = spendingComparison['thisMonth'];
      _spendingChangePercentage.value = spendingComparison['percentageChange'];

    } catch (e) {
      logger.e('Error loading spending breakdown: $e');
    }
  }

  Future<void> loadWeeklyData() async {
    try {
      // Weekly spending data
      final weeklySpendingData = await _insightsRepository.getWeeklySpending();
      _weeklySpending.assignAll(weeklySpendingData);

      // Weekly impulse decisions
      final weeklyImpulseData = await _insightsRepository.getWeeklyImpulseDecisions();
      _weeklyImpulseDecisions.assignAll(weeklyImpulseData);

    } catch (e) {
      logger.e('Error loading weekly data: $e');
    }
  }

  Future<void> loadSummaryData() async {
    try {
      final weekly = await _insightsRepository.getWeeklySummary();
      final monthly = await _insightsRepository.getMonthlySummary();

      _weeklySummary.assignAll(weekly);
      _monthlySummary.assignAll(monthly);

    } catch (e) {
      logger.e('Error loading summary data: $e');
    }
  }

  Future<void> onRefresh() async {
    await loadInsightsData();
  }

  String getFormattedPercentage(double percentage) {
    final isPositive = percentage >= 0;
    final symbol = isPositive ? '+' : '';
    return '$symbol${percentage.toStringAsFixed(0)}%';
  }

  String getCategoryIcon(String category) {
    const categoryIcons = {
      'Food': '🍴',
      'Rent': '🏠',
      'Transport': '🚌',
      'Shopping': '🛒',
      'Utilities': '💡',
      'Other': '📦',
    };
    return categoryIcons[category] ?? '📦';
  }

  int getTotalImpulseDecisions() {
    return _weeklyImpulseDecisions.fold(0, (sum, week) => sum + (week['decisions'] as int));
  }

  double getImpulseDecisionGrowth() {
    if (_weeklyImpulseDecisions.length < 2) return 0.0;

    final lastWeek = _weeklyImpulseDecisions.last['decisions'] as int;
    final previousWeek = _weeklyImpulseDecisions[_weeklyImpulseDecisions.length - 2]['decisions'] as int;

    if (previousWeek == 0) return 0.0;

    return ((lastWeek - previousWeek) / previousWeek * 100);
  }

  List<double> getWeeklySpendingAmounts() {
    return _weeklySpending.map((week) => week['amount'] as double).toList();
  }

  List<int> getWeeklyImpulseDecisionCounts() {
    return _weeklyImpulseDecisions.map((week) => week['decisions'] as int).toList();
  }

  double getMaxWeeklySpending() {
    final amounts = getWeeklySpendingAmounts();
    return amounts.isEmpty ? 100.0 : amounts.reduce((a, b) => a > b ? a : b);
  }

  int getMaxWeeklyDecisions() {
    final counts = getWeeklyImpulseDecisionCounts();
    return counts.isEmpty ? 5 : counts.reduce((a, b) => a > b ? a : b);
  }
}