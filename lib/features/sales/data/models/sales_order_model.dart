import '../../domain/entities/sales_order.dart';

class SalesOrderModel extends SalesOrder {
  SalesOrderModel({
    required int id,
    required String orderNumber,
    required int customerId,
    required DateTime orderDate,
    required double totalAmount,
    required String status,
    required List<SalesOrderItem> items,
  }) : super(
          id: id,
          orderNumber: orderNumber,
          customerId: customerId,
          orderDate: orderDate,
          totalAmount: totalAmount,
          status: status,
          items: items,
        );

  factory SalesOrderModel.fromJson(Map<String, dynamic> json) {
    return SalesOrderModel(
      id: json['id'],
      orderNumber: json['order_number'],
      customerId: json['customer_id'],
      orderDate: DateTime.parse(json['order_date']),
      totalAmount: (json['total_amount'] as num).toDouble(),
      status: json['status'],
      items: (json['items'] as List)
          .map(
            (item) => SalesOrderItem(
              id: item['id'],
              productId: item['product_id'],
              quantity: item['quantity'],
              price: (item['price'] as num).toDouble(),
            ),
          )
          .toList(),
    );
  }

  factory SalesOrderModel.fromEntity(SalesOrder entity) {
    return SalesOrderModel(
      id: entity.id,
      orderNumber: entity.orderNumber,
      customerId: entity.customerId,
      orderDate: entity.orderDate,
      totalAmount: entity.totalAmount,
      status: entity.status,
      items: entity.items,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'order_number': orderNumber,
        'customer_id': customerId,
        'order_date': orderDate.toIso8601String(),
        'total_amount': totalAmount,
        'status': status,
        'items': items
            .map(
              (item) => {
                'id': item.id,
                'product_id': item.productId,
                'quantity': item.quantity,
                'price': item.price,
              },
            )
            .toList(),
      };
}
