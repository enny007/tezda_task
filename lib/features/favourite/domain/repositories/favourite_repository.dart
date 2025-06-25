import 'package:tezda_task/features/favourite/domain/entities/favourite_entity.dart';

abstract class FavoriteRepository {
  Future<List<FavoriteEntity>> getUserFavorites(String userId);
  Future<void> addToFavorites(String userId, int productId);
  Future<void> removeFromFavorites(String userId, int productId);
  Future<bool> isFavorite(String userId, int productId);
  Stream<List<FavoriteEntity>> watchUserFavorites(String userId);
}
