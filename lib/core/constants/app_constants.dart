class AppConstants {
  static const String appName = 'Tezda Task';

  // Routes
  static const String splashRoute = '/';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String mainNavigationRoute = '/main_navigation';
  static const String homeRoute = '/home';
  static const String productDetailRoute = '/product_detail';
  static const String profileRoute = '/profile';

  // Validation
  static const int minPasswordLength = 6;
  static const String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
}
