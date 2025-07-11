import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/sales_order.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/repositories/sales_repository_interface.dart';
import 'sales_state.dart';

class SalesCubit extends Cubit<SalesState> {
  final SalesRepositoryInterface salesRepository;
  SalesCubit(this.salesRepository) : super(SalesInitial());

  Future<void> fetchSalesOrders() async {
    emit(SalesLoading());
    try {
      final orders = await salesRepository.getSalesOrders();
      emit(SalesOrdersLoaded(orders));
    } catch (e) {
      emit(SalesError('Failed to fetch sales orders'));
    }
  }

  Future<void> fetchInvoices() async {
    emit(SalesLoading());
    try {
      final invoices = await salesRepository.getInvoices();
      emit(InvoicesLoaded(invoices));
    } catch (e) {
      emit(SalesError('Failed to fetch invoices'));
    }
  }

  Future<void> createSalesOrder(SalesOrder order) async {
    emit(SalesLoading());
    try {
      await salesRepository.createSalesOrder(order);
      await fetchSalesOrders();
    } catch (e) {
      emit(SalesError('Failed to create sales order'));
    }
  }

  Future<void> updateSalesOrder(SalesOrder order) async {
    emit(SalesLoading());
    try {
      await salesRepository.updateSalesOrder(order);
      await fetchSalesOrders();
    } catch (e) {
      emit(SalesError('Failed to update sales order'));
    }
  }

  Future<void> deleteSalesOrder(int id) async {
    emit(SalesLoading());
    try {
      await salesRepository.deleteSalesOrder(id);
      await fetchSalesOrders();
    } catch (e) {
      emit(SalesError('Failed to delete sales order'));
    }
  }

  Future<void> createInvoice(Invoice invoice) async {
    emit(SalesLoading());
    try {
      await salesRepository.createInvoice(invoice);
      await fetchInvoices();
    } catch (e) {
      emit(SalesError('Failed to create invoice'));
    }
  }

  Future<void> updateInvoice(Invoice invoice) async {
    emit(SalesLoading());
    try {
      await salesRepository.updateInvoice(invoice);
      await fetchInvoices();
    } catch (e) {
      emit(SalesError('Failed to update invoice'));
    }
  }

  Future<void> deleteInvoice(int id) async {
    emit(SalesLoading());
    try {
      await salesRepository.deleteInvoice(id);
      await fetchInvoices();
    } catch (e) {
      emit(SalesError('Failed to delete invoice'));
    }
  }
}
