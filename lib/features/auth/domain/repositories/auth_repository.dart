import 'package:tezda_task/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login({
    required String email,
    required String password,
  });

  Future<UserEntity> register({
    required String email,
    required String password,
    required String name,
  });

  Future<UserEntity> updateProfile({
    required String userId,
    String? name,
    String? photoUrl,
  });

  Future<void> logout();

  Future<UserEntity?> getCurrentUser();

  Stream<UserEntity?> get authStateChanges;
}
