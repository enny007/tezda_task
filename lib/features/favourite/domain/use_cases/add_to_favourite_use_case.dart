import 'package:tezda_task/features/favourite/domain/repositories/favourite_repository.dart';

class AddToFavoritesUseCase {
  final FavoriteRepository _repository;

  AddToFavoritesUseCase(this._repository);

  Future<void> call(String userId, int productId) async {
    return await _repository.addToFavorites(userId, productId);
  }
}
