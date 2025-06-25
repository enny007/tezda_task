import 'package:tezda_task/features/favourite/domain/entities/favourite_entity.dart';
import 'package:tezda_task/features/favourite/domain/repositories/favourite_repository.dart';

class GetUserFavoritesUseCase {
  final FavoriteRepository _repository;

  GetUserFavoritesUseCase(this._repository);

  Future<List<FavoriteEntity>> call(String userId) async {
    return await _repository.getUserFavorites(userId);
  }
}
