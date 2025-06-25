import 'package:tezda_task/features/favourite/domain/repositories/favourite_repository.dart';

class RemoveFromFavoritesUseCase {
  final FavoriteRepository _repository;

  RemoveFromFavoritesUseCase(this._repository);

  Future<void> call(String userId, int productId) async {
    return await _repository.removeFromFavorites(userId, productId);
  }
}
