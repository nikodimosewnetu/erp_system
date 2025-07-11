import '../../domain/entities/sales_order.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/repositories/sales_repository_interface.dart';
import '../models/sales_order_model.dart';
import '../models/invoice_model.dart';
import '../../../../core/network/api_client.dart';

class SalesRepository implements SalesRepositoryInterface {
  final ApiClient apiClient;
  SalesRepository(this.apiClient);

  @override
  Future<List<SalesOrder>> getSalesOrders() async {
    try {
      final response = await apiClient.dio.get('sales-orders');
      if (response.statusCode == 200) {
        final List data = response.data as List;
        return data.map((json) => SalesOrderModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching sales orders: $e');
      return [];
    }
  }

  @override
  Future<SalesOrder?> getSalesOrder(int id) async {
    final response = await apiClient.dio.get('sales-orders/$id');
    return SalesOrderModel.fromJson(response.data);
  }

  @override
  Future<void> createSalesOrder(SalesOrder order) async {
    await apiClient.dio
        .post('sales-orders', data: SalesOrderModel.fromEntity(order).toJson());
  }

  @override
  Future<void> updateSalesOrder(SalesOrder order) async {
    await apiClient.dio.put('sales-orders/${order.id}',
        data: SalesOrderModel.fromEntity(order).toJson());
  }

  @override
  Future<void> deleteSalesOrder(int id) async {
    await apiClient.dio.delete('sales-orders/$id');
  }

  @override
  Future<List<Invoice>> getInvoices() async {
    try {
      final response = await apiClient.dio.get('invoices');
      if (response.statusCode == 200) {
        final List data = response.data as List;
        return data.map((json) => InvoiceModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching invoices: $e');
      return [];
    }
  }

  @override
  Future<Invoice?> getInvoice(int id) async {
    final response = await apiClient.dio.get('invoices/$id');
    return InvoiceModel.fromJson(response.data);
  }

  @override
  Future<void> createInvoice(Invoice invoice) async {
    await apiClient.dio
        .post('invoices', data: InvoiceModel.fromEntity(invoice).toJson());
  }

  @override
  Future<void> updateInvoice(Invoice invoice) async {
    await apiClient.dio.put('invoices/${invoice.id}',
        data: InvoiceModel.fromEntity(invoice).toJson());
  }

  @override
  Future<void> deleteInvoice(int id) async {
    await apiClient.dio.delete('invoices/$id');
  }
}
