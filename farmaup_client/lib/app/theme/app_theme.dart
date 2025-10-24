import 'package:flutter/material.dart';

class AppColors {
  static const primaryAction = Color(0xFFE60012); // botão principal (vermelho vibrante)
  static const pageBackground = Color(0xFFFDEEEF); // fundo da página
  static const cardPink = Color(0xFFFBECEC);
  static const inputFill = Color(0xFFF6F6F6);

  // Switch (seguir imagem: track escura, thumb branca)
  static const switchTrack = Color(0xFF0F1724);
  static const switchThumb = Colors.white;
}

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    primaryColor: AppColors.primaryAction,
    scaffoldBackgroundColor: AppColors.pageBackground,
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.black87,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.black87,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryAction,
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all(AppColors.switchThumb),
      trackColor: MaterialStateProperty.resolveWith<Color?>(
        (states) => AppColors.switchTrack.withOpacity(0.95),
      ),
      // tamanho e splash não alterados aqui
    ),
    iconTheme: const IconThemeData(color: Colors.black54),
  );
}
