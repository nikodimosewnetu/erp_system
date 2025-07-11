import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'core/role/role_provider.dart';
import 'core/di/injector.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  UserRole _role = UserRole.admin;

  @override
  Widget build(BuildContext context) {
    return RoleProvider(
      role: _role,
      onRoleChanged: (role) => setState(() => _role = role),
      child: MaterialApp(
        title: 'AMG Holdings ERP',
        theme: AppTheme.light,
        debugShowCheckedModeBanner: false,
        home: const LoginPage(),
      ),
    );
  }
}
