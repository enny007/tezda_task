import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tezda_task/core/constants/app_constants.dart';
import 'package:tezda_task/features/auth/presentation/providers/auth_provider.dart';
import 'package:tezda_task/features/auth/presentation/providers/auth_state.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();

    _checkAuthAndNavigate();
  }

  void _checkAuthAndNavigate() {
    // Listen to auth state changes and navigate accordingly
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        final authState = ref.read(authProvider);
        if (!authState.isLoading) {
          _navigateBasedOnAuthState(authState);
        }
      }
    });
  }

  void _navigateBasedOnAuthState(AuthState authState) {
    if (authState.isAuthenticated) {
      context.go(AppConstants.mainNavigationRoute);
    } else {
      context.go(AppConstants.loginRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // Listen to auth state changes for real-time navigation
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (previous?.isLoading == true && !next.isLoading) {
        // Auth state has finished loading, navigate
        _navigateBasedOnAuthState(next);
      }
    });

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withValues(alpha: 0.8),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.shopping_bag,
                size: 100,
                color: Colors.white,
              ),
              const SizedBox(height: 24),
              const Text(
                AppConstants.appName,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              if (authState.isLoading) ...[
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Loading...',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
              if (authState.hasError) ...[
                const Icon(
                  Icons.error_outline,
                  color: Colors.white,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  authState.errorMessage ?? 'An error occurred',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.read(authProvider.notifier).clearError();
                    _checkAuthAndNavigate();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
