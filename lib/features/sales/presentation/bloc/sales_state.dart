import '../../domain/entities/sales_order.dart';
import '../../domain/entities/invoice.dart';

abstract class SalesState {}

class SalesInitial extends SalesState {}

class SalesLoading extends SalesState {}

class SalesOrdersLoaded extends SalesState {
  final List<SalesOrder> salesOrders;
  SalesOrdersLoaded(this.salesOrders);
}

class InvoicesLoaded extends SalesState {
  final List<Invoice> invoices;
  InvoicesLoaded(this.invoices);
}

class SalesError extends SalesState {
  final String message;
  SalesError(this.message);
}
