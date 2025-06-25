import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tezda_task/core/exceptions/auth_exception.dart';
import 'package:tezda_task/core/network/dio_client.dart';
import 'package:tezda_task/features/product/data/data_source/product_remote_data_source.dart';
import 'package:tezda_task/features/product/data/repository/product_repository_impl.dart';
import 'package:tezda_task/features/product/domain/entities/product_entity.dart';
import 'package:tezda_task/features/product/domain/use_cases/get_product_by_id.dart';
import 'package:tezda_task/features/product/domain/use_cases/get_product_usecase.dart';
import 'package:tezda_task/features/product/presentation/providers/product_state.dart';
import '../../domain/repositories/product_repository.dart';

// Data Source Provider
final productRemoteDataSourceProvider = Provider<ProductRemoteDataSource>((ref) {
  return ProductRemoteDataSourceImpl(
    dioClient: ref.watch(dioClientProvider),
  );
});

// Repository Provider
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepositoryImpl(
    remoteDataSource: ref.watch(productRemoteDataSourceProvider),
  );
});

// Use Cases Providers
final getProductsUseCaseProvider = Provider<GetProductsUseCase>((ref) {
  return GetProductsUseCase(ref.watch(productRepositoryProvider));
});

final getProductByIdUseCaseProvider = Provider<GetProductByIdUseCase>((ref) {
  return GetProductByIdUseCase(ref.watch(productRepositoryProvider));
});

// Product State Notifier
class ProductNotifier extends Notifier<ProductState> {
  @override
  ProductState build() {
    return const ProductState();
  }

  Future<void> getProducts() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      
      final useCase = ref.read(getProductsUseCaseProvider);
      final products = await useCase();
      
      state = state.copyWith(
        products: products,
        isLoading: false,
      );
    } catch (e) {
      String errorMessage = 'Failed to load products';
      if (e is NetworkException) {
        errorMessage = e.message;
      }
      
      state = state.copyWith(
        isLoading: false,
        errorMessage: errorMessage,
      );
    }
  }

  Future<void> getProductById(int id) async {
    try {
      state = state.copyWith(isLoadingProduct: true, errorMessage: null);
      
      final useCase = ref.read(getProductByIdUseCaseProvider);
      final product = await useCase(id);
      
      state = state.copyWith(
        selectedProduct: product,
        isLoadingProduct: false,
      );
    } catch (e) {
      String errorMessage = 'Failed to load product';
      if (e is NetworkException) {
        errorMessage = e.message;
      }
      
      state = state.copyWith(
        isLoadingProduct: false,
        errorMessage: errorMessage,
      );
    }
  }

  void clearError() {
    state = state.clearError();
  }

  void clearSelectedProduct() {
    state = state.clearSelectedProduct();
  }

  Future<void> refreshProducts() async {
    await getProducts();
  }
}

// Main Product Provider
final productProvider = NotifierProvider<ProductNotifier, ProductState>(() {
  return ProductNotifier();
});

// Convenience providers for specific data
final productsListProvider = Provider<List<ProductEntity>>((ref) {
  return ref.watch(productProvider).products;
});

final selectedProductProvider = Provider<ProductEntity?>((ref) {
  return ref.watch(productProvider).selectedProduct;
});

final isLoadingProductsProvider = Provider<bool>((ref) {
  return ref.watch(productProvider).isLoading;
});

final isLoadingProductProvider = Provider<bool>((ref) {
  return ref.watch(productProvider).isLoadingProduct;
});

final productErrorProvider = Provider<String?>((ref) {
  return ref.watch(productProvider).errorMessage;
});

// // Featured products (first 6 products)
// final featuredProductsProvider = Provider<List<ProductEntity>>((ref) {
//   final products = ref.watch(productsListProvider);
//   return products.take(6).toList();
// });

