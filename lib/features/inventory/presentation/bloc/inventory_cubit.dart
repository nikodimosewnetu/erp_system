import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/inventory_repository.dart';
import '../../data/models/inventory_model.dart';

part 'inventory_state.dart';

class InventoryCubit extends Cubit<InventoryState> {
  final InventoryRepository inventoryRepository;
  InventoryCubit(this.inventoryRepository) : super(InventoryInitial());

  Future<void> fetchInventory() async {
    emit(InventoryLoading());
    try {
      final inventory = await inventoryRepository.fetchInventory();
      emit(InventoryLoaded(inventory));
    } catch (e) {
      emit(InventoryError('Failed to fetch inventory'));
    }
  }

  Future<void> createInventory(Map<String, dynamic> data) async {
    emit(InventoryLoading());
    try {
      await inventoryRepository.createInventory(data);
      await fetchInventory();
    } catch (e) {
      emit(InventoryError('Failed to create inventory'));
    }
  }

  Future<void> updateInventory(int id, Map<String, dynamic> data) async {
    emit(InventoryLoading());
    try {
      await inventoryRepository.updateInventory(id, data);
      await fetchInventory();
    } catch (e) {
      emit(InventoryError('Failed to update inventory'));
    }
  }

  Future<void> deleteInventory(int id) async {
    emit(InventoryLoading());
    try {
      await inventoryRepository.deleteInventory(id);
      await fetchInventory();
    } catch (e) {
      emit(InventoryError('Failed to delete inventory'));
    }
  }
}
