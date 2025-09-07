import 'package:flutter/material.dart';
import 'package:expensetracker/utils/strings.dart';
import 'package:get/get.dart';

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.back();
      },
      child: Image.asset(Strings.appName)
    );
  }
}
