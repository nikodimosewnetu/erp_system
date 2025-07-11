import '../entities/customer.dart';

abstract class CustomerRepositoryInterface {
  Future<List<Customer>> fetchCustomers();
  Future<Customer> createCustomer(Map<String, dynamic> data);
  Future<Customer> updateCustomer(int id, Map<String, dynamic> data);
  Future<void> deleteCustomer(int id);
}
