import 'package:dio/dio.dart';
import 'package:tezda_task/core/constants/api_constants.dart';
import 'package:tezda_task/core/exceptions/auth_exception.dart';
import 'package:tezda_task/core/network/dio_client.dart';
import 'package:tezda_task/features/product/data/model/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> getProductById(int id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final DioClient _dioClient;

  ProductRemoteDataSourceImpl({required DioClient dioClient})
      : _dioClient = dioClient;

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await _dioClient.get(ApiConstants.products);
      final List<dynamic> productsJson = response.data as List<dynamic>;
      
      return productsJson
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException {
      rethrow;
    } catch (e) {
      throw NetworkException('Failed to parse products data');
    }
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    try {
      final response = await _dioClient.get('${ApiConstants.products}/$id');
      return ProductModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException {
      rethrow;
    } catch (e) {
      throw NetworkException('Failed to parse product data');
    }
  }
}
