import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds
  static const backgroundPink = Color(0xFFFDEEEF);
  static const cardPink = Color(0xFFFBECEC);
  static const inputGray = Color(0xFFF6F6F6);
  static const headerPink = Color(0xFFFCECEC);
  static const deleteModalPink = Color(0xFFFFEBEB);

  // Status colors
  static const activeBackground = Color(0xFFDFF6E9);
  static const activeText = Color(0xFF19964F);
  static const inactiveBackground = Color(0xFFF1F2F5);
  static const inactiveText = Color(0xFF8D94A1);

  // Switch colors
  static const switchThumb = Color(0xFF2E2E2E);
  static const switchActiveTrack = Color(0xFFEFEFEF);
  static const switchInactiveTrack = Color(0xFFF1F1F1);

  // Utilities
  static Color get dangerZoneBorder => Colors.red.shade100;
  static Color get dangerZoneText => Colors.red.shade700;
}
