import 'package:flutter/material.dart';

const primaryColor = Color(0xFF333333);
const secondaryColor = Color(0xFF4F4F4F);
const backgroundColor = Color(0xFFF5F5F5);
const surfaceColor = Color(0xFFE0E0E0);
const baseTextColor = Color(0xFF666666);
const iconColor = Color(0xFFB0BEC5);
const selectedColor = Color(0xFF424242);
const unselectedColor = Color(0xFFE0E0E0);

const baseTextStyle = TextStyle(color: baseTextColor);
const titleTextStyle = TextStyle(
  color: baseTextColor,
  fontWeight: FontWeight.bold,
);

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      primaryColor: primaryColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        foregroundColor: primaryColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: const ColorScheme(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.black,
        brightness: Brightness.light,
        error: Colors.red,
        onError: Colors.white,
      ),
      textTheme: const TextTheme(
        bodyLarge: baseTextStyle,
        bodyMedium: baseTextStyle,
        bodySmall: baseTextStyle,
        titleLarge: titleTextStyle,
        titleMedium: titleTextStyle,
        titleSmall: titleTextStyle,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      bottomAppBarTheme: const BottomAppBarTheme(
        color: primaryColor,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: backgroundColor,
      ),
      dividerColor: secondaryColor,
      iconTheme: const IconThemeData(
        color: iconColor,
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: iconColor,
        ),
      ),
      switchTheme: SwitchThemeData(
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return selectedColor;
          }
          return unselectedColor;
        }),
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.black;
          }
          return Colors.grey.shade600;
        }),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: unselectedColor,
        selectedColor: selectedColor,
        secondarySelectedColor: selectedColor,
        labelStyle: const TextStyle(color: primaryColor),
        secondaryLabelStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
