import 'package:tezda_task/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:tezda_task/features/auth/domain/entities/user_entity.dart';
import 'package:tezda_task/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    final userModel = await _remoteDataSource.login(
      email: email,
      password: password,
    );
    return userModel.toEntity();
  }

  @override
  Future<UserEntity> register({
    required String email,
    required String password,
    required String name,
  }) async {
    final userModel = await _remoteDataSource.register(
      email: email,
      password: password,
      name: name,
    );
    return userModel.toEntity();
  }

  @override
  Future<UserEntity> updateProfile({
    required String userId,
    String? name,
    String? photoUrl,
  }) async {
    final userModel = await _remoteDataSource.updateProfile(
      userId: userId,
      name: name,
      photoUrl: photoUrl,
    );
    return userModel.toEntity();
  }

  @override
  Future<void> logout() async {
    await _remoteDataSource.logout();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final userModel = await _remoteDataSource.getCurrentUser();
    return userModel?.toEntity();
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return _remoteDataSource.authStateChanges
        .map((userModel) => userModel?.toEntity());
  }
}
