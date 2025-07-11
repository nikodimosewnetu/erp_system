class CustomerModel {
  final int id;
  final String name;
  final String? companyName;
  final String? email;
  final String? phone;
  final String? address;
  final String type;

  CustomerModel({
    required this.id,
    required this.name,
    this.companyName,
    this.email,
    this.phone,
    this.address,
    required this.type,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'],
      name: json['name'],
      companyName: json['company_name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      type: json['type'],
    );
  }
}
