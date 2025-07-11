import 'package:flutter/material.dart';

enum UserRole { admin, manager, employee, accountant }

class RoleProvider extends InheritedWidget {
  final UserRole role;
  final ValueChanged<UserRole> onRoleChanged;

  const RoleProvider({
    Key? key,
    required this.role,
    required this.onRoleChanged,
    required Widget child,
  }) : super(key: key, child: child);

  static RoleProvider of(BuildContext context) {
    final RoleProvider? result = context
        .dependOnInheritedWidgetOfExactType<RoleProvider>();
    assert(result != null, 'No RoleProvider found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(RoleProvider oldWidget) => role != oldWidget.role;
}
