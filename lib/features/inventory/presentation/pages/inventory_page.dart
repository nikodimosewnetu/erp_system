import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/inventory_cubit.dart';
import '../../data/repositories/inventory_repository.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/role/role_provider.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<InventoryCubit>().fetchInventory());
  }

  void _showInventoryDialog(
    BuildContext context, {
    Map<String, dynamic>? initial,
    int? id,
  }) {
    final productIdController = TextEditingController(
      text: initial?['product_id']?.toString() ?? '',
    );
    final branchIdController = TextEditingController(
      text: initial?['branch_id']?.toString() ?? '',
    );
    final quantityController = TextEditingController(
      text: initial?['quantity']?.toString() ?? '',
    );
    final minStockController = TextEditingController(
      text: initial?['min_stock']?.toString() ?? '',
    );
    final maxStockController = TextEditingController(
      text: initial?['max_stock']?.toString() ?? '',
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(id == null ? 'Add Inventory' : 'Edit Inventory'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: productIdController,
                decoration: const InputDecoration(labelText: 'Product ID'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: branchIdController,
                decoration: const InputDecoration(labelText: 'Branch ID'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: minStockController,
                decoration: const InputDecoration(labelText: 'Min Stock'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: maxStockController,
                decoration: const InputDecoration(labelText: 'Max Stock'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final data = {
                'product_id':
                    int.tryParse(productIdController.text.trim()) ?? 0,
                'branch_id': int.tryParse(branchIdController.text.trim()) ?? 0,
                'quantity': int.tryParse(quantityController.text.trim()) ?? 0,
                'min_stock': int.tryParse(minStockController.text.trim()),
                'max_stock': int.tryParse(maxStockController.text.trim()),
              };
              if (id == null) {
                context.read<InventoryCubit>().createInventory(data);
              } else {
                context.read<InventoryCubit>().updateInventory(id, data);
              }
              Navigator.pop(ctx);
            },
            child: Text(id == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Inventory'),
        content: const Text(
          'Are you sure you want to delete this inventory record?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<InventoryCubit>().deleteInventory(id);
              Navigator.pop(ctx);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final role = RoleProvider.of(context).role;
    final canModify = role == UserRole.admin || role == UserRole.manager;
    return BlocProvider(
      create: (_) =>
          InventoryCubit(InventoryRepository(sl()))..fetchInventory(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Inventory')),
        floatingActionButton: canModify
            ? FloatingActionButton(
                onPressed: () => _showInventoryDialog(context),
                child: const Icon(Icons.add),
              )
            : null,
        body: BlocBuilder<InventoryCubit, InventoryState>(
          builder: (context, state) {
            if (state is InventoryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is InventoryLoaded) {
              if (state.inventory.isEmpty) {
                return const Center(child: Text('No inventory records found.'));
              }
              return ListView.builder(
                itemCount: state.inventory.length,
                itemBuilder: (context, index) {
                  final inv = state.inventory[index];
                  return ListTile(
                    title: Text('Product ID: ${inv.productId}'),
                    subtitle: Text('Branch ID: ${inv.branchId}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (canModify)
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _showInventoryDialog(
                              context,
                              initial: {
                                'product_id': inv.productId,
                                'branch_id': inv.branchId,
                                'quantity': inv.quantity,
                                'min_stock': inv.minStock,
                                'max_stock': inv.maxStock,
                              },
                              id: inv.id,
                            ),
                          ),
                        if (canModify)
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _confirmDelete(context, inv.id),
                          ),
                      ],
                    ),
                  );
                },
              );
            } else if (state is InventoryError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
