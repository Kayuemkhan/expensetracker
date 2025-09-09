import 'package:expensetracker/app/core/values/app_colors.dart';
import 'package:expensetracker/app/core/values/app_values.dart';
import 'package:expensetracker/app/modules/main/controllers/bottom_nav_controller.dart';
import 'package:expensetracker/app/modules/main/model/menu_code.dart';
import 'package:expensetracker/app/modules/main/model/menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../core/values/images.dart';



typedef OnBottomNavItemSelected = Function(MenuCode menuCode);

class BottomNavBar extends StatelessWidget {
  final Function(MenuCode menuCode) onNewMenuSelected;

  BottomNavBar({super.key, required this.onNewMenuSelected});

  final navController = BottomNavController();

  final Key bottomNavKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    // appLocalization = AppLocalizations.of(context)!;

    Color selectedItemColor = AppColors.colorPrimary;
    Color unselectedItemColor = AppColors.colorSecondary;
    List<BottomNavItem> navItems = _getNavItems();

    return Obx(
          () => BottomNavigationBar(
        key: bottomNavKey,
        items: navItems
            .map(
              (BottomNavItem navItem) =>
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    "images/${navItem.iconSvgName}",
                    height: AppValues.iconDefaultSize,
                    width: AppValues.iconDefaultSize,
                    color:
                    navItems.indexOf(navItem) == navController.selectedIndex
                        ? selectedItemColor
                        : unselectedItemColor,
                  ),
                  label: navItem.navTitle,
                  tooltip: ""),
        )
            .toList(),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: selectedItemColor,
        unselectedItemColor: unselectedItemColor,
        currentIndex: navController.selectedIndex,
        onTap: (index) {
          navController.updateSelectedIndex(index);
          onNewMenuSelected(navItems[index].menuCode);
        },
      ),
    );
  }

  List<BottomNavItem> _getNavItems() {
    return [
      BottomNavItem(
        navTitle: 'Home'.tr,
        iconSvgName: Images.icHomeSvg,
        menuCode: MenuCode.HOME,
      ),
      BottomNavItem(
          navTitle: 'Journal'.tr,
          iconSvgName: Images.icJournalSVG,
          menuCode: MenuCode.JOURNAL),
      BottomNavItem(
          navTitle: 'Insights'.tr,
          iconSvgName: Images.icInsightsSVG,
          menuCode: MenuCode.INSIGHTS),

      BottomNavItem(
          navTitle:'Settings'.tr,
          iconSvgName: Images.icSettings,
          menuCode: MenuCode.SETTINGS)
    ];
  }
}
