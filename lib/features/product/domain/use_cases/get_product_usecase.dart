import 'package:tezda_task/features/product/domain/entities/product_entity.dart';
import 'package:tezda_task/features/product/domain/repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository _repository;

  GetProductsUseCase(this._repository);

  Future<List<ProductEntity>> call() async {
    return await _repository.getProducts();
  }
}

