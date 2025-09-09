import 'package:expensetracker/app/core/base/base_view.dart';
import 'package:expensetracker/app/core/values/app_colors.dart';
import 'package:expensetracker/app/core/values/app_values.dart';
import 'package:expensetracker/app/core/values/text_styles.dart';
import 'package:expensetracker/app/core/widget/custom_app_bar.dart';
import 'package:expensetracker/app/core/widget/icon_text_widgets.dart';
import 'package:expensetracker/app/modules/project_details/controllers/project_details_controller.dart';
import 'package:expensetracker/app/modules/splash/controllers/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SplashView extends BaseView<SplashController> {
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return const CustomAppBar(
      appBarTitleText: 'Repository details',
      isBackButtonEnabled: true,
    );
  }

  @override
  Widget body(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("data"),
      ),
    );
  }


}
