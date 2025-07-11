import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/sales_cubit.dart';
import '../bloc/sales_state.dart';
import '../../domain/entities/sales_order.dart';
import '../../domain/entities/invoice.dart';
import '../../data/repositories/sales_repository.dart';
import '../../../../core/di/injector.dart';
import '../../../customers/data/repositories/customer_repository.dart';
import '../../../customers/data/models/customer_model.dart';
import '../../../products/data/repositories/product_repository.dart';
import '../../../products/data/models/product_model.dart';
import '../../data/models/sales_order_model.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/role/role_provider.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({Key? key}) : super(key: key);

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Filtering state
  String _orderNumberFilter = '';
  String _customerFilter = '';
  String _statusFilter = '';
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.microtask(() {
      context.read<SalesCubit>().fetchSalesOrders();
      context.read<SalesCubit>().fetchInvoices();
    });
  }

  Widget _buildFilterBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: const InputDecoration(labelText: 'Order Number'),
              onChanged: (val) => setState(() => _orderNumberFilter = val),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              decoration: const InputDecoration(labelText: 'Customer'),
              onChanged: (val) => setState(() => _customerFilter = val),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              decoration: const InputDecoration(labelText: 'Status'),
              onChanged: (val) => setState(() => _statusFilter = val),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: () async {
              final picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                initialDateRange: _startDate != null && _endDate != null
                    ? DateTimeRange(start: _startDate!, end: _endDate!)
                    : null,
              );
              if (picked != null) {
                setState(() {
                  _startDate = picked.start;
                  _endDate = picked.end;
                });
              }
            },
          ),
          if (_startDate != null && _endDate != null)
            TextButton(
              onPressed: () => setState(() {
                _startDate = null;
                _endDate = null;
              }),
              child: const Text('Clear Dates'),
            ),
        ],
      ),
    );
  }

  List<SalesOrder> _applyOrderFilters(List<SalesOrder> orders) {
    return orders.where((order) {
      final matchesOrderNumber = _orderNumberFilter.isEmpty ||
          order.orderNumber.contains(_orderNumberFilter);
      final matchesCustomer = _customerFilter.isEmpty ||
          order.customerId.toString().contains(
                _customerFilter,
              ); // TODO: map to customer name
      final matchesStatus = _statusFilter.isEmpty ||
          order.status.toLowerCase().contains(_statusFilter.toLowerCase());
      final matchesDate = (_startDate == null && _endDate == null) ||
          (order.orderDate.isAfter(_startDate ?? DateTime(2000)) &&
              order.orderDate.isBefore(
                _endDate?.add(const Duration(days: 1)) ?? DateTime(2100),
              ));
      return matchesOrderNumber &&
          matchesCustomer &&
          matchesStatus &&
          matchesDate;
    }).toList();
  }

  void _showSalesOrderDialog(BuildContext context, {SalesOrder? initial}) {
    final orderNumberController = TextEditingController(
      text: initial?.orderNumber ?? '',
    );
    final totalAmountController = TextEditingController(
      text: initial?.totalAmount.toString() ?? '',
    );
    final statusController = TextEditingController(text: initial?.status ?? '');
    CustomerModel? selectedCustomer;
    List<_OrderProductEntry> selectedProducts = initial?.items
            .map(
              (item) => _OrderProductEntry(
                productId: item.productId,
                quantity: item.quantity,
                price: item.price,
              ),
            )
            .toList() ??
        [];

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(initial == null ? 'Add Sales Order' : 'Edit Sales Order'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: orderNumberController,
                decoration: const InputDecoration(labelText: 'Order Number'),
              ),
              FutureBuilder<List<CustomerModel>>(
                future: CustomerRepository(ApiClient()).fetchCustomers(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  final customers = snapshot.data!;
                  return DropdownButtonFormField<CustomerModel>(
                    value: selectedCustomer,
                    items: customers
                        .map(
                          (c) => DropdownMenuItem(
                            value: c,
                            child: Text(
                              '${c.name}${c.companyName != null ? ' (${c.companyName})' : ''}${c.email != null ? ' - ${c.email}' : ''}',
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (c) => selectedCustomer = c,
                    decoration: const InputDecoration(labelText: 'Customer'),
                  );
                },
              ),
              FutureBuilder<List<ProductModel>>(
                future: ProductRepository(ApiClient()).fetchProducts(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  final products = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<ProductModel>(
                        value: null,
                        items: products
                            .map(
                              (p) => DropdownMenuItem(
                                value: p,
                                child: Text(
                                  '${p.name} (${p.sku}) - ${p.price}',
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (p) {
                          if (p != null &&
                              !selectedProducts.any(
                                (e) => e.productId == p.id,
                              )) {
                            selectedProducts.add(
                              _OrderProductEntry(
                                productId: p.id,
                                quantity: 1,
                                price: p.price,
                              ),
                            );
                          }
                        },
                        decoration: const InputDecoration(
                          labelText: 'Add Product',
                        ),
                      ),
                      if (selectedProducts.isNotEmpty)
                        ...selectedProducts.map((entry) {
                          final product = products.firstWhere(
                            (p) => p.id == entry.productId,
                          );
                          return Row(
                            children: [
                              Expanded(
                                child: Text('${product.name} (${product.sku})'),
                              ),
                              SizedBox(
                                width: 60,
                                child: TextField(
                                  decoration: const InputDecoration(
                                    labelText: 'Qty',
                                  ),
                                  keyboardType: TextInputType.number,
                                  controller: TextEditingController(
                                    text: entry.quantity.toString(),
                                  ),
                                  onChanged: (val) =>
                                      entry.quantity = int.tryParse(val) ?? 1,
                                ),
                              ),
                              SizedBox(
                                width: 80,
                                child: TextField(
                                  decoration: const InputDecoration(
                                    labelText: 'Price',
                                  ),
                                  keyboardType: TextInputType.number,
                                  controller: TextEditingController(
                                    text: entry.price.toString(),
                                  ),
                                  onChanged: (val) => entry.price =
                                      double.tryParse(val) ?? product.price,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  selectedProducts.remove(entry);
                                },
                              ),
                            ],
                          );
                        }),
                    ],
                  );
                },
              ),
              TextField(
                controller: totalAmountController,
                decoration: const InputDecoration(labelText: 'Total Amount'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: statusController,
                decoration: const InputDecoration(labelText: 'Status'),
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
              final order = SalesOrder(
                id: initial?.id ?? 0,
                orderNumber: orderNumberController.text.trim(),
                customerId: selectedCustomer?.id ?? 0,
                orderDate: initial?.orderDate ?? DateTime.now(),
                totalAmount:
                    double.tryParse(totalAmountController.text.trim()) ?? 0.0,
                status: statusController.text.trim(),
                items: selectedProducts
                    .map(
                      (e) => SalesOrderItem(
                        id: 0,
                        productId: e.productId,
                        quantity: e.quantity,
                        price: e.price,
                      ),
                    )
                    .toList(),
              );
              if (initial == null) {
                context.read<SalesCubit>().createSalesOrder(order);
              } else {
                context.read<SalesCubit>().updateSalesOrder(order);
              }
              Navigator.pop(ctx);
            },
            child: Text(initial == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteSalesOrder(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Sales Order'),
        content: const Text(
          'Are you sure you want to delete this sales order?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<SalesCubit>().deleteSalesOrder(id);
              Navigator.pop(ctx);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showInvoiceDialog(BuildContext context, {Invoice? initial}) {
    final totalAmountController = TextEditingController(
      text: initial?.totalAmount.toString() ?? '',
    );
    final statusController = TextEditingController(text: initial?.status ?? '');
    SalesOrderModel? selectedOrder;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(initial == null ? 'Add Invoice' : 'Edit Invoice'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FutureBuilder<List<SalesOrderModel>>(
                future: SalesRepository(sl<ApiClient>()).getSalesOrders().then(
                      (orders) => orders
                          .map(
                            (e) => e is SalesOrderModel
                                ? e
                                : SalesOrderModel(
                                    id: e.id,
                                    orderNumber: e.orderNumber,
                                    customerId: e.customerId,
                                    orderDate: e.orderDate,
                                    totalAmount: e.totalAmount,
                                    status: e.status,
                                    items: e.items,
                                  ),
                          )
                          .toList(),
                    ),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  final orders = snapshot.data!;
                  return DropdownButtonFormField<SalesOrderModel>(
                    value: selectedOrder,
                    items: orders
                        .map(
                          (o) => DropdownMenuItem(
                            value: o,
                            child: Text(
                              'Order #${o.orderNumber} - Customer: ${o.customerId} - Total: ${o.totalAmount}',
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (o) => selectedOrder = o,
                    decoration: const InputDecoration(labelText: 'Sales Order'),
                  );
                },
              ),
              TextField(
                controller: totalAmountController,
                decoration: const InputDecoration(labelText: 'Total Amount'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: statusController,
                decoration: const InputDecoration(labelText: 'Status'),
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
              final invoice = Invoice(
                id: initial?.id ?? 0,
                salesOrderId: selectedOrder?.id ?? 0,
                invoiceDate: initial?.invoiceDate ?? DateTime.now(),
                totalAmount:
                    double.tryParse(totalAmountController.text.trim()) ?? 0.0,
                status: statusController.text.trim(),
              );
              if (initial == null) {
                context.read<SalesCubit>().createInvoice(invoice);
              } else {
                context.read<SalesCubit>().updateInvoice(invoice);
              }
              Navigator.pop(ctx);
            },
            child: Text(initial == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteInvoice(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Invoice'),
        content: const Text('Are you sure you want to delete this invoice?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<SalesCubit>().deleteInvoice(id);
              Navigator.pop(ctx);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showSalesOrderDetailsDialog(BuildContext context, SalesOrder order) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Sales Order #${order.orderNumber}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Customer ID: ${order.customerId}'),
              Text('Order Date: ${order.orderDate}'),
              Text('Total Amount: ${order.totalAmount}'),
              Text('Status: ${order.status}'),
              const SizedBox(height: 8),
              const Text(
                'Items:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...order.items.map(
                (item) => Text(
                  'Product ID: ${item.productId}, Qty: ${item.quantity}, Price: ${item.price}',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showInvoiceDetailsDialog(BuildContext context, Invoice invoice) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Invoice #${invoice.id}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Sales Order ID: ${invoice.salesOrderId}'),
              Text('Invoice Date: ${invoice.invoiceDate}'),
              Text('Total Amount: ${invoice.totalAmount}'),
              Text('Status: ${invoice.status}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final role = RoleProvider.of(context).role;
    final canModify = role == UserRole.admin || role == UserRole.manager;
    return BlocProvider(
      create: (_) => SalesCubit(SalesRepository(sl<ApiClient>()))
        ..fetchSalesOrders()
        ..fetchInvoices(),
      child: Scaffold(
        backgroundColor: const Color(0xFFf8f9fa),
        appBar: AppBar(
          title: const Text(
            'Sales Management',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 0,
          backgroundColor: const Color(0xFF1a1a1a),
          foregroundColor: Colors.white,
          bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: const [
              Tab(text: 'Sales Orders'),
              Tab(text: 'Invoices'),
            ],
          ),
        ),
        body: Column(
          children: [
            _buildFilterBar(context),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _SalesOrdersTab(
                    showDialog: _showSalesOrderDialog,
                    orderFilters: _applyOrderFilters,
                    canModify: canModify,
                  ),
                  _InvoicesTab(
                    showDialog: _showInvoiceDialog,
                    canModify: canModify,
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: canModify
            ? Builder(
                builder: (context) {
                  if (_tabController.index == 0) {
                    return FloatingActionButton.extended(
                      onPressed: () => _showSalesOrderDialog(context),
                      backgroundColor: const Color(0xFF1a1a1a),
                      foregroundColor: Colors.white,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Order'),
                    );
                  } else {
                    return FloatingActionButton.extended(
                      onPressed: () => _showInvoiceDialog(context),
                      backgroundColor: const Color(0xFF1a1a1a),
                      foregroundColor: Colors.white,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Invoice'),
                    );
                  }
                },
              )
            : null,
      ),
    );
  }
}

class _SalesOrdersTab extends StatelessWidget {
  final void Function(BuildContext, {SalesOrder? initial}) showDialog;
  final List<SalesOrder> Function(List<SalesOrder>)? orderFilters;
  final bool canModify;
  const _SalesOrdersTab({
    required this.showDialog,
    this.orderFilters,
    required this.canModify,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SalesCubit, SalesState>(
      builder: (context, state) {
        if (state is SalesLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SalesOrdersLoaded) {
          final filteredOrders = orderFilters != null
              ? orderFilters!(state.salesOrders)
              : state.salesOrders;
          return _SalesOrdersList(
            orders: filteredOrders,
            showDialog: showDialog,
            canModify: canModify,
          );
        } else if (state is SalesError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        return const Center(child: Text('No data available'));
      },
    );
  }
}

class _SalesOrdersList extends StatelessWidget {
  final List<SalesOrder> orders;
  final void Function(BuildContext, {SalesOrder? initial}) showDialog;
  final bool canModify;
  const _SalesOrdersList({
    required this.orders,
    required this.showDialog,
    required this.canModify,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              'Order #${order.orderNumber}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  'Customer ID: ${order.customerId}',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                Text(
                  'Total: ₦${order.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                Text(
                  'Status: ${order.status}',
                  style: TextStyle(
                    color: order.status == 'confirmed'
                        ? Colors.green
                        : order.status == 'pending'
                            ? Colors.orange
                            : Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            trailing: canModify
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Color(0xFF1a1a1a)),
                        onPressed: () => showDialog(context, initial: order),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          /* TODO: Delete order */
                        },
                      ),
                    ],
                  )
                : null,
            onTap: () {
              /* TODO: View order details */
            },
          ),
        );
      },
    );
  }
}

class _InvoicesTab extends StatelessWidget {
  final void Function(BuildContext, {Invoice? initial}) showDialog;
  final bool canModify;
  const _InvoicesTab({required this.showDialog, required this.canModify});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SalesCubit, SalesState>(
      builder: (context, state) {
        if (state is SalesLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is InvoicesLoaded) {
          return _InvoicesList(
            invoices: state.invoices,
            showDialog: showDialog,
            canModify: canModify,
          );
        } else if (state is SalesError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        return const Center(child: Text('No data available'));
      },
    );
  }
}

class _InvoicesList extends StatelessWidget {
  final List<Invoice> invoices;
  final void Function(BuildContext, {Invoice? initial}) showDialog;
  final bool canModify;
  const _InvoicesList({
    required this.invoices,
    required this.showDialog,
    required this.canModify,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: invoices.length,
      itemBuilder: (context, index) {
        final invoice = invoices[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              'Invoice #${invoice.id}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  'Sales Order ID: ${invoice.salesOrderId}',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                Text(
                  'Total: ₦${invoice.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                Text(
                  'Status: ${invoice.status}',
                  style: TextStyle(
                    color: invoice.status == 'paid'
                        ? Colors.green
                        : invoice.status == 'unpaid'
                            ? Colors.orange
                            : Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Date: ${invoice.invoiceDate.toString().split(' ')[0]}',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
            trailing: canModify
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Color(0xFF1a1a1a)),
                        onPressed: () => showDialog(context, initial: invoice),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          /* TODO: Delete invoice */
                        },
                      ),
                    ],
                  )
                : null,
            onTap: () {
              /* TODO: View invoice details */
            },
          ),
        );
      },
    );
  }
}

// Helper class for product entry in order dialog
class _OrderProductEntry {
  int productId;
  int quantity;
  double price;
  _OrderProductEntry({
    required this.productId,
    required this.quantity,
    required this.price,
  });
}
