import 'package:tezda_task/features/favourite/domain/repositories/favourite_repository.dart';

class CheckIsFavoriteUseCase {
  final FavoriteRepository _repository;

  CheckIsFavoriteUseCase(this._repository);

  Future<bool> call(String userId, int productId) async {
    return await _repository.isFavorite(userId, productId);
  }
}
