class InventoryModel {
  final int id;
  final int productId;
  final int branchId;
  final int quantity;
  final int? minStock;
  final int? maxStock;

  InventoryModel({
    required this.id,
    required this.productId,
    required this.branchId,
    required this.quantity,
    this.minStock,
    this.maxStock,
  });

  factory InventoryModel.fromJson(Map<String, dynamic> json) {
    return InventoryModel(
      id: json['id'],
      productId: json['product_id'],
      branchId: json['branch_id'],
      quantity: json['quantity'],
      minStock: json['min_stock'],
      maxStock: json['max_stock'],
    );
  }
}
