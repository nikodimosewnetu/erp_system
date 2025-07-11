import '../../domain/entities/employee.dart';
import '../../domain/repositories/employee_repository_interface.dart';
import '../models/employee_model.dart';
import '../../../../core/network/api_client.dart';

class EmployeeRepository implements EmployeeRepositoryInterface {
  final ApiClient _apiClient;

  EmployeeRepository(this._apiClient);

  @override
  Future<List<Employee>> getEmployees() async {
    try {
      final response = await _apiClient.dio.get('employees');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => EmployeeModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching employees: $e');
      return [];
    }
  }

  @override
  Future<Employee?> getEmployee(int id) async {
    try {
      final response = await _apiClient.dio.get('employees/$id');
      if (response.statusCode == 200) {
        return EmployeeModel.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print('Error fetching employee: $e');
      return null;
    }
  }

  @override
  Future<void> createEmployee(Employee employee) async {
    try {
      final employeeModel = EmployeeModel(
        id: employee.id,
        name: employee.name,
        email: employee.email,
        phone: employee.phone,
        position: employee.position,
        department: employee.department,
        salary: employee.salary,
        hireDate: employee.hireDate,
      );
      await _apiClient.dio.post('employees', data: employeeModel.toJson());
    } catch (e) {
      print('Error creating employee: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateEmployee(Employee employee) async {
    try {
      final employeeModel = EmployeeModel(
        id: employee.id,
        name: employee.name,
        email: employee.email,
        phone: employee.phone,
        position: employee.position,
        department: employee.department,
        salary: employee.salary,
        hireDate: employee.hireDate,
      );
      await _apiClient.dio
          .put('employees/${employee.id}', data: employeeModel.toJson());
    } catch (e) {
      print('Error updating employee: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteEmployee(int id) async {
    try {
      await _apiClient.dio.delete('employees/$id');
    } catch (e) {
      print('Error deleting employee: $e');
      rethrow;
    }
  }
}
