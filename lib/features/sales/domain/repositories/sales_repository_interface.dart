import '../entities/sales_order.dart';
import '../entities/invoice.dart';

abstract class SalesRepositoryInterface {
  // Sales Orders
  Future<List<SalesOrder>> getSalesOrders();
  Future<SalesOrder?> getSalesOrder(int id);
  Future<void> createSalesOrder(SalesOrder order);
  Future<void> updateSalesOrder(SalesOrder order);
  Future<void> deleteSalesOrder(int id);

  // Invoices
  Future<List<Invoice>> getInvoices();
  Future<Invoice?> getInvoice(int id);
  Future<void> createInvoice(Invoice invoice);
  Future<void> updateInvoice(Invoice invoice);
  Future<void> deleteInvoice(int id);
}
