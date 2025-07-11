part of 'customer_cubit.dart';

abstract class CustomerState {}

class CustomerInitial extends CustomerState {}

class CustomerLoading extends CustomerState {}

class CustomerLoaded extends CustomerState {
  final List<CustomerModel> customers;
  CustomerLoaded(this.customers);
}

class CustomerError extends CustomerState {
  final String message;
  CustomerError(this.message);
}
