class Product {
  final int id;
  final String name;
  final String sku;
  final double price;
  final String? description;
  final String? unit;

  Product({
    required this.id,
    required this.name,
    required this.sku,
    required this.price,
    this.description,
    this.unit,
  });
}
