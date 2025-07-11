class SalesOrder {
  final int id;
  final String orderNumber;
  final int customerId;
  final DateTime orderDate;
  final double totalAmount;
  final String status;
  final List<SalesOrderItem> items;

  SalesOrder({
    required this.id,
    required this.orderNumber,
    required this.customerId,
    required this.orderDate,
    required this.totalAmount,
    required this.status,
    required this.items,
  });
}

class SalesOrderItem {
  final int id;
  final int productId;
  final int quantity;
  final double price;

  SalesOrderItem({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.price,
  });
}
