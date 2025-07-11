import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../models/customer_model.dart';

class CustomerRepository {
  final ApiClient apiClient;
  CustomerRepository(this.apiClient);

  Future<List<CustomerModel>> fetchCustomers() async {
    final response = await apiClient.dio.get('customers');
    final List data = response.data as List;
    return data.map((json) => CustomerModel.fromJson(json)).toList();
  }

  Future<CustomerModel> createCustomer(Map<String, dynamic> data) async {
    final response = await apiClient.dio.post('customers', data: data);
    return CustomerModel.fromJson(response.data);
  }

  Future<CustomerModel> updateCustomer(
    int id,
    Map<String, dynamic> data,
  ) async {
    final response = await apiClient.dio.put('customers/$id', data: data);
    return CustomerModel.fromJson(response.data);
  }

  Future<void> deleteCustomer(int id) async {
    await apiClient.dio.delete('customers/$id');
  }
}
