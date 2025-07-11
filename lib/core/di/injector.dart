import 'package:get_it/get_it.dart';
import '../network/api_client.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/products/data/repositories/product_repository.dart';
import '../../features/customers/data/repositories/customer_repository.dart';
import '../../features/inventory/data/repositories/inventory_repository.dart';
import '../../features/employee/data/repositories/employee_repository.dart';
import '../../features/finance/data/repositories/finance_repository.dart';
import '../../features/sales/data/repositories/sales_repository.dart';

final sl = GetIt.instance;

void setupLocator() {
  // Register API client
  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  // Register repositories
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepository(sl<ApiClient>()));
  sl.registerLazySingleton<ProductRepository>(
      () => ProductRepository(sl<ApiClient>()));
  sl.registerLazySingleton<CustomerRepository>(
      () => CustomerRepository(sl<ApiClient>()));
  sl.registerLazySingleton<InventoryRepository>(
      () => InventoryRepository(sl<ApiClient>()));
  sl.registerLazySingleton<EmployeeRepository>(
      () => EmployeeRepository(sl<ApiClient>()));
  sl.registerLazySingleton<FinanceRepository>(
      () => FinanceRepository(sl<ApiClient>()));
  sl.registerLazySingleton<SalesRepository>(
      () => SalesRepository(sl<ApiClient>()));
}
