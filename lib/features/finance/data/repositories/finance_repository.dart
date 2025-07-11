import '../../domain/entities/finance.dart';
import '../../domain/repositories/finance_repository_interface.dart';
import '../models/finance_model.dart';
import '../../../../core/network/api_client.dart';

class FinanceRepository implements FinanceRepositoryInterface {
  final ApiClient apiClient;

  FinanceRepository(this.apiClient);

  @override
  Future<List<Finance>> getFinances() async {
    try {
      final response = await apiClient.dio.get('finances');
      final List<dynamic> data = response.data;
      return data.map((json) => FinanceModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch finances: $e');
    }
  }

  @override
  Future<Finance?> getFinance(int id) async {
    try {
      final response = await apiClient.dio.get('finances/$id');
      return FinanceModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch finance: $e');
    }
  }

  @override
  Future<void> createFinance(Map<String, dynamic> data) async {
    try {
      await apiClient.dio.post('finances', data: data);
    } catch (e) {
      throw Exception('Failed to create finance: $e');
    }
  }

  @override
  Future<void> updateFinance(int id, Map<String, dynamic> data) async {
    try {
      await apiClient.dio.put('finances/$id', data: data);
    } catch (e) {
      throw Exception('Failed to update finance: $e');
    }
  }

  @override
  Future<void> deleteFinance(int id) async {
    try {
      await apiClient.dio.delete('finances/$id');
    } catch (e) {
      throw Exception('Failed to delete finance: $e');
    }
  }
}
