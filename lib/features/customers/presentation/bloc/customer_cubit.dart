import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/customer_repository.dart';
import '../../data/models/customer_model.dart';

part 'customer_state.dart';

class CustomerCubit extends Cubit<CustomerState> {
  final CustomerRepository customerRepository;
  CustomerCubit(this.customerRepository) : super(CustomerInitial());

  Future<void> fetchCustomers() async {
    emit(CustomerLoading());
    try {
      final customers = await customerRepository.fetchCustomers();
      emit(CustomerLoaded(customers));
    } catch (e) {
      emit(CustomerError('Failed to fetch customers'));
    }
  }

  Future<void> createCustomer(Map<String, dynamic> data) async {
    emit(CustomerLoading());
    try {
      await customerRepository.createCustomer(data);
      await fetchCustomers();
    } catch (e) {
      emit(CustomerError('Failed to create customer'));
    }
  }

  Future<void> updateCustomer(int id, Map<String, dynamic> data) async {
    emit(CustomerLoading());
    try {
      await customerRepository.updateCustomer(id, data);
      await fetchCustomers();
    } catch (e) {
      emit(CustomerError('Failed to update customer'));
    }
  }

  Future<void> deleteCustomer(int id) async {
    emit(CustomerLoading());
    try {
      await customerRepository.deleteCustomer(id);
      await fetchCustomers();
    } catch (e) {
      emit(CustomerError('Failed to delete customer'));
    }
  }
}
