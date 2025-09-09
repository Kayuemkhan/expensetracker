import 'package:expensetracker/app/modules/splash/views/splash_view.dart';
import 'package:get/get.dart';

import 'package:expensetracker/app/modules/home/bindings/home_binding.dart';
import 'package:expensetracker/app/modules/home/views/home_view.dart';
import 'package:expensetracker/app/modules/main/bindings/main_binding.dart';
import 'package:expensetracker/app/modules/main/views/main_view.dart';
import 'package:expensetracker/app/modules/insights/bindings/insight_binding.dart';
import 'package:expensetracker/app/modules/insights/views/insights_view.dart';
import 'package:expensetracker/app/modules/settings/bindings/settings_binding.dart';
import 'package:expensetracker/app/modules/settings/views/settings_view.dart';

import '../modules/expense_details/bindings/explore_binding.dart';
import '../modules/expense_details/views/expense_details.dart';
import '../modules/journal/bindings/journal_binding.dart';
import '../modules/journal/views/journal_view.dart';
import '../modules/quick_expense/bindings/quick_expense_bindings.dart';
import '../modules/quick_expense/views/quick_expense_view.dart';
import '../modules/splash/bindings/splash_binding.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.MAIN,
      page: () => MainView(),
      binding: MainBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () =>  HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.FAVORITE,
      page: () =>  JournalView(),
      binding: JournalBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () =>  SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.OTHER,
      page: () =>  InsightsView(),
      binding: InsightsBinding(),
    ),

    GetPage(
      name: _Paths.QUICK_EXPENSE,
      page: () => const QuickExpenseView(),
      binding: QuickExpenseBinding(),
    ),
    GetPage(
      name: _Paths.EXPENSE_DETAILS,
      page: () =>  ExpenseDetailsView(),
      binding: ExpenseBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () =>  SplashView(),
      binding: SplashBinding(),
    ),
  ];
}