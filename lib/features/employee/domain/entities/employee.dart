class Employee {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String? position;
  final String? department;
  final double? salary;
  final String? hireDate;

  Employee({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.position,
    this.department,
    this.salary,
    this.hireDate,
  });
}
