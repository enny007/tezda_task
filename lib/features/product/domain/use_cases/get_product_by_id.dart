import 'package:tezda_task/features/product/domain/entities/product_entity.dart';
import 'package:tezda_task/features/product/domain/repositories/product_repository.dart';

class GetProductByIdUseCase {
  final ProductRepository _repository;

  GetProductByIdUseCase(this._repository);

  Future<ProductEntity> call(int id) async {
    return await _repository.getProductById(id);
  }
}
