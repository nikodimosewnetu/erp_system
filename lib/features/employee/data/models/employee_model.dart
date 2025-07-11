import '../../domain/entities/employee.dart';

class EmployeeModel extends Employee {
  EmployeeModel({
    required int id,
    required String name,
    required String email,
    required String phone,
    String? position,
    String? department,
    double? salary,
    String? hireDate,
  }) : super(
          id: id,
          name: name,
          email: email,
          phone: phone,
          position: position,
          department: department,
          salary: salary,
          hireDate: hireDate,
        );

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      position: json['position'],
      department: json['department'],
      salary: (json['salary'] is int)
          ? (json['salary'] as int).toDouble()
          : (json['salary'] as num?)?.toDouble(),
      hireDate: json['hire_date'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'position': position,
        'department': department,
        'salary': salary,
        'hire_date': hireDate,
      };
}
