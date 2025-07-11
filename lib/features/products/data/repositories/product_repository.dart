import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../models/product_model.dart';

class ProductRepository {
  final ApiClient apiClient;
  ProductRepository(this.apiClient);

  Future<List<ProductModel>> fetchProducts() async {
    final response = await apiClient.dio.get('products');
    final List data = response.data as List;
    return data.map((json) => ProductModel.fromJson(json)).toList();
  }

  Future<ProductModel> createProduct(Map<String, dynamic> data) async {
    final response = await apiClient.dio.post('products', data: data);
    return ProductModel.fromJson(response.data);
  }

  Future<ProductModel> updateProduct(int id, Map<String, dynamic> data) async {
    final response = await apiClient.dio.put('products/$id', data: data);
    return ProductModel.fromJson(response.data);
  }

  Future<void> deleteProduct(int id) async {
    await apiClient.dio.delete('products/$id');
  }
}
