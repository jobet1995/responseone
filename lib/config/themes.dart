import 'package:flutter/material.dart';

/// Central theme configuration for the ResQNow Emergency Response App.
/// This class provides a consistent look and feel across the application,
/// utilizing Material 3 design principles.
class AppTheme {
  AppTheme._();

  // --- Brand Colors ---
  static const Color primaryRed = Color(0xFFD32F2F); // Urgent / Emergency Red
  static const Color primaryRedDark = Color(0xFFB71C1C);
  static const Color secondaryBlue = Color(0xFF1976D2); // Professional / Trust Blue
  static const Color accentOrange = Color(0xFFFF9800); // Warning / Caution
  
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color surfaceLight = Colors.white;
  static const Color errorColor = Color(0xFFB00020);

  // --- Text Colors ---
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textOnPrimary = Colors.white;

  // --- Spacing & Radius ---
  static const double borderRadius = 12.0;
  static const double defaultPadding = 16.0;

  /// Light Theme Data
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryRed,
        primary: primaryRed,
        secondary: secondaryBlue,
        surface: surfaceLight,
        error: errorColor,
        onPrimary: textOnPrimary,
        onSurface: textPrimary,
      ),
      scaffoldBackgroundColor: backgroundLight,
      
      // --- Typography ---
      textTheme: _textTheme,
      
      // --- AppBar Theme ---
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryRed,
        foregroundColor: textOnPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textOnPrimary,
        ),
        iconTheme: IconThemeData(color: textOnPrimary),
      ),

      // --- Button Themes ---
      elevatedButtonTheme: _elevatedButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      textButtonTheme: _textButtonTheme,

      // --- Input Decoration (TextFields) ---
      inputDecorationTheme: _inputDecorationTheme,

      // --- Other Component Themes ---
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryRed,
        foregroundColor: textOnPrimary,
      ),
    );
  }

  // Define local helper for text theme to keep main getter clean
  static TextTheme get _textTheme {
    return const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textPrimary,
        letterSpacing: -1.0,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textPrimary,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: textPrimary,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: textSecondary,
        height: 1.4,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: primaryRed,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        color: textSecondary,
      ),
    );
  }

  static ElevatedButtonThemeData get _elevatedButtonTheme {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 1,
        backgroundColor: primaryRed,
        foregroundColor: textOnPrimary,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  static OutlinedButtonThemeData get _outlinedButtonTheme {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryRed,
        side: const BorderSide(color: primaryRed, width: 1.5),
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  static TextButtonThemeData get _textButtonTheme {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: secondaryBlue,
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static InputDecorationTheme get _inputDecorationTheme {
    const outlineBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 1.5),
    );

    const focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      borderSide: BorderSide(color: primaryRed, width: 2.0),
    );

    const errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      borderSide: BorderSide(color: errorColor, width: 1.5),
    );

    return const InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 18,
      ),
      border: outlineBorder,
      enabledBorder: outlineBorder,
      focusedBorder: focusedBorder,
      errorBorder: errorBorder,
      focusedErrorBorder: focusedBorder,
      hintStyle: TextStyle(color: textSecondary, fontSize: 14),
      labelStyle: TextStyle(color: textSecondary, fontSize: 14),
    );
  }
}
