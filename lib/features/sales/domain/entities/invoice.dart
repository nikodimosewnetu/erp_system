class Invoice {
  final int id;
  final int salesOrderId;
  final DateTime invoiceDate;
  final DateTime? dueDate;
  final double totalAmount;
  final String status;

  Invoice({
    required this.id,
    required this.salesOrderId,
    required this.invoiceDate,
    this.dueDate,
    required this.totalAmount,
    required this.status,
  });
}
