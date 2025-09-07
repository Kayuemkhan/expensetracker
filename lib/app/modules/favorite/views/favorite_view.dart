import 'package:expensetracker/app/core/base/base_view.dart';
import 'package:expensetracker/app/core/values/text_styles.dart';
import 'package:expensetracker/app/core/widget/custom_app_bar.dart';
import 'package:expensetracker/app/modules/favorite/controllers/favorite_controller.dart';
import 'package:flutter/material.dart';


class FavoriteView extends BaseView<FavoriteController> {
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return CustomAppBar(
      appBarTitleText: 'Favorite',
    );
  }

  @override
  Widget body(BuildContext context) {
    return const Center(
      child: Text(
        'FavoriteView is working',
        style: titleStyle,
      ),
    );
  }
}
