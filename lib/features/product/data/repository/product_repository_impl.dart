import 'package:tezda_task/features/product/data/data_source/product_remote_data_source.dart';
import 'package:tezda_task/features/product/domain/entities/product_entity.dart';
import 'package:tezda_task/features/product/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remoteDataSource;

  ProductRepositoryImpl({
    required ProductRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<List<ProductEntity>> getProducts() async {
    try {
      final productModels = await _remoteDataSource.getProducts();
      return productModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ProductEntity> getProductById(int id) async {
    try {
      final productModel = await _remoteDataSource.getProductById(id);
      return productModel.toEntity();
    } catch (e) {
      rethrow;
    }
  }
}
