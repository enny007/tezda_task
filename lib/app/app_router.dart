import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tezda_task/core/constants/app_constants.dart';
import 'package:tezda_task/features/auth/presentation/screens/login_screen.dart';
import 'package:tezda_task/features/auth/presentation/screens/register_screen.dart';
import 'package:tezda_task/features/auth/presentation/screens/splash_screen.dart';
import 'package:tezda_task/features/product/presentation/screens/product_detail_screen.dart';
import 'package:tezda_task/shared/navigation/screens/navigation_screen.dart';
import 'dart:developer' as developer;

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppConstants.splashRoute,
    routes: [
      GoRoute(
        path: AppConstants.splashRoute,
        name: 'splash',
        builder: (context, state) {
          developer.log('🔥 Building SplashScreen');
          return const SplashScreen();
        },
      ),
      GoRoute(
        path: AppConstants.loginRoute,
        name: 'login',
        builder: (context, state) {
          developer.log('🔥 Building LoginScreen');
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: AppConstants.registerRoute,
        name: 'register',
        builder: (context, state) {
          developer.log('🔥 Building RegisterScreen');
          return const RegisterScreen();
        },
      ),
      GoRoute(
        path: AppConstants.mainNavigationRoute,
        name: 'main_navigation',
        builder: (context, state) {
          developer.log('🔥 Building MainNavigationScreen');
          return const MainNavigationScreen();
        },
      ),
      GoRoute(
        path: '${AppConstants.productDetailRoute}/:productId',
        name: 'product_detail',
        builder: (context, state) {
          final productId = state.pathParameters['productId']!;
          developer.log('🔥 Building ProductDetailScreen for: $productId');
          return ProductDetailScreen(productId: productId);
        },
      ),
    ],
  );
});
