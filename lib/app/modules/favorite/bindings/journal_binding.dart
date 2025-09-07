import 'package:get/get.dart';

import '../../../data/repository/impulse_repository.dart';
import '/app/modules/favorite/controllers/journal_controller.dart';

class JournalBinding extends Bindings {
  @override
  void dependencies() {


    Get.lazyPut<JournalController>(
      () => JournalController(),
    );
  }
}
