import 'package:tezda_task/core/exceptions/auth_exception.dart';
import 'package:tezda_task/features/auth/domain/entities/user_entity.dart';
import 'package:tezda_task/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<UserEntity> call({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      return await repository.register(
        email: email,
        password: password,
        name: name,
      );
    } on AuthException {
      rethrow; 
    } catch (e) {
      throw AuthException('Registration failed: ${e.toString()}');
    }
  }
}
