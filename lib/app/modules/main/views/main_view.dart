import 'package:expensetracker/app/core/base/base_view.dart';
import 'package:expensetracker/app/modules/home/views/home_view.dart';
import 'package:expensetracker/app/modules/main/controllers/main_controller.dart';
import 'package:expensetracker/app/modules/main/model/menu_code.dart';
import 'package:expensetracker/app/modules/main/views/bottom_nav_bar.dart';
import 'package:expensetracker/app/modules/insights/views/insights_view.dart';
import 'package:expensetracker/app/modules/settings/views/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../journal/views/journal_view.dart';

class MainView extends BaseView<MainController> {
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }


  // @override
  // Widget? buildDrawer() {
  //   return const DrawerWidget();
  // }



  @override
  Widget body(BuildContext context) {
    return Obx(() => getPageOnSelectedMenu(controller.selectedMenuCode));
  }



  @override
  Widget? bottomNavigationBar() {
    return BottomNavBar(onNewMenuSelected: controller.onMenuSelected);
  }

  final HomeView homeView = HomeView();
  JournalView? favoriteView;
  InsightsView? exploreView;
  SettingsView? interestView;

  MainView({super.key});

  Widget getPageOnSelectedMenu(MenuCode menuCode) {
    switch (menuCode) {
      case MenuCode.HOME:
        return homeView;
      case MenuCode.JOURNAL:
        favoriteView ??= JournalView();
        return favoriteView!;
      case MenuCode.INSIGHTS:
        exploreView ??= InsightsView();
        return exploreView!;
      case MenuCode.SETTINGS:
        interestView ??= SettingsView();
        return interestView!;
      }
  }
}

