import 'package:expensetracker/app/core/base/base_view.dart';
import 'package:expensetracker/app/core/widget/custom_app_bar.dart';
import 'package:expensetracker/app/modules/favorite/views/favorite_view.dart';
import 'package:expensetracker/app/modules/home/views/home_view.dart';
import 'package:expensetracker/app/modules/main/controllers/main_controller.dart';
import 'package:expensetracker/app/modules/main/model/menu_code.dart';
import 'package:expensetracker/app/modules/main/views/bottom_nav_bar.dart';
import 'package:expensetracker/app/modules/other/views/other_view.dart';
import 'package:expensetracker/app/modules/settings/views/settings_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  FavoriteView? favoriteView;
  SettingsView? exploreView;
  SettingsView? interestView;

  Widget getPageOnSelectedMenu(MenuCode menuCode) {
    switch (menuCode) {
      case MenuCode.HOME:
        return homeView;
      case MenuCode.JOURNAL:
        favoriteView ??= FavoriteView();
        return favoriteView!;
      case MenuCode.INSIGHTS:
        exploreView ??= SettingsView();
        return exploreView!;
      case MenuCode.SETTINGS:
        interestView ??= SettingsView();
        return interestView!;
      default:
        return OtherView(
          viewParam: describeEnum(menuCode),
        );
    }
  }
}

