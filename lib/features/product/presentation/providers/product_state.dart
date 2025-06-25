import 'package:tezda_task/features/product/domain/entities/product_entity.dart';

class ProductState {
  final List<ProductEntity> products;
  final ProductEntity? selectedProduct;
  final bool isLoading;
  final bool isLoadingProduct;
  final String? errorMessage;

  const ProductState({
    this.products = const [],
    this.selectedProduct,
    this.isLoading = false,
    this.isLoadingProduct = false,
    this.errorMessage,
  });

  ProductState copyWith({
    List<ProductEntity>? products,
    ProductEntity? selectedProduct,
    bool? isLoading,
    bool? isLoadingProduct,
    String? errorMessage,
  }) {
    return ProductState(
      products: products ?? this.products,
      selectedProduct: selectedProduct ?? this.selectedProduct,
      isLoading: isLoading ?? this.isLoading,
      isLoadingProduct: isLoadingProduct ?? this.isLoadingProduct,
      errorMessage: errorMessage,
    );
  }

  ProductState clearError() {
    return copyWith(errorMessage: null);
  }

  ProductState clearSelectedProduct() {
    return copyWith(selectedProduct: null);
  }

  @override
  String toString() {
    return 'ProductState(products: ${products.length}, selectedProduct: $selectedProduct, isLoading: $isLoading, isLoadingProduct: $isLoadingProduct, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(covariant ProductState other) {
    if (identical(this, other)) return true;
  
    return 
      _listEquals(other.products, products) &&
      other.selectedProduct == selectedProduct &&
      other.isLoading == isLoading &&
      other.isLoadingProduct == isLoadingProduct &&
      other.errorMessage == errorMessage;
  }

  @override
  int get hashCode {
    return products.hashCode ^
      selectedProduct.hashCode ^
      isLoading.hashCode ^
      isLoadingProduct.hashCode ^
      errorMessage.hashCode;
  }

  bool _listEquals<T>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
