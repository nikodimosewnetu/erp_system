import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/employee.dart';
import '../../domain/repositories/employee_repository_interface.dart';
import 'employee_state.dart';

class EmployeeCubit extends Cubit<EmployeeState> {
  final EmployeeRepositoryInterface repository;
  EmployeeCubit(this.repository) : super(EmployeeInitial());

  Future<void> fetchEmployees() async {
    emit(EmployeeLoading());
    try {
      final employees = await repository.getEmployees();
      emit(EmployeeLoaded(employees));
    } catch (e) {
      emit(EmployeeError('Failed to fetch employees'));
    }
  }

  Future<void> createEmployee(Employee employee) async {
    emit(EmployeeLoading());
    try {
      await repository.createEmployee(employee);
      await fetchEmployees();
    } catch (e) {
      emit(EmployeeError('Failed to create employee'));
    }
  }

  Future<void> updateEmployee(Employee employee) async {
    emit(EmployeeLoading());
    try {
      await repository.updateEmployee(employee);
      await fetchEmployees();
    } catch (e) {
      emit(EmployeeError('Failed to update employee'));
    }
  }

  Future<void> deleteEmployee(int id) async {
    emit(EmployeeLoading());
    try {
      await repository.deleteEmployee(id);
      await fetchEmployees();
    } catch (e) {
      emit(EmployeeError('Failed to delete employee'));
    }
  }
}
