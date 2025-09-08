import 'package:expensetracker/app/modules/home/controllers/home_controller.dart';
import 'package:expensetracker/app/modules/main/controllers/main_controller.dart';
import 'package:expensetracker/app/modules/insights/controllers/insight_controller.dart';
import 'package:expensetracker/app/modules/settings/controllers/settings_controller.dart';
import 'package:get/get.dart';

import '../../journal/controllers/journal_controller.dart';



class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(
      () => MainController(),
      fenix: true,
    );
    Get.lazyPut<InsightController>(
      () => InsightController(),
      fenix: true,
    );
    Get.lazyPut<HomeController>(
      () => HomeController(),
      fenix: true,
    );
    Get.lazyPut<JournalController>(
      () => JournalController(),
    );
    Get.lazyPut<SettingsController>(
      () => SettingsController(),
    );
  }
}
