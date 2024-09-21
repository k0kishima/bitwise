import 'package:flutter/material.dart';

const baseTextStyle = TextStyle(color: Colors.black54);

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      primaryColor: Colors.black87,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      scaffoldBackgroundColor: Colors.white,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.grey.shade600,
          side: const BorderSide(color: Colors.grey, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: baseTextStyle,
        bodyMedium: baseTextStyle,
        bodySmall: baseTextStyle,
      ),
    );
  }
}
