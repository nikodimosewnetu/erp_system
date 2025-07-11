import '../../domain/entities/invoice.dart';

class InvoiceModel extends Invoice {
  InvoiceModel({
    required int id,
    required int salesOrderId,
    required DateTime invoiceDate,
    DateTime? dueDate,
    required double totalAmount,
    required String status,
  }) : super(
          id: id,
          salesOrderId: salesOrderId,
          invoiceDate: invoiceDate,
          dueDate: dueDate,
          totalAmount: totalAmount,
          status: status,
        );

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      id: json['id'],
      salesOrderId: json['sales_order_id'],
      invoiceDate: DateTime.parse(json['invoice_date']),
      dueDate:
          json['due_date'] != null ? DateTime.parse(json['due_date']) : null,
      totalAmount: (json['total_amount'] as num).toDouble(),
      status: json['status'],
    );
  }

  factory InvoiceModel.fromEntity(Invoice entity) {
    return InvoiceModel(
      id: entity.id,
      salesOrderId: entity.salesOrderId,
      invoiceDate: entity.invoiceDate,
      dueDate: entity.dueDate,
      totalAmount: entity.totalAmount,
      status: entity.status,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'sales_order_id': salesOrderId,
        'invoice_date': invoiceDate.toIso8601String(),
        'due_date': dueDate?.toIso8601String(),
        'total_amount': totalAmount,
        'status': status,
      };
}
