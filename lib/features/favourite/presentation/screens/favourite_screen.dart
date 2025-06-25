import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tezda_task/core/constants/app_constants.dart';
import 'package:tezda_task/features/favourite/presentation/providers/favourite_provider.dart';
import 'package:tezda_task/features/product/domain/entities/product_entity.dart';
import 'package:tezda_task/features/product/presentation/providers/product_providers.dart';
import 'package:tezda_task/features/product/presentation/widgets/loading_shimmer.dart';
import 'package:tezda_task/features/product/presentation/widgets/product_tile.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(isLoadingFavoritesProvider);
    final favorites = ref.watch(favoritesListProvider);
    final favoriteProductIds = ref.watch(favoriteProductIdsProvider);
    final products = ref.watch(productsListProvider);
    final errorMessage = ref.watch(favoriteErrorProvider);

    // Filter products to show only favorites
    final favoriteProducts = products
        .where((product) => favoriteProductIds.contains(product.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).textTheme.titleLarge?.color,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Refresh both products and favorites
          await Future.wait([
            ref.read(productProvider.notifier).refreshProducts(),
          ]);
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              _buildHeaderSection(context, favoriteProducts.length),
              const SizedBox(height: 24),

              // Error handling
              if (errorMessage != null) ...[
                _buildErrorSection(context, errorMessage, ref),
                const SizedBox(height: 16),
              ],

              // Favorites Grid
              if (isLoading)
                _buildLoadingGrid()
              else if (favoriteProducts.isNotEmpty)
                _buildFavoritesGrid(context, favoriteProducts)
              else
                _buildEmptyState(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context, int favoriteCount) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.pink.shade400,
            Colors.pink.shade300,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.favorite,
                color: Colors.white,
                size: 28,
              ),
              const SizedBox(width: 12),
              const Text(
                'Your Favorites',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '$favoriteCount ${favoriteCount == 1 ? 'item' : 'items'} saved',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesGrid(
      BuildContext context, List<ProductEntity> favoriteProducts) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: favoriteProducts.length,
      itemBuilder: (context, index) {
        final product = favoriteProducts[index];
        return ProductTile(
          product: product,
          onTap: () {
            context.push('${AppConstants.productDetailRoute}/${product.id}');
          },
        );
      },
    );
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return const LoadingShimmer();
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 60),
          Icon(
            Icons.favorite_outline,
            size: 100,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 24),
          Text(
            'No Favorites Yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Start adding products to your favorites\nby tapping the heart icon',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to home tab
              // This would need to be implemented based on your navigation structure
            },
            icon: const Icon(Icons.shopping_bag_outlined),
            label: const Text('Browse Products'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorSection(BuildContext context, String error, WidgetRef ref) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade600),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              error,
              style: TextStyle(color: Colors.red.shade700),
            ),
          ),
          TextButton(
            onPressed: () {
              ref.read(favoriteProvider.notifier).clearError();
            },
            child: const Text('Dismiss'),
          ),
        ],
      ),
    );
  }
}
