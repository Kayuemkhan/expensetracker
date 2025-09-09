part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const MAIN = _Paths.MAIN;
  static const HOME = _Paths.HOME;
  static const FAVORITE = _Paths.FAVORITE;
  static const SETTINGS = _Paths.SETTINGS;
  static const OTHER = _Paths.OTHER;
  static const EXPENSE_DETAILS = _Paths.EXPENSE_DETAILS;
  static const QUICK_EXPENSE  = _Paths.QUICK_EXPENSE ;
  static const SPLASH  = _Paths.SPLASH ;
}

abstract class _Paths {
  static const MAIN = '/main';
  static const HOME = '/home';
  static const FAVORITE = '/journal';
  static const SETTINGS = '/settings';
  static const OTHER = '/insights';
  static const EXPENSE_DETAILS = '/expense-details';
  static const QUICK_EXPENSE = '/quick-expense';
  static const SPLASH = '/splash';
}
