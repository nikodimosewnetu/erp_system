class Customer {
  final int id;
  final String name;
  final String? companyName;
  final String? email;
  final String? phone;
  final String? address;
  final String type;

  Customer({
    required this.id,
    required this.name,
    this.companyName,
    this.email,
    this.phone,
    this.address,
    required this.type,
  });
}
