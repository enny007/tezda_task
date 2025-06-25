import 'package:tezda_task/features/favourite/domain/entities/favourite_entity.dart';

class FavoriteState {
  final List<FavoriteEntity> favorites;
  final Set<int> favoriteProductIds;
  final bool isLoading;
  final String? errorMessage;

  const FavoriteState({
    this.favorites = const [],
    this.favoriteProductIds = const {},
    this.isLoading = false,
    this.errorMessage,
  });

  FavoriteState copyWith({
    List<FavoriteEntity>? favorites,
    Set<int>? favoriteProductIds,
    bool? isLoading,
    String? errorMessage,
  }) {
    return FavoriteState(
      favorites: favorites ?? this.favorites,
      favoriteProductIds: favoriteProductIds ?? this.favoriteProductIds,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  FavoriteState clearError() {
    return copyWith(errorMessage: null);
  }

  bool isFavorite(int productId) {
    return favoriteProductIds.contains(productId);
  }

  @override
  String toString() {
    return 'FavoriteState(favorites: ${favorites.length}, favoriteProductIds: ${favoriteProductIds.length}, isLoading: $isLoading, errorMessage: $errorMessage)';
  }
}
