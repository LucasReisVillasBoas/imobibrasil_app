import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors_scheme.dart';

class AppColors {
  // Paleta principal
  static const primary = Color(0xFF1B7A43);
  static const primaryDark = Color(0xFF006030);
  static const secondary = Color(0xFF0067D8);
  static const background = Color(0xFFF9F9F9);
  static const surface = Color(0xFFF9F9F9);
  static const surfaceContainer = Color(0xFFEEEEEE);
  static const surfaceContainerLow = Color(0xFFF3F3F3);
  static const surfaceContainerHigh = Color(0xFFE8E8E8);
  static const surfaceContainerLowest = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF1A1C1C);
  static const textSecondary = Color(0xFF3F4940);
  static const outline = Color(0xFF6F7A6F);
  static const outlineVariant = Color(0xFFBECABD);
  static const white = Color(0xFFFFFFFF);
  static const error = Color(0xFFBA1A1A);

  // Gradiente bio-elétrico (verde → azul)
  static const bioElectricGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1B7A43), Color(0xFF0067D8)],
  );

  // Dark mode — Digital Biome
  static const darkBackground = Color(0xFF0A0A0A);
  static const darkSurface = Color(0xFF0E0E0E);
  static const darkSurfaceContainer = Color(0xFF1A1919);
  static const darkSurfaceContainerLow = Color(0xFF131313);
  static const darkSurfaceContainerHigh = Color(0xFF201F1F);
  static const darkSurfaceContainerHighest = Color(0xFF262626);
  static const darkSurfaceBright = Color(0xFF2C2C2C);
  static const darkTextPrimary = Color(0xFFF5F5F5);
  static const darkTextSecondary = Color(0xFF757575);
  static const darkOutline = Color(0xFF777575);
  static const darkOutlineVariant = Color(0xFF494847);

  // Dark mode primary / secondary
  static const darkPrimary = Color(0xFFA4FFBA);
  static const darkSecondary = Color(0xFF679DFF);
  static const darkOnPrimary = Color(0xFF006433);
  static const darkOnSecondary = Color(0xFF001F49);

  // Gradiente bio-elétrico dark
  static const bioElectricGradientDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1B7A43), Color(0xFF1A73E8)],
  );
}

class AppTheme {
  // ── LIGHT ──────────────────────────────────────────
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.surface,
          error: AppColors.error,
        ),
        scaffoldBackgroundColor: AppColors.background,
        textTheme: GoogleFonts.manropeTextTheme(),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white.withValues(alpha: 0.7),
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          titleTextStyle: GoogleFonts.spaceGrotesk(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
            textStyle: GoogleFonts.spaceGrotesk(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfaceContainerLow,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: AppColors.primary,
              width: 1.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.error),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
          labelStyle: GoogleFonts.manrope(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
          hintStyle: GoogleFonts.manrope(
            color: AppColors.outline,
            fontSize: 14,
          ),
        ),
        cardTheme: CardThemeData(
          color: AppColors.surfaceContainerLowest,
          elevation: 0,
          shadowColor: Colors.black.withValues(alpha: 0.04),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.surfaceContainerLow,
          selectedColor: AppColors.primary,
          labelStyle:
              GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w600),
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.textPrimary,
          contentTextStyle: GoogleFonts.manrope(color: Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        extensions: const [AppColorTokens.light],
      );

  // ── DARK ──────────────────────────────────────────
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.darkPrimary,
          onPrimary: AppColors.darkOnPrimary,
          secondary: AppColors.darkSecondary,
          onSecondary: AppColors.darkOnSecondary,
          surface: AppColors.darkSurface,
          onSurface: AppColors.darkTextPrimary,
          error: Color(0xFFFF716C),
          onError: Color(0xFF490006),
        ),
        scaffoldBackgroundColor: AppColors.darkBackground,
        textTheme: GoogleFonts.manropeTextTheme(
          ThemeData(brightness: Brightness.dark).textTheme,
        ).apply(
          bodyColor: AppColors.darkTextPrimary,
          displayColor: AppColors.darkTextPrimary,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor:
              AppColors.darkSurface.withValues(alpha: 0.60),
          foregroundColor: AppColors.darkTextPrimary,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          titleTextStyle: GoogleFonts.spaceGrotesk(
            color: AppColors.darkTextPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
            textStyle: GoogleFonts.spaceGrotesk(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.darkSurfaceContainerLow,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: AppColors.darkPrimary,
              width: 1.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFFF716C)),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
          labelStyle: GoogleFonts.manrope(
            color: AppColors.darkTextSecondary,
            fontSize: 14,
          ),
          hintStyle: GoogleFonts.manrope(
            color: AppColors.darkOutline,
            fontSize: 14,
          ),
        ),
        cardTheme: CardThemeData(
          color: AppColors.darkSurfaceContainer,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.darkSurfaceContainerHigh,
          selectedColor: AppColors.primary,
          labelStyle: GoogleFonts.manrope(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.darkSurfaceContainerHigh,
          contentTextStyle: GoogleFonts.manrope(
            color: AppColors.darkTextPrimary,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        extensions: const [AppColorTokens.dark],
      );
}

// Widget utilitário para botão com gradiente bio-elétrico
class GradientButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final double height;
  final double borderRadius;

  const GradientButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.height = 56,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: onPressed != null
            ? AppColors.bioElectricGradient
            : const LinearGradient(
                colors: [Colors.grey, Colors.grey],
              ),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: onPressed != null
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Center(child: child),
        ),
      ),
    );
  }
}

// Widget utilitário para card com glassmorphism (dark-mode adaptativo)
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double borderRadius;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = 20,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: colors.glassBackground,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: colors.glassBorder,
              width: 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
