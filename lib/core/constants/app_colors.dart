import 'package:flutter/material.dart';

/// Tokens de Design - Sistema de Cores PharmaIA
/// Baseado na identidade visual e princípios de acessibilidade WCAG 2.1 AA
class AppColors {
  // ============ PRIMARY PALETTE ============
  /// Cor primária - vermelho PharmaIA (CTAs, links, destaques)
  static const primary = Color(0xFFE51B23);
  static const primaryDark = Color(0xFFB71C1C);
  static const primaryLight = Color(0xFFFF5252);
  static const primarySoft = Color(0xFFFFEBEE);

  // ============ NEUTRALS ============
  /// Texto principal (títulos, conteúdo importante)
  static const dark = Color(0xFF243040);
  static const darkMuted = Color(0xFF374151);

  /// Texto secundário (descrições, labels)
  static const muted = Color(0xFF6B7280);
  static const mutedLight = Color(0xFF9CA3AF);

  // ============ BACKGROUNDS ============
  /// Gradiente suave para hero sections
  static const bgGradientStart = Color(0xFFF9EBEB);
  static const bgGradientEnd = Color(0xFFFFFFFF);

  /// Superfícies e cards
  static const surface = Color(0xFFFFFFFF);
  static const surfaceAlt = Color(0xFFF4F4F4);

  // ============ LEGACY COLORS (compatibilidade) ============
  static const backgroundPink = Color(0xFFFDEEEF);
  static const cardPink = Color(0xFFFBECEC);
  static const inputGray = Color(0xFFF6F6F6);
  static const headerPink = Color(0xFFFCECEC);
  static const deleteModalPink = Color(0xFFFFEBEB);

  // ============ STATUS COLORS ============
  /// Estados de cliente/sistema
  static const activeBackground = Color(0xFFDFF6E9);
  static const activeText = Color(0xFF19964F);
  static const inactiveBackground = Color(0xFFF1F2F5);
  static const inactiveText = Color(0xFF8D94A1);

  /// Feedback visual
  static const success = Color(0xFF10B981);
  static const successLight = Color(0xFFD1FAE5);
  static const warning = Color(0xFFF59E0B);
  static const warningLight = Color(0xFFFEF3C7);
  static const error = Color(0xFFEF4444);
  static const errorLight = Color(0xFFFEE2E2);
  static const info = Color(0xFF3B82F6);
  static const infoLight = Color(0xFFDEEAFF);

  // ============ SWITCH COLORS ============
  static const switchThumb = Color(0xFF2E2E2E);
  static const switchActiveTrack = Color(0xFFEFEFEF);
  static const switchInactiveTrack = Color(0xFFF1F1F1);

  // ============ UTILITIES ============
  static Color get dangerZoneBorder => Colors.red.shade100;
  static Color get dangerZoneText => Colors.red.shade700;

  /// Overlay para loading states
  static Color get overlay => Colors.black.withOpacity(0.5);

  /// Divider padrão
  static Color get divider => const Color(0xFFE5E7EB);

  /// Hover states
  static Color get hoverPrimary => primary.withOpacity(0.05);
  static Color get hoverDark => dark.withOpacity(0.05);
}

/// Espaçamentos padronizados (8pt grid system)
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;
  static const double xxxxl = 96.0;
}

/// Border radius padronizados
class AppRadius {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double full = 9999.0;
}

/// Elevações padronizadas (Material Design 3)
class AppElevation {
  static const double none = 0.0;
  static const double sm = 2.0;
  static const double md = 4.0;
  static const double lg = 8.0;
  static const double xl = 16.0;
}

/// Breakpoints responsivos
class AppBreakpoints {
  static const double mobile = 600;
  static const double tablet = 1024;
  static const double desktop = 1440;
  static const double wide = 1920;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width <= mobile;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width > mobile && width <= tablet;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width > tablet;

  static bool isWide(BuildContext context) =>
      MediaQuery.of(context).size.width > wide;
}
