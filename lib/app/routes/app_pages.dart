import 'package:get/get.dart';

import 'package:expensetracker/app/modules/favorite/bindings/journal_binding.dart';
import 'package:expensetracker/app/modules/home/bindings/home_binding.dart';
import 'package:expensetracker/app/modules/home/views/home_view.dart';
import 'package:expensetracker/app/modules/main/bindings/main_binding.dart';
import 'package:expensetracker/app/modules/main/views/main_view.dart';
import 'package:expensetracker/app/modules/other/bindings/other_binding.dart';
import 'package:expensetracker/app/modules/other/views/other_view.dart';
import 'package:expensetracker/app/modules/settings/bindings/settings_binding.dart';
import 'package:expensetracker/app/modules/settings/views/settings_view.dart';

import '../modules/expense_details/bindings/explore_binding.dart';
import '../modules/expense_details/views/expense_details.dart';
import '../modules/favorite/views/journal_view.dart';
import '../modules/quick_expense/bindings/quick_expense_bindings.dart';
import '../modules/quick_expense/views/quick_expense_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.MAIN;

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
      page: () =>  OtherView(),
      binding: OtherBinding(),
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
  ];
}