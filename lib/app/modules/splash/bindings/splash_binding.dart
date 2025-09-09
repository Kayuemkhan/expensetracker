import 'package:expensetracker/app/modules/project_details/controllers/project_details_controller.dart';
import 'package:expensetracker/app/modules/splash/controllers/splash_controller.dart';
import 'package:get/get.dart';


class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(
      () => SplashController(),
    );
  }
}
