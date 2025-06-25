import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tezda_task/features/auth/presentation/providers/auth_provider.dart';
import 'package:tezda_task/features/favourite/data/data_sources/favourite_remote_data_source.dart';
import 'package:tezda_task/features/favourite/data/repositories/favourite_repo_impl.dart';
import 'package:tezda_task/features/favourite/domain/entities/favourite_entity.dart';
import 'package:tezda_task/features/favourite/domain/repositories/favourite_repository.dart';
import 'package:tezda_task/features/favourite/domain/use_cases/add_to_favourite_use_case.dart';
import 'package:tezda_task/features/favourite/domain/use_cases/check_is_user_favourite_use_case.dart';
import 'package:tezda_task/features/favourite/domain/use_cases/get_user_use_case.dart';
import 'package:tezda_task/features/favourite/domain/use_cases/remove_from_favourite_use_case.dart';
import 'package:tezda_task/features/favourite/presentation/providers/favourite_state.dart';
import 'package:tezda_task/shared/providers/firebase_providers.dart';


// Data Source Provider
final favoriteRemoteDataSourceProvider = Provider<FavoriteRemoteDataSource>((ref) {
  return FavoriteRemoteDataSourceImpl(
    firestore: ref.watch(firebaseFirestoreProvider),
  );
});

// Repository Provider
final favoriteRepositoryProvider = Provider<FavoriteRepository>((ref) {
  return FavoriteRepositoryImpl(
    remoteDataSource: ref.watch(favoriteRemoteDataSourceProvider),
  );
});

// Use Cases Providers
final addToFavoritesUseCaseProvider = Provider<AddToFavoritesUseCase>((ref) {
  return AddToFavoritesUseCase(ref.watch(favoriteRepositoryProvider));
});

final removeFromFavoritesUseCaseProvider = Provider<RemoveFromFavoritesUseCase>((ref) {
  return RemoveFromFavoritesUseCase(ref.watch(favoriteRepositoryProvider));
});

final getUserFavoritesUseCaseProvider = Provider<GetUserFavoritesUseCase>((ref) {
  return GetUserFavoritesUseCase(ref.watch(favoriteRepositoryProvider));
});

final checkIsFavoriteUseCaseProvider = Provider<CheckIsFavoriteUseCase>((ref) {
  return CheckIsFavoriteUseCase(ref.watch(favoriteRepositoryProvider));
});

// Favorites Stream Provider - watches real-time changes
final favoritesStreamProvider = StreamProvider.family<List<FavoriteEntity>, String>((ref, userId) {
  final repository = ref.watch(favoriteRepositoryProvider);
  return repository.watchUserFavorites(userId);
});

// Favorites Notifier
class FavoriteNotifier extends Notifier<FavoriteState> {
  @override
  FavoriteState build() {
    final currentUser = ref.watch(currentUserProvider);
    
    if (currentUser != null) {
      // Listen to real-time favorites changes
      ref.listen(favoritesStreamProvider(currentUser.id), (previous, next) {
        next.when(
          data: (favorites) {
            final favoriteProductIds = favorites.map((f) => f.productId).toSet();
            state = state.copyWith(
              favorites: favorites,
              favoriteProductIds: favoriteProductIds,
              isLoading: false,
              errorMessage: null,
            );
          },
          loading: () {
            if (state.favorites.isEmpty) {
              state = state.copyWith(isLoading: true);
            }
          },
          error: (error, _) {
            state = state.copyWith(
              isLoading: false,
              errorMessage: error.toString(),
            );
          },
        );
      });
    }

    return const FavoriteState();
  }

  Future<void> toggleFavorite(int productId) async {
    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) return;

    try {
      final isFavorite = state.isFavorite(productId);
      
      if (isFavorite) {
        await ref.read(removeFromFavoritesUseCaseProvider)(currentUser.id, productId);
      } else {
        await ref.read(addToFavoritesUseCaseProvider)(currentUser.id, productId);
      }
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> addToFavorites(int productId) async {
    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) return;

    try {
      await ref.read(addToFavoritesUseCaseProvider)(currentUser.id, productId);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> removeFromFavorites(int productId) async {
    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) return;

    try {
      await ref.read(removeFromFavoritesUseCaseProvider)(currentUser.id, productId);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  void clearError() {
    state = state.clearError();
  }
}

// Main Favorite Provider
final favoriteProvider = NotifierProvider<FavoriteNotifier, FavoriteState>(() {
  return FavoriteNotifier();
});

// Convenience providers
final favoritesListProvider = Provider((ref) {
  return ref.watch(favoriteProvider).favorites;
});

final favoriteProductIdsProvider = Provider((ref) {
  return ref.watch(favoriteProvider).favoriteProductIds;
});

final isFavoriteProvider = Provider.family<bool, int>((ref, productId) {
  return ref.watch(favoriteProvider).isFavorite(productId);
});

final isLoadingFavoritesProvider = Provider((ref) {
  return ref.watch(favoriteProvider).isLoading;
});

final favoriteErrorProvider = Provider((ref) {
  return ref.watch(favoriteProvider).errorMessage;
});
