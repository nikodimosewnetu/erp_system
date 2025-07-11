import '../entities/inventory.dart';

abstract class InventoryRepositoryInterface {
  Future<List<Inventory>> fetchInventory();
  Future<Inventory> createInventory(Map<String, dynamic> data);
  Future<Inventory> updateInventory(int id, Map<String, dynamic> data);
  Future<void> deleteInventory(int id);
}
