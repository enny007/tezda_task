import 'package:tezda_task/features/favourite/data/data_sources/favourite_remote_data_source.dart';
import 'package:tezda_task/features/favourite/domain/entities/favourite_entity.dart';
import 'package:tezda_task/features/favourite/domain/repositories/favourite_repository.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final FavoriteRemoteDataSource _remoteDataSource;

  FavoriteRepositoryImpl({
    required FavoriteRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<List<FavoriteEntity>> getUserFavorites(String userId) async {
    try {
      final favoriteModels = await _remoteDataSource.getUserFavorites(userId);
      return favoriteModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addToFavorites(String userId, int productId) async {
    try {
      await _remoteDataSource.addToFavorites(userId, productId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> removeFromFavorites(String userId, int productId) async {
    try {
      await _remoteDataSource.removeFromFavorites(userId, productId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> isFavorite(String userId, int productId) async {
    try {
      return await _remoteDataSource.isFavorite(userId, productId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<List<FavoriteEntity>> watchUserFavorites(String userId) {
    return _remoteDataSource
        .watchUserFavorites(userId)
        .map((models) => models.map((model) => model.toEntity()).toList());
  }
}
