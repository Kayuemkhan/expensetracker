import 'package:expensetracker/app/modules/home/controllers/home_controller.dart';
import 'package:get/get.dart';

import '../../../data/repository/expense_repository.dart';


class HomeBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ExpenseRepository>()) {
      Get.lazyPut<ExpenseRepository>(() => ExpenseRepository());
    }
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
  }
}
