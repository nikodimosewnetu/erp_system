class ProductModel {
  final int id;
  final String name;
  final String sku;
  final double price;
  final double? costPrice;
  final String? description;
  final String? unit;

  ProductModel({
    required this.id,
    required this.name,
    required this.sku,
    required this.price,
    this.costPrice,
    this.description,
    this.unit,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      sku: json['sku'],
      price: (json['price'] as num).toDouble(),
      costPrice: json['cost_price'] != null
          ? (json['cost_price'] as num).toDouble()
          : null,
      description: json['description'],
      unit: json['unit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sku': sku,
      'price': price,
      'cost_price': costPrice,
      'description': description,
      'unit': unit,
    };
  }
}
