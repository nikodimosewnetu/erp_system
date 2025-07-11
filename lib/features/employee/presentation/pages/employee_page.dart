import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/employee_cubit.dart';
import '../bloc/employee_state.dart';
import '../../data/repositories/employee_repository.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/role/role_provider.dart';
import '../../data/models/employee_model.dart';
import '../../domain/entities/employee.dart';

class EmployeePage extends StatefulWidget {
  const EmployeePage({Key? key}) : super(key: key);

  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showEmployeeDialog(BuildContext context,
      {Map<String, dynamic>? initial, int? id}) {
    final nameController = TextEditingController(text: initial?['name'] ?? '');
    final emailController =
        TextEditingController(text: initial?['email'] ?? '');
    final phoneController =
        TextEditingController(text: initial?['phone'] ?? '');
    final positionController =
        TextEditingController(text: initial?['position'] ?? '');
    final departmentController =
        TextEditingController(text: initial?['department'] ?? '');
    final salaryController =
        TextEditingController(text: initial?['salary']?.toString() ?? '');
    final hireDateController =
        TextEditingController(text: initial?['hire_date'] ?? '');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(id == null ? Icons.person_add : Icons.edit,
                color: const Color(0xFF1a1a1a)),
            const SizedBox(width: 8),
            Text(id == null ? 'Add Employee' : 'Edit Employee',
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
                    labelText: 'Name', prefixIcon: Icon(Icons.person)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    labelText: 'Email', prefixIcon: Icon(Icons.email)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                    labelText: 'Phone', prefixIcon: Icon(Icons.phone)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: positionController,
                decoration: const InputDecoration(
                    labelText: 'Position', prefixIcon: Icon(Icons.work)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: departmentController,
                decoration: const InputDecoration(
                    labelText: 'Department', prefixIcon: Icon(Icons.apartment)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: salaryController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: 'Salary', prefixIcon: Icon(Icons.attach_money)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: hireDateController,
                decoration: const InputDecoration(
                    labelText: 'Hire Date (YYYY-MM-DD)',
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
                'name': nameController.text.trim(),
                'email': emailController.text.trim(),
                'phone': phoneController.text.trim(),
                'position': positionController.text.trim(),
                'department': departmentController.text.trim(),
                'salary': double.tryParse(salaryController.text.trim()) ?? 0,
                'hire_date': hireDateController.text.trim(),
              };
              if (id == null) {
                final employee = Employee(
                  id: 0, // Will be set by backend
                  name: data['name'] as String,
                  email: data['email'] as String,
                  phone: data['phone'] as String,
                  position: data['position'] as String?,
                  department: data['department'] as String?,
                  salary: data['salary'] as double?,
                  hireDate: data['hire_date'] as String?,
                );
                context.read<EmployeeCubit>().createEmployee(employee);
              } else {
                final employee = Employee(
                  id: id,
                  name: data['name'] as String,
                  email: data['email'] as String,
                  phone: data['phone'] as String,
                  position: data['position'] as String?,
                  department: data['department'] as String?,
                  salary: data['salary'] as double?,
                  hireDate: data['hire_date'] as String?,
                );
                context.read<EmployeeCubit>().updateEmployee(employee);
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
            Text('Delete Employee')
          ],
        ),
        content: const Text('Are you sure you want to delete this employee?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              context.read<EmployeeCubit>().deleteEmployee(id);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  List<Employee> _filterEmployees(List<Employee> employees) {
    if (_searchQuery.isEmpty) return employees;
    return employees.where((employee) {
      return employee.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (employee.email?.toLowerCase().contains(_searchQuery.toLowerCase()) ??
              false) ||
          (employee.position
                  ?.toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ??
              false);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final role = RoleProvider.of(context).role;
    final canModify = role == UserRole.admin || role == UserRole.manager;
    return BlocProvider(
      create: (_) => EmployeeCubit(EmployeeRepository(sl()))..fetchEmployees(),
      child: Scaffold(
        backgroundColor: const Color(0xFFf8f9fa),
        appBar: AppBar(
          title: const Text('Employees'),
          elevation: 0,
          backgroundColor: const Color(0xFF1a1a1a),
          foregroundColor: Colors.white,
        ),
        floatingActionButton: canModify
            ? FloatingActionButton.extended(
                onPressed: () => _showEmployeeDialog(context),
                backgroundColor: const Color(0xFF1a1a1a),
                foregroundColor: Colors.white,
                icon: const Icon(Icons.add),
                label: const Text('Add Employee'),
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
                  hintText: 'Search employees...',
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
            // Employees List
            Expanded(
              child: BlocBuilder<EmployeeCubit, EmployeeState>(
                builder: (context, state) {
                  if (state is EmployeeLoading) {
                    return const Center(
                        child: CircularProgressIndicator(
                            color: Color(0xFF1a1a1a)));
                  } else if (state is EmployeeLoaded) {
                    final filteredEmployees = _filterEmployees(state.employees);
                    if (filteredEmployees.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.people_outline,
                                size: 64, color: Colors.grey.shade400),
                            const SizedBox(height: 16),
                            Text(
                                _searchQuery.isEmpty
                                    ? 'No employees found.'
                                    : 'No employees match your search.',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey.shade600)),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredEmployees.length,
                      itemBuilder: (context, index) {
                        final employee = filteredEmployees[index];
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
                                          color: Colors.orange.shade100,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: const Icon(Icons.person,
                                            color: Color(0xFF1a1a1a), size: 20),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(employee.name,
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            if (employee.position != null)
                                              Text(employee.position!,
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
                                              _showEmployeeDialog(context,
                                                  initial: {
                                                    'name': employee.name,
                                                    'email': employee.email,
                                                    'phone': employee.phone,
                                                    'position':
                                                        employee.position,
                                                    'department':
                                                        employee.department,
                                                    'salary': employee.salary,
                                                    'hire_date':
                                                        employee.hireDate,
                                                  },
                                                  id: employee.id);
                                            } else if (value == 'delete') {
                                              _confirmDelete(
                                                  context, employee.id);
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
                                  if (employee.email != null)
                                    Row(
                                      children: [
                                        Icon(Icons.email,
                                            size: 16,
                                            color: Colors.grey.shade600),
                                        const SizedBox(width: 4),
                                        Expanded(
                                            child: Text(employee.email!,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color:
                                                        Colors.grey.shade600))),
                                      ],
                                    ),
                                  if (employee.phone != null)
                                    Row(
                                      children: [
                                        Icon(Icons.phone,
                                            size: 16,
                                            color: Colors.grey.shade600),
                                        const SizedBox(width: 4),
                                        Text(employee.phone!,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey.shade600)),
                                      ],
                                    ),
                                  if (employee.department != null)
                                    Row(
                                      children: [
                                        Icon(Icons.apartment,
                                            size: 16,
                                            color: Colors.grey.shade600),
                                        const SizedBox(width: 4),
                                        Text(employee.department!,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey.shade600)),
                                      ],
                                    ),
                                  if (employee.salary != null)
                                    Row(
                                      children: [
                                        Icon(Icons.attach_money,
                                            size: 16,
                                            color: Colors.green.shade700),
                                        const SizedBox(width: 4),
                                        Text('Salary: ${employee.salary}',
                                            style:
                                                const TextStyle(fontSize: 12)),
                                      ],
                                    ),
                                  if (employee.hireDate != null)
                                    Row(
                                      children: [
                                        Icon(Icons.date_range,
                                            size: 16,
                                            color: Colors.blue.shade700),
                                        const SizedBox(width: 4),
                                        Text('Hired: ${employee.hireDate}',
                                            style:
                                                const TextStyle(fontSize: 12)),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is EmployeeError) {
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
