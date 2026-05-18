import 'package:flutter/material.dart';
import 'package:hero_ui_flutter/hero_ui_flutter.dart';

/// Tema brand di esempio: estendi [HUFThemeData] per sovrascrivere l'intero design system.
class AppBrandTheme extends HUFThemeData {
  AppBrandTheme()
      : super(
          light: HUFThemePalette(
            colors: HUFThemeColors(
              primary: Color(0xFF7C3AED),
              primaryForeground: Color(0xFFFFFFFF),
              secondary: Color(0xFFEDE9FE),
              secondaryForeground: Color(0xFF4C1D95),
              danger: Color(0xFFDC2626),
              dangerForeground: Color(0xFFFFFFFF),
              dangerSoft: Color(0xFFFEE2E2),
              dangerSoftForeground: Color(0xFFB91C1C),
              disabled: Color(0xFF94A3B8),
              disabledForeground: Color(0xFFFFFFFF),
              transparent: Color(0x00000000),
            ),
          ),
          dark: HUFThemePalette(
            colors: HUFThemeColors(
              primary: Color(0xFFA78BFA),
              primaryForeground: Color(0xFF1E1B4B),
              secondary: Color(0xFF4C1D95),
              secondaryForeground: Color(0xFFEDE9FE),
              danger: Color(0xFFF87171),
              dangerForeground: Color(0xFF1E1B4B),
              dangerSoft: Color(0xFF450A0A),
              dangerSoftForeground: Color(0xFFFECACA),
              disabled: Color(0xFF64748B),
              disabledForeground: Color(0xFFCBD5E1),
              transparent: Color(0x00000000),
            ),
          ),
          borderRadius: HUFBorderRadius.pill,
        );
}
