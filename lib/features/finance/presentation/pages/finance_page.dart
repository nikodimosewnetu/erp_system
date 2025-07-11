import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/finance_cubit.dart';
import '../bloc/finance_state.dart';
import '../../data/repositories/finance_repository.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/role/role_provider.dart';
import '../../data/models/finance_model.dart';
import '../../domain/entities/finance.dart';

class FinancePage extends StatefulWidget {
  const FinancePage({Key? key}) : super(key: key);

  @override
  State<FinancePage> createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFinanceDialog(BuildContext context,
      {Map<String, dynamic>? initial, int? id}) {
    String type = initial?['type'] ?? 'income';
    final amountController =
        TextEditingController(text: initial?['amount']?.toString() ?? '');
    final descController =
        TextEditingController(text: initial?['description'] ?? '');
    final dateController = TextEditingController(text: initial?['date'] ?? '');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(id == null ? Icons.add : Icons.edit,
                color: const Color(0xFF1a1a1a)),
            const SizedBox(width: 8),
            Text(id == null ? 'Add Finance Record' : 'Edit Finance Record',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Color(0xFF1a1a1a))),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: type,
                items: const [
                  DropdownMenuItem(value: 'income', child: Text('Income')),
                  DropdownMenuItem(value: 'expense', child: Text('Expense')),
                ],
                onChanged: (val) => setState(() => type = val ?? 'income'),
                decoration: const InputDecoration(
                    labelText: 'Type', prefixIcon: Icon(Icons.category)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: 'Amount', prefixIcon: Icon(Icons.attach_money)),
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
                controller: dateController,
                decoration: const InputDecoration(
                    labelText: 'Date (YYYY-MM-DD)',
                    prefixIcon: Icon(Icons.date_range)),
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
                'type': type,
                'amount': double.tryParse(amountController.text.trim()) ?? 0,
                'description': descController.text.trim(),
                'date': dateController.text.trim(),
              };
              if (id == null) {
                context.read<FinanceCubit>().createFinance(data);
              } else {
                context.read<FinanceCubit>().updateFinance(id, data);
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
            Text('Delete Record')
          ],
        ),
        content: const Text('Are you sure you want to delete this record?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              context.read<FinanceCubit>().deleteFinance(id);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  List<Finance> _filterFinance(List<Finance> records) {
    if (_searchQuery.isEmpty) return records;
    return records.where((rec) {
      return rec.description
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          rec.type.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final role = RoleProvider.of(context).role;
    final canModify = role == UserRole.admin || role == UserRole.accountant;
    return BlocProvider(
      create: (_) => FinanceCubit(FinanceRepository(sl()))..fetchFinances(),
      child: Scaffold(
        backgroundColor: const Color(0xFFf8f9fa),
        appBar: AppBar(
          title: const Text('Finance'),
          elevation: 0,
          backgroundColor: const Color(0xFF1a1a1a),
          foregroundColor: Colors.white,
        ),
        floatingActionButton: canModify
            ? FloatingActionButton.extended(
                onPressed: () => _showFinanceDialog(context),
                backgroundColor: const Color(0xFF1a1a1a),
                foregroundColor: Colors.white,
                icon: const Icon(Icons.add),
                label: const Text('Add Record'),
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
                  hintText: 'Search finance records...',
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
            // Finance List
            Expanded(
              child: BlocBuilder<FinanceCubit, FinanceState>(
                builder: (context, state) {
                  if (state is FinanceLoading) {
                    return const Center(
                        child: CircularProgressIndicator(
                            color: Color(0xFF1a1a1a)));
                  } else if (state is FinanceLoaded) {
                    final filteredRecords = _filterFinance(state.finances);
                    if (filteredRecords.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.account_balance_wallet_outlined,
                                size: 64, color: Colors.grey.shade400),
                            const SizedBox(height: 16),
                            Text(
                                _searchQuery.isEmpty
                                    ? 'No finance records found.'
                                    : 'No records match your search.',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey.shade600)),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredRecords.length,
                      itemBuilder: (context, index) {
                        final rec = filteredRecords[index];
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
                                          color: rec.type == 'income'
                                              ? Colors.green.shade100
                                              : Colors.red.shade100,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Icon(
                                          rec.type == 'income'
                                              ? Icons.arrow_downward
                                              : Icons.arrow_upward,
                                          color: rec.type == 'income'
                                              ? Colors.green.shade700
                                              : Colors.red.shade700,
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
                                              rec.description,
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              rec.type.toUpperCase(),
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: rec.type == 'income'
                                                      ? Colors.green.shade700
                                                      : Colors.red.shade700),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (canModify)
                                        PopupMenuButton<String>(
                                          onSelected: (value) {
                                            if (value == 'edit') {
                                              _showFinanceDialog(context,
                                                  initial: {
                                                    'type': rec.type,
                                                    'amount': rec.amount,
                                                    'description':
                                                        rec.description,
                                                    'date': rec.date,
                                                  },
                                                  id: rec.id);
                                            } else if (value == 'delete') {
                                              _confirmDelete(context, rec.id);
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
                                  Row(
                                    children: [
                                      Icon(Icons.attach_money,
                                          size: 16,
                                          color: rec.type == 'income'
                                              ? Colors.green.shade700
                                              : Colors.red.shade700),
                                      const SizedBox(width: 4),
                                      Text('Amount: ${rec.amount}',
                                          style: const TextStyle(fontSize: 12)),
                                      const SizedBox(width: 16),
                                      Icon(Icons.date_range,
                                          size: 16,
                                          color: Colors.blue.shade700),
                                      const SizedBox(width: 4),
                                      Text('Date: ${rec.date}',
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
                  } else if (state is FinanceError) {
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
