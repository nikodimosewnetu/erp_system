import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF1a1a1a),
        scaffoldBackgroundColor: const Color(0xFFf8f9fa),
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF1a1a1a),
          secondary: const Color(0xFF2c3e50),
          surface: Colors.white,
          background: const Color(0xFFf8f9fa),
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: const Color(0xFF1a1a1a),
          onBackground: const Color(0xFF1a1a1a),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1a1a1a),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1a1a1a),
            foregroundColor: Colors.white,
            elevation: 2,
            shadowColor: Colors.black.withOpacity(0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF1a1a1a), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red.shade300),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          labelStyle: TextStyle(color: Colors.grey.shade600),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1a1a1a),
          ),
          headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1a1a1a),
          ),
          titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1a1a1a),
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1a1a1a),
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Color(0xFF1a1a1a),
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: Color(0xFF1a1a1a),
          ),
        ),
        drawerTheme: const DrawerThemeData(
          backgroundColor: Color(0xFF1a1a1a),
        ),
      );
}
