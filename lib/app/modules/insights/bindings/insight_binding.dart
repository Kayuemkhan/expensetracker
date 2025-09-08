import 'package:get/get.dart';

import '../controllers/insight_controller.dart';

class InsightsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InsightController>(
      () => InsightController(),
    );
  }
}
