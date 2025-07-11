import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../models/inventory_model.dart';

class InventoryRepository {
  final ApiClient apiClient;
  InventoryRepository(this.apiClient);

  Future<List<InventoryModel>> fetchInventory() async {
    final response = await apiClient.dio.get('inventories');
    final List data = response.data as List;
    return data.map((json) => InventoryModel.fromJson(json)).toList();
  }

  Future<InventoryModel> createInventory(Map<String, dynamic> data) async {
    final response = await apiClient.dio.post('inventories', data: data);
    return InventoryModel.fromJson(response.data);
  }

  Future<InventoryModel> updateInventory(
    int id,
    Map<String, dynamic> data,
  ) async {
    final response = await apiClient.dio.put('inventories/$id', data: data);
    return InventoryModel.fromJson(response.data);
  }

  Future<void> deleteInventory(int id) async {
    await apiClient.dio.delete('inventories/$id');
  }
}
