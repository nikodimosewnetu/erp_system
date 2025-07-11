import '../entities/employee.dart';

abstract class EmployeeRepositoryInterface {
  Future<List<Employee>> getEmployees();
  Future<Employee?> getEmployee(int id);
  Future<void> createEmployee(Employee employee);
  Future<void> updateEmployee(Employee employee);
  Future<void> deleteEmployee(int id);
}
