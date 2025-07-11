import '../entities/finance.dart';

abstract class FinanceRepositoryInterface {
  Future<List<Finance>> getFinances();
  Future<Finance?> getFinance(int id);
  Future<void> createFinance(Map<String, dynamic> data);
  Future<void> updateFinance(int id, Map<String, dynamic> data);
  Future<void> deleteFinance(int id);
}
