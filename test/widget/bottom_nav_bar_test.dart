import 'package:expensetracker/app/modules/main/model/menu_code.dart';
import 'package:expensetracker/app/modules/main/views/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  testWidgets(
    'selecting a navigation item updates the selected index and callback',
    (tester) async {
      MenuCode? selectedMenu;

      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            bottomNavigationBar: BottomNavBar(
              onNewMenuSelected: (menuCode) => selectedMenu = menuCode,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Journal'));
      await tester.pump();

      expect(selectedMenu, MenuCode.JOURNAL);
      expect(
        tester
            .widget<BottomNavigationBar>(find.byType(BottomNavigationBar))
            .currentIndex,
        1,
      );

      await tester.tap(find.text('Settings'));
      await tester.pump();

      expect(selectedMenu, MenuCode.SETTINGS);
      expect(
        tester
            .widget<BottomNavigationBar>(find.byType(BottomNavigationBar))
            .currentIndex,
        3,
      );
    },
  );
}
