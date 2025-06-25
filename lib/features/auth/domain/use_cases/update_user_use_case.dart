import 'package:tezda_task/core/exceptions/auth_exception.dart';
import 'package:tezda_task/features/auth/domain/entities/user_entity.dart';
import 'package:tezda_task/features/auth/domain/repositories/auth_repository.dart';

class UpdateProfileUseCase {
  final AuthRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<UserEntity> call({
    required String userId,
    String? name,
    String? photoUrl,
  }) async {
    try {
      return await repository.updateProfile(
        userId: userId,
        name: name,
        photoUrl: photoUrl,
      );
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException('Profile update failed: ${e.toString()}');
    }
  }
}

