import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/product_cubit.dart';
import '../../data/repositories/product_repository.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/role/role_provider.dart';
import '../../data/models/product_model.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showProductDialog(BuildContext context,
      {Map<String, dynamic>? initial, int? id}) {
    final nameController = TextEditingController(text: initial?['name'] ?? '');
    final descController =
        TextEditingController(text: initial?['description'] ?? '');
    final priceController =
        TextEditingController(text: initial?['price']?.toString() ?? '');
    final costPriceController =
        TextEditingController(text: initial?['cost_price']?.toString() ?? '');
    final skuController = TextEditingController(text: initial?['sku'] ?? '');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(id == null ? Icons.add : Icons.edit,
                color: const Color(0xFF1a1a1a)),
            const SizedBox(width: 8),
            Text(id == null ? 'Add Product' : 'Edit Product',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Color(0xFF1a1a1a))),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                    labelText: 'Name', prefixIcon: Icon(Icons.inventory)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descController,
                decoration: const InputDecoration(
                    labelText: 'Description',
                    prefixIcon: Icon(Icons.description)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: 'Price', prefixIcon: Icon(Icons.attach_money)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: costPriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: 'Cost Price', prefixIcon: Icon(Icons.money_off)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: skuController,
                decoration: const InputDecoration(
                    labelText: 'SKU', prefixIcon: Icon(Icons.qr_code)),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final data = {
                'name': nameController.text.trim(),
                'description': descController.text.trim(),
                'price': double.tryParse(priceController.text.trim()) ?? 0,
                'cost_price':
                    double.tryParse(costPriceController.text.trim()) ?? 0,
                'sku': skuController.text.trim(),
              };
              if (id == null) {
                context.read<ProductCubit>().createProduct(data);
              } else {
                context.read<ProductCubit>().updateProduct(id, data);
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 8),
            Text('Delete Product')
          ],
        ),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              context.read<ProductCubit>().deleteProduct(id);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  List<ProductModel> _filterProducts(List<ProductModel> products) {
    if (_searchQuery.isEmpty) return products;
    return products.where((product) {
      return product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (product.sku?.toLowerCase().contains(_searchQuery.toLowerCase()) ??
              false);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final role = RoleProvider.of(context).role;
    final canModify = role == UserRole.admin || role == UserRole.manager;
    return BlocProvider(
      create: (_) => ProductCubit(ProductRepository(sl()))..fetchProducts(),
      child: Scaffold(
        backgroundColor: const Color(0xFFf8f9fa),
        appBar: AppBar(
          title: const Text('Products'),
          elevation: 0,
          backgroundColor: const Color(0xFF1a1a1a),
          foregroundColor: Colors.white,
        ),
        floatingActionButton: canModify
            ? FloatingActionButton.extended(
                onPressed: () => _showProductDialog(context),
                backgroundColor: const Color(0xFF1a1a1a),
                foregroundColor: Colors.white,
                icon: const Icon(Icons.add),
                label: const Text('Add Product'),
              )
            : null,
        body: Column(
          children: [
            // Search and Filter Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            // Products List
            Expanded(
              child: BlocBuilder<ProductCubit, ProductState>(
                builder: (context, state) {
                  if (state is ProductLoading) {
                    return const Center(
                        child: CircularProgressIndicator(
                            color: Color(0xFF1a1a1a)));
                  } else if (state is ProductLoaded) {
                    final filteredProducts = _filterProducts(state.products);
                    if (filteredProducts.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inventory_2_outlined,
                                size: 64, color: Colors.grey.shade400),
                            const SizedBox(height: 16),
                            Text(
                                _searchQuery.isEmpty
                                    ? 'No products found.'
                                    : 'No products match your search.',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey.shade600)),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade100,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: const Icon(Icons.inventory,
                                            color: Color(0xFF1a1a1a), size: 20),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(product.name,
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            if (product.sku != null)
                                              Text(product.sku!,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors
                                                          .grey.shade600)),
                                          ],
                                        ),
                                      ),
                                      if (canModify)
                                        PopupMenuButton<String>(
                                          onSelected: (value) {
                                            if (value == 'edit') {
                                              _showProductDialog(context,
                                                  initial: {
                                                    'name': product.name,
                                                    'description':
                                                        product.description,
                                                    'price': product.price,
                                                    'cost_price':
                                                        product.costPrice,
                                                    'sku': product.sku,
                                                  },
                                                  id: product.id);
                                            } else if (value == 'delete') {
                                              _confirmDelete(
                                                  context, product.id);
                                            }
                                          },
                                          itemBuilder: (context) => [
                                            const PopupMenuItem(
                                              value: 'edit',
                                              child: Row(children: [
                                                Icon(Icons.edit, size: 16),
                                                SizedBox(width: 8),
                                                Text('Edit')
                                              ]),
                                            ),
                                            const PopupMenuItem(
                                              value: 'delete',
                                              child: Row(children: [
                                                Icon(Icons.delete,
                                                    size: 16,
                                                    color: Colors.red),
                                                SizedBox(width: 8),
                                                Text('Delete',
                                                    style: TextStyle(
                                                        color: Colors.red))
                                              ]),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  if (product.description != null)
                                    Text(product.description!,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey.shade700)),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(Icons.attach_money,
                                          size: 16,
                                          color: Colors.green.shade700),
                                      const SizedBox(width: 4),
                                      Text('Price: ${product.price}',
                                          style: const TextStyle(fontSize: 12)),
                                      const SizedBox(width: 16),
                                      Icon(Icons.money_off,
                                          size: 16, color: Colors.red.shade700),
                                      const SizedBox(width: 4),
                                      Text('Cost: ${product.costPrice}',
                                          style: const TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is ProductError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline,
                              size: 64, color: Colors.red.shade400),
                          const SizedBox(height: 16),
                          Text(state.message,
                              style: TextStyle(
                                  fontSize: 16, color: Colors.red.shade600)),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
