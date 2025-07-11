import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/customer_cubit.dart';
import '../../data/repositories/customer_repository.dart';
import '../../data/models/customer_model.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/role/role_provider.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<CustomerCubit>().fetchCustomers());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showCustomerDialog(
    BuildContext context, {
    Map<String, dynamic>? initial,
    int? id,
  }) {
    final nameController = TextEditingController(text: initial?['name'] ?? '');
    final companyNameController = TextEditingController(
      text: initial?['company_name'] ?? '',
    );
    final emailController = TextEditingController(
      text: initial?['email'] ?? '',
    );
    final phoneController = TextEditingController(
      text: initial?['phone'] ?? '',
    );
    final addressController = TextEditingController(
      text: initial?['address'] ?? '',
    );
    String type = initial?['type'] ?? 'corporate';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(
              id == null ? Icons.person_add : Icons.edit,
              color: const Color(0xFF1a1a1a),
            ),
            const SizedBox(width: 8),
            Text(
              id == null ? 'Add Customer' : 'Edit Customer',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF1a1a1a),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: companyNameController,
                decoration: const InputDecoration(
                  labelText: 'Company Name',
                  prefixIcon: Icon(Icons.business),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  prefixIcon: Icon(Icons.phone),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: addressController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  prefixIcon: Icon(Icons.location_on),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: type,
                items: const [
                  DropdownMenuItem(
                    value: 'corporate',
                    child: Text('Corporate'),
                  ),
                  DropdownMenuItem(
                    value: 'individual',
                    child: Text('Individual'),
                  ),
                ],
                onChanged: (val) => setState(() => type = val ?? 'corporate'),
                decoration: const InputDecoration(
                  labelText: 'Type',
                  prefixIcon: Icon(Icons.category),
                ),
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
                'name': nameController.text.trim(),
                'company_name': companyNameController.text.trim(),
                'email': emailController.text.trim(),
                'phone': phoneController.text.trim(),
                'address': addressController.text.trim(),
                'type': type,
              };
              if (id == null) {
                context.read<CustomerCubit>().createCustomer(data);
              } else {
                context.read<CustomerCubit>().updateCustomer(id, data);
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
            Text('Delete Customer'),
          ],
        ),
        content: const Text('Are you sure you want to delete this customer?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<CustomerCubit>().deleteCustomer(id);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  List<CustomerModel> _filterCustomers(List<CustomerModel> customers) {
    if (_searchQuery.isEmpty) return customers;
    return customers.where((customer) {
      return customer.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (customer.companyName
                  ?.toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ??
              false) ||
          (customer.email?.toLowerCase().contains(_searchQuery.toLowerCase()) ??
              false);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final role = RoleProvider.of(context).role;
    final canModify = role == UserRole.admin || role == UserRole.manager;

    return BlocProvider(
      create: (_) => CustomerCubit(CustomerRepository(sl()))..fetchCustomers(),
      child: Scaffold(
        backgroundColor: const Color(0xFFf8f9fa),
        appBar: AppBar(
          title: const Text('Customers'),
          elevation: 0,
          backgroundColor: const Color(0xFF1a1a1a),
          foregroundColor: Colors.white,
        ),
        floatingActionButton: canModify
            ? FloatingActionButton.extended(
                onPressed: () => _showCustomerDialog(context),
                backgroundColor: const Color(0xFF1a1a1a),
                foregroundColor: Colors.white,
                icon: const Icon(Icons.add),
                label: const Text('Add Customer'),
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
                  hintText: 'Search customers...',
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

            // Customers List
            Expanded(
              child: BlocBuilder<CustomerCubit, CustomerState>(
                builder: (context, state) {
                  if (state is CustomerLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF1a1a1a),
                      ),
                    );
                  } else if (state is CustomerLoaded) {
                    final filteredCustomers = _filterCustomers(state.customers);

                    if (filteredCustomers.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _searchQuery.isEmpty
                                  ? 'No customers found.'
                                  : 'No customers match your search.',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredCustomers.length,
                      itemBuilder: (context, index) {
                        final customer = filteredCustomers[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
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
                                          color: customer.type == 'corporate'
                                              ? Colors.blue.shade100
                                              : Colors.green.shade100,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Icon(
                                          customer.type == 'corporate'
                                              ? Icons.business
                                              : Icons.person,
                                          color: customer.type == 'corporate'
                                              ? Colors.blue.shade700
                                              : Colors.green.shade700,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              customer.name,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            if (customer.companyName != null)
                                              Text(
                                                customer.companyName!,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      if (canModify)
                                        PopupMenuButton<String>(
                                          onSelected: (value) {
                                            if (value == 'edit') {
                                              _showCustomerDialog(
                                                context,
                                                initial: {
                                                  'name': customer.name,
                                                  'company_name':
                                                      customer.companyName,
                                                  'email': customer.email,
                                                  'phone': customer.phone,
                                                  'address': customer.address,
                                                  'type': customer.type,
                                                },
                                                id: customer.id,
                                              );
                                            } else if (value == 'delete') {
                                              _confirmDelete(
                                                  context, customer.id);
                                            }
                                          },
                                          itemBuilder: (context) => [
                                            const PopupMenuItem(
                                              value: 'edit',
                                              child: Row(
                                                children: [
                                                  Icon(Icons.edit, size: 16),
                                                  SizedBox(width: 8),
                                                  Text('Edit'),
                                                ],
                                              ),
                                            ),
                                            const PopupMenuItem(
                                              value: 'delete',
                                              child: Row(
                                                children: [
                                                  Icon(Icons.delete,
                                                      size: 16,
                                                      color: Colors.red),
                                                  SizedBox(width: 8),
                                                  Text('Delete',
                                                      style: TextStyle(
                                                          color: Colors.red)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  if (customer.email != null ||
                                      customer.phone != null)
                                    Row(
                                      children: [
                                        if (customer.email != null) ...[
                                          Icon(Icons.email,
                                              size: 16,
                                              color: Colors.grey.shade600),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              customer.email!,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ),
                                        ],
                                        if (customer.phone != null) ...[
                                          Icon(Icons.phone,
                                              size: 16,
                                              color: Colors.grey.shade600),
                                          const SizedBox(width: 4),
                                          Text(
                                            customer.phone!,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  if (customer.address != null) ...[
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(Icons.location_on,
                                            size: 16,
                                            color: Colors.grey.shade600),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            customer.address!,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: customer.type == 'corporate'
                                          ? Colors.blue.shade50
                                          : Colors.green.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: customer.type == 'corporate'
                                            ? Colors.blue.shade200
                                            : Colors.green.shade200,
                                      ),
                                    ),
                                    child: Text(
                                      customer.type.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: customer.type == 'corporate'
                                            ? Colors.blue.shade700
                                            : Colors.green.shade700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is CustomerError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state.message,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.red.shade600,
                            ),
                          ),
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
