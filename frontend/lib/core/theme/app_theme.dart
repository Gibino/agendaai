import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Paleta de cores do Agenda AI
abstract class AppColors {
  // Primária
  static const primary = Color(0xFF6C63FF);
  static const primaryDark = Color(0xFF4B44CC);
  static const primaryLight = Color(0xFF9D97FF);

  // Destaque (promoções / badges)
  static const accent = Color(0xFFFF6584);

  // Sucesso
  static const success = Color(0xFF22C55E);

  // Superfícies — modo claro
  static const surfaceLight = Color(0xFFFAFAFA);
  static const cardLight = Color(0xFFFFFFFF);
  static const textPrimaryLight = Color(0xFF1A1A2E);
  static const textSecondaryLight = Color(0xFF6B7280);

  // Superfícies — modo escuro
  static const surfaceDark = Color(0xFF121212);
  static const cardDark = Color(0xFF1E1E2E);
  static const textPrimaryDark = Color(0xFFF0F0F0);
  static const textSecondaryDark = Color(0xFF9CA3AF);
}

/// Sistema de tipografia com fonte Inter
abstract class AppTextStyles {
  static TextStyle get display => GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      );

  static TextStyle get heading => GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
      );

  static TextStyle get body => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get caption => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get button => GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      );
}

/// Tema principal do app
class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
          surface: AppColors.surfaceLight,
        ),
        scaffoldBackgroundColor: AppColors.surfaceLight,
        cardColor: AppColors.cardLight,
        textTheme: _buildTextTheme(AppColors.textPrimaryLight, AppColors.textSecondaryLight),
        appBarTheme: _buildAppBarTheme(AppColors.surfaceLight, AppColors.textPrimaryLight),
        elevatedButtonTheme: _buildElevatedButtonTheme(),
        inputDecorationTheme: _buildInputDecorationTheme(isLight: true),
        navigationBarTheme: _buildNavBarTheme(isLight: true),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
          surface: AppColors.surfaceDark,
        ),
        scaffoldBackgroundColor: AppColors.surfaceDark,
        cardColor: AppColors.cardDark,
        textTheme: _buildTextTheme(AppColors.textPrimaryDark, AppColors.textSecondaryDark),
        appBarTheme: _buildAppBarTheme(AppColors.surfaceDark, AppColors.textPrimaryDark),
        elevatedButtonTheme: _buildElevatedButtonTheme(),
        inputDecorationTheme: _buildInputDecorationTheme(isLight: false),
        navigationBarTheme: _buildNavBarTheme(isLight: false),
      );

  // ── Helpers ────────────────────────────────────────────────────────────────

  static TextTheme _buildTextTheme(Color primary, Color secondary) => TextTheme(
        displayLarge: AppTextStyles.display.copyWith(color: primary),
        headlineMedium: AppTextStyles.heading.copyWith(color: primary),
        bodyMedium: AppTextStyles.body.copyWith(color: primary),
        bodySmall: AppTextStyles.caption.copyWith(color: secondary),
        labelLarge: AppTextStyles.button.copyWith(color: primary),
      );

  static AppBarTheme _buildAppBarTheme(Color bg, Color fg) => AppBarTheme(
        backgroundColor: bg,
        foregroundColor: fg,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: AppTextStyles.heading.copyWith(color: fg),
      );

  static ElevatedButtonThemeData _buildElevatedButtonTheme() => ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: AppTextStyles.button,
          elevation: 0,
        ),
      );

  static InputDecorationTheme _buildInputDecorationTheme({required bool isLight}) {
    final fillColor = isLight ? const Color(0xFFF3F4F6) : const Color(0xFF2A2A3E);
    final hintColor = isLight ? AppColors.textSecondaryLight : AppColors.textSecondaryDark;

    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      hintStyle: AppTextStyles.body.copyWith(color: hintColor),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  static NavigationBarThemeData _buildNavBarTheme({required bool isLight}) {
    final bg = isLight ? AppColors.cardLight : AppColors.cardDark;
    return NavigationBarThemeData(
      backgroundColor: bg,
      indicatorColor: AppColors.primary.withOpacity(0.15),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: AppColors.primary, size: 24);
        }
        return IconThemeData(
          color: isLight ? AppColors.textSecondaryLight : AppColors.textSecondaryDark,
          size: 24,
        );
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final style = AppTextStyles.caption;
        if (states.contains(WidgetState.selected)) {
          return style.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600);
        }
        return style.copyWith(
          color: isLight ? AppColors.textSecondaryLight : AppColors.textSecondaryDark,
        );
      }),
    );
  }
}
