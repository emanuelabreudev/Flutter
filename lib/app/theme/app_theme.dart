import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';

/// Theme principal da aplicação PharmaIA
/// Implementa Material Design 3 com identidade visual customizada
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,

      // ============ COLOR SCHEME ============
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.dark,
        onSecondary: Colors.white,
        surface: AppColors.surface,
        onSurface: AppColors.dark,
        background: AppColors.bgGradientEnd,
        onBackground: AppColors.dark,
        error: AppColors.error,
        onError: Colors.white,
        brightness: Brightness.light,
      ),

      scaffoldBackgroundColor: AppColors.backgroundPink,
      dividerColor: AppColors.divider,

      // ============ TYPOGRAPHY ============
      textTheme: _buildTextTheme(),

      // ============ BUTTON THEMES ============
      elevatedButtonTheme: _buildElevatedButtonTheme(),
      outlinedButtonTheme: _buildOutlinedButtonTheme(),
      textButtonTheme: _buildTextButtonTheme(),
      iconButtonTheme: _buildIconButtonTheme(),

      // ============ INPUT DECORATION ============
      inputDecorationTheme: _buildInputDecorationTheme(),

      // ============ CARD THEME ============
      cardTheme: ThemeData.light().cardTheme.copyWith(
        elevation: AppElevation.sm,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        color: AppColors.surface,
        margin: EdgeInsets.zero,
      ),

      // ============ APP BAR ============
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.dark,
        centerTitle: false,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.dark,
        ),
        iconTheme: const IconThemeData(color: AppColors.dark),
      ),

      // ============ DIALOG THEME ============
      dialogTheme: DialogThemeData(
        elevation: AppElevation.xl,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        backgroundColor: AppColors.surface,
      ),

      // ============ BOTTOM SHEET ============
      bottomSheetTheme: BottomSheetThemeData(
        elevation: AppElevation.lg,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl),
          ),
        ),
        backgroundColor: AppColors.surface,
      ),

      // ============ CHIP THEME ============
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceAlt,
        selectedColor: AppColors.primary.withOpacity(0.1),
        disabledColor: AppColors.mutedLight.withOpacity(0.3),
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
      ),

      // ============ DIVIDER THEME ============
      dividerTheme: DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: AppSpacing.lg,
      ),

      // ============ PROGRESS INDICATOR ============
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        circularTrackColor: AppColors.surfaceAlt,
      ),

      // ============ SNACKBAR ============
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.dark,
        contentTextStyle: GoogleFonts.inter(fontSize: 14, color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ============ TEXT THEME ============
  static TextTheme _buildTextTheme() {
    return TextTheme(
      // Display (Hero sections, landing)
      displayLarge: GoogleFonts.poppins(
        fontSize: 56,
        fontWeight: FontWeight.w800,
        color: AppColors.dark,
        height: 1.1,
        letterSpacing: -1.5,
      ),
      displayMedium: GoogleFonts.poppins(
        fontSize: 48,
        fontWeight: FontWeight.w700,
        color: AppColors.dark,
        height: 1.2,
        letterSpacing: -1.0,
      ),
      displaySmall: GoogleFonts.poppins(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        color: AppColors.dark,
        height: 1.2,
        letterSpacing: -0.5,
      ),

      // Headlines (Page titles, section headers)
      headlineLarge: GoogleFonts.poppins(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        color: AppColors.dark,
        height: 1.3,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: AppColors.dark,
        height: 1.3,
      ),
      headlineSmall: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.dark,
        height: 1.4,
      ),

      // Titles (Card headers, modal titles)
      titleLarge: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.dark,
        height: 1.4,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.dark,
        height: 1.4,
      ),
      titleSmall: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.dark,
        height: 1.4,
      ),

      // Body (Paragraphs, descriptions)
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.muted,
        height: 1.6,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.muted,
        height: 1.6,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.mutedLight,
        height: 1.5,
      ),

      // Labels (Buttons, tabs, badges)
      labelLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
        height: 1.4,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
        height: 1.4,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.muted,
        height: 1.4,
      ),
    );
  }

  // ============ ELEVATED BUTTON ============
  static ElevatedButtonThemeData _buildElevatedButtonTheme() {
    return ElevatedButtonThemeData(
      style:
          ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: AppElevation.none,
            shadowColor: AppColors.primary.withOpacity(0.3),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            textStyle: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
            minimumSize: const Size(0, 48),
          ).copyWith(
            elevation: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.hovered)) {
                return AppElevation.md;
              }
              if (states.contains(WidgetState.pressed)) {
                return AppElevation.sm;
              }
              return AppElevation.none;
            }),
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return AppColors.mutedLight;
              }
              if (states.contains(WidgetState.hovered)) {
                return AppColors.primaryDark;
              }
              if (states.contains(WidgetState.pressed)) {
                return AppColors.primaryDark;
              }
              return AppColors.primary;
            }),
          ),
    );
  }

  // ============ OUTLINED BUTTON ============
  static OutlinedButtonThemeData _buildOutlinedButtonTheme() {
    return OutlinedButtonThemeData(
      style:
          OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary, width: 2),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            textStyle: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
            minimumSize: const Size(0, 48),
          ).copyWith(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.hovered)) {
                return AppColors.primary.withOpacity(0.05);
              }
              return Colors.transparent;
            }),
            foregroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return AppColors.mutedLight;
              }
              return AppColors.primary;
            }),
          ),
    );
  }

  // ============ TEXT BUTTON ============
  static TextButtonThemeData _buildTextButtonTheme() {
    return TextButtonThemeData(
      style:
          TextButton.styleFrom(
            foregroundColor: AppColors.dark,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            textStyle: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
            minimumSize: const Size(0, 40),
          ).copyWith(
            foregroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return AppColors.mutedLight;
              }
              if (states.contains(WidgetState.hovered)) {
                return AppColors.primary;
              }
              return AppColors.dark;
            }),
            overlayColor: WidgetStateProperty.all(
              AppColors.primary.withOpacity(0.05),
            ),
          ),
    );
  }

  // ============ ICON BUTTON ============
  static IconButtonThemeData _buildIconButtonTheme() {
    return IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: AppColors.dark,
        highlightColor: AppColors.primary.withOpacity(0.1),
        hoverColor: AppColors.primary.withOpacity(0.05),
      ),
    );
  }

  // ============ INPUT DECORATION ============
  static InputDecorationTheme _buildInputDecorationTheme() {
    return InputDecorationTheme(
      filled: true,
      fillColor: AppColors.inputGray,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      hintStyle: GoogleFonts.inter(
        fontSize: 15,
        color: AppColors.mutedLight,
        fontWeight: FontWeight.w400,
      ),
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        color: AppColors.muted,
        fontWeight: FontWeight.w500,
      ),
      errorStyle: GoogleFonts.inter(fontSize: 12, color: AppColors.error),
    );
  }
}
