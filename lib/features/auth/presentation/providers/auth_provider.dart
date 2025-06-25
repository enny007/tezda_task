import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tezda_task/core/exceptions/auth_exception.dart';
import 'package:tezda_task/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:tezda_task/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:tezda_task/features/auth/domain/entities/user_entity.dart';
import 'package:tezda_task/features/auth/domain/use_cases/log_out_use_case.dart';
import 'package:tezda_task/features/auth/domain/use_cases/login_use_case.dart';
import 'package:tezda_task/features/auth/domain/use_cases/register_use_case.dart';
import 'package:tezda_task/features/auth/domain/use_cases/update_user_use_case.dart';
import 'package:tezda_task/shared/providers/firebase_providers.dart';
import 'auth_state.dart';
import 'dart:developer' as developer;

// Data Source Provider
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(
    firebaseAuth: ref.watch(firebaseAuthProvider),
    firestore: ref.watch(firebaseFirestoreProvider),
  );
});

// Repository Provider
final authRepositoryProvider = Provider((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
  );
});

// Use Cases Providers
final loginUseCaseProvider = Provider((ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
});

final registerUseCaseProvider = Provider((ref) {
  return RegisterUseCase(ref.watch(authRepositoryProvider));
});

final updateProfileUseCaseProvider = Provider((ref) {
  return UpdateProfileUseCase(ref.watch(authRepositoryProvider));
});

final logoutUseCaseProvider = Provider((ref) {
  return LogoutUseCase(ref.watch(authRepositoryProvider));
});

// Auth State Stream Provider
final authStateStreamProvider = StreamProvider<UserEntity?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

// Auth Notifier
class AuthNotifier extends Notifier<AuthState> {
  late final LoginUseCase _loginUseCase;
  late final RegisterUseCase _registerUseCase;
  late final UpdateProfileUseCase _updateProfileUseCase;
  late final LogoutUseCase _logoutUseCase;

  @override
  AuthState build() {
    developer.log('🔥 AuthNotifier build() called');

    _loginUseCase = ref.watch(loginUseCaseProvider);
    _registerUseCase = ref.watch(registerUseCaseProvider);
    _updateProfileUseCase = ref.watch(updateProfileUseCaseProvider);
    _logoutUseCase = ref.watch(logoutUseCaseProvider);

    // Listen to auth state changes
    ref.listen(authStateStreamProvider, (previous, next) {
      developer.log('🔥 Auth stream changed: ${next.toString()}');

      next.when(
        data: (user) {
          developer.log('🔥 Stream data: user = ${user?.email ?? 'null'}');

          if (user != null) {
            developer.log('✅ User authenticated: ${user.email}');
            state = state.copyWith(
              status: AuthStatus.authenticated,
              user: user,
              errorMessage: null,
            );
          } else {
            developer.log('❌ User unauthenticated');
            state = state.copyWith(
              status: AuthStatus.unauthenticated,
              user: null,
              errorMessage: null,
            );
          }
        },
        loading: () {
          developer.log('🔄 Stream loading');
          if (state.status == AuthStatus.initial) {
            state = state.copyWith(status: AuthStatus.loading);
          }
        },
        error: (error, stackTrace) {
          developer.log('💥 Stream error: $error');
          String errorMessage = 'An error occurred';
          if (error is AuthException) {
            errorMessage = error.message;
          } else {
            errorMessage = error.toString();
          }
          state = state.copyWith(
            status: AuthStatus.error,
            errorMessage: errorMessage,
          );
        },
      );
    });

    final initialState = const AuthState(status: AuthStatus.loading);
    developer.log('🔥 Initial state: ${initialState.status}');
    return initialState;
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      developer.log('🔥 Login attempt: $email');

      state = state.copyWith(
        status: AuthStatus.loading,
        errorMessage: null,
      );
      developer.log('🔄 Login loading state set');

      await _loginUseCase(
        email: email,
        password: password,
      );

      developer.log('✅ Login use case completed successfully');
      // Success will be handled by the stream listener
    } catch (e) {
      developer.log('💥 Login error: $e');

      String errorMessage = 'Login failed';
      if (e is AuthException) {
        errorMessage = e.message;
      } else {
        errorMessage = e.toString();
      }

      developer.log('💥 Setting error state: $errorMessage');
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: errorMessage,
      );
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      developer.log('🔥 Register attempt: $email, $name');

      state = state.copyWith(
        status: AuthStatus.loading,
        errorMessage: null,
      );
      developer.log('🔄 Register loading state set');

      final user = await _registerUseCase(
        email: email,
        password: password,
        name: name,
      );

      developer.log('✅ Register use case completed successfully');

      // Immediately set the authenticated state with the user data
      // This ensures the UI has the correct user info right away
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        errorMessage: null,
      );
    } catch (e) {
      developer.log('💥 Register error: $e');

      String errorMessage = 'Registration failed';
      if (e is AuthException) {
        errorMessage = e.message;
      } else {
        errorMessage = e.toString();
      }
      developer.log('💥 Setting register error state: $errorMessage');
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: errorMessage,
      );
    }
  }

  Future<void> updateProfile({
    String? name,
    String? photoUrl,
  }) async {
    try {
      if (state.user == null) {
        throw const AuthException('User not authenticated');
      }

      developer.log('🔥 Update profile attempt');

      state = state.copyWith(
        status: AuthStatus.loading,
        errorMessage: null,
      );

      final updatedUser = await _updateProfileUseCase(
        userId: state.user!.id,
        name: name,
        photoUrl: photoUrl,
      );

      developer.log('✅ Profile updated successfully');
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: updatedUser,
        errorMessage: null,
      );
    } catch (e) {
      developer.log('💥 Update profile error: $e');

      String errorMessage = 'Profile update failed';
      if (e is AuthException) {
        errorMessage = e.message;
      } else {
        errorMessage = e.toString();
      }

      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: errorMessage,
      );
    }
  }

  Future<void> logout() async {
    try {
      developer.log('🔥 Logout attempt');

      state = state.copyWith(
        status: AuthStatus.loading,
        errorMessage: null,
      );

      await _logoutUseCase();

      developer.log('✅ Logout completed successfully');
      // Success will be handled by the stream listener
    } catch (e) {
      developer.log('💥 Logout error: $e');

      String errorMessage = 'Logout failed';
      if (e is AuthException) {
        errorMessage = e.message;
      } else {
        errorMessage = e.toString();
      }

      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: errorMessage,
      );
    }
  }

  void clearError() {
    developer.log('🔥 Clearing error');
    state = state.copyWith(
      status: state.user != null
          ? AuthStatus.authenticated
          : AuthStatus.unauthenticated,
      errorMessage: null,
    );
  }
}

// Auth Provider
final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});

// Current User Provider
final currentUserProvider = Provider((ref) {
  return ref.watch(authProvider).user;
});

// Auth Status Provider
final authStatusProvider = Provider((ref) {
  return ref.watch(authProvider).status;
});
