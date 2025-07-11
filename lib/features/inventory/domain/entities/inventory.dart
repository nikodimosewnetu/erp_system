class Inventory {
  final int id;
  final int productId;
  final int branchId;
  final int quantity;
  final int? minStock;
  final int? maxStock;

  Inventory({
    required this.id,
    required this.productId,
    required this.branchId,
    required this.quantity,
    this.minStock,
    this.maxStock,
  });
}
