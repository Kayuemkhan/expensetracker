import 'package:expensetracker/view/screens/home_screen.dart';
import 'package:get/get.dart';


class Routes {
  static const String homeScreen = '/homeScreen';



  static var list = [

    GetPage(
      name: homeScreen,
      page: () => const HomeScreen(),
    ),
  ];
}
