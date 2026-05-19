import 'package:flutter/material.dart';

/// Token colore semantici del design system Hero UI Flutter.
///
/// Allineati al tema predefinito HeroUI (`@heroui/styles`):
/// accent → [primary], default → [secondary], surface → [card], muted → [cardMutedForeground].
@immutable
class HUFThemeColors {
  const HUFThemeColors({
    required this.background,
    required this.border,
    required this.primary,
    required this.primaryForeground,
    required this.secondary,
    required this.secondaryForeground,
    required this.danger,
    required this.dangerForeground,
    required this.dangerSoft,
    required this.dangerSoftForeground,
    required this.success,
    required this.successForeground,
    required this.warning,
    required this.warningForeground,
    required this.disabled,
    required this.disabledForeground,
    required this.transparent,
    required this.card,
    required this.cardSecondary,
    required this.cardTertiary,
    required this.cardForeground,
    required this.cardMutedForeground,
  });

  /// Sfondo pagina / layout (`--background`).
  final Color background;

  /// Bordo neutro (`--border`).
  final Color border;

  final Color primary;
  final Color primaryForeground;
  final Color secondary;
  final Color secondaryForeground;
  final Color danger;
  final Color dangerForeground;
  final Color dangerSoft;
  final Color dangerSoftForeground;
  final Color success;
  final Color successForeground;
  final Color warning;
  final Color warningForeground;
  final Color disabled;
  final Color disabledForeground;
  final Color transparent;

  /// Sfondo card predefinito.
  final Color card;

  /// Sfondo card secondario (più tenue).
  final Color cardSecondary;

  /// Sfondo card terziario (ancora più tenue).
  final Color cardTertiary;

  /// Testo principale su card.
  final Color cardForeground;

  /// Testo secondario / sottotitolo su card.
  final Color cardMutedForeground;

  static const HUFThemeColors light = HUFThemeColors(
    background: Color(0xFFF4F5F6),
    border: Color(0xFFDDDEDF),
    primary: Color(0xFF0485F7),
    primaryForeground: Color(0xFFFCFCFC),
    secondary: Color(0xFFEAEBEC),
    secondaryForeground: Color(0xFF17191B),
    danger: Color(0xFFFF373C),
    dangerForeground: Color(0xFFFCFCFC),
    dangerSoft: Color(0xFFFFEBEC),
    dangerSoftForeground: Color(0xFFC2000C),
    success: Color(0xFF15C964),
    successForeground: Color(0xFF161917),
    warning: Color(0xFFF5A523),
    warningForeground: Color(0xFF1A1815),
    disabled: Color(0xFFEAEBEC),
    disabledForeground: Color(0xFF717274),
    transparent: Colors.transparent,
    card: Color(0xFFFFFFFF),
    cardSecondary: Color(0xFFEFEFF0),
    cardTertiary: Color(0xFFEAEAEB),
    cardForeground: Color(0xFF17191B),
    cardMutedForeground: Color(0xFF717274),
  );

  static const HUFThemeColors dark = HUFThemeColors(
    background: Color(0xFF050606),
    border: Color(0xFF28292A),
    primary: Color(0xFF0485F7),
    primaryForeground: Color(0xFFFCFCFC),
    secondary: Color(0xFF272728),
    secondaryForeground: Color(0xFFFCFCFC),
    danger: Color(0xFFDB3B3E),
    dangerForeground: Color(0xFFFCFCFC),
    dangerSoft: Color(0xFF3E1F21),
    dangerSoftForeground: Color(0xFFFF8A8D),
    success: Color(0xFF15C964),
    successForeground: Color(0xFF161917),
    warning: Color(0xFFF7B750),
    warningForeground: Color(0xFF1A1815),
    disabled: Color(0xFF272728),
    disabledForeground: Color(0xFF9FA0A2),
    transparent: Colors.transparent,
    card: Color(0xFF17181A),
    cardSecondary: Color(0xFF222324),
    cardTertiary: Color(0xFF262728),
    cardForeground: Color(0xFFFCFCFC),
    cardMutedForeground: Color(0xFF9FA0A2),
  );

  HUFThemeColors copyWith({
    Color? background,
    Color? border,
    Color? primary,
    Color? primaryForeground,
    Color? secondary,
    Color? secondaryForeground,
    Color? danger,
    Color? dangerForeground,
    Color? dangerSoft,
    Color? dangerSoftForeground,
    Color? success,
    Color? successForeground,
    Color? warning,
    Color? warningForeground,
    Color? disabled,
    Color? disabledForeground,
    Color? transparent,
    Color? card,
    Color? cardSecondary,
    Color? cardTertiary,
    Color? cardForeground,
    Color? cardMutedForeground,
  }) {
    return HUFThemeColors(
      background: background ?? this.background,
      border: border ?? this.border,
      primary: primary ?? this.primary,
      primaryForeground: primaryForeground ?? this.primaryForeground,
      secondary: secondary ?? this.secondary,
      secondaryForeground: secondaryForeground ?? this.secondaryForeground,
      danger: danger ?? this.danger,
      dangerForeground: dangerForeground ?? this.dangerForeground,
      dangerSoft: dangerSoft ?? this.dangerSoft,
      dangerSoftForeground: dangerSoftForeground ?? this.dangerSoftForeground,
      success: success ?? this.success,
      successForeground: successForeground ?? this.successForeground,
      warning: warning ?? this.warning,
      warningForeground: warningForeground ?? this.warningForeground,
      disabled: disabled ?? this.disabled,
      disabledForeground: disabledForeground ?? this.disabledForeground,
      transparent: transparent ?? this.transparent,
      card: card ?? this.card,
      cardSecondary: cardSecondary ?? this.cardSecondary,
      cardTertiary: cardTertiary ?? this.cardTertiary,
      cardForeground: cardForeground ?? this.cardForeground,
      cardMutedForeground: cardMutedForeground ?? this.cardMutedForeground,
    );
  }

  HUFThemeColors lerp(HUFThemeColors other, double t) {
    return HUFThemeColors(
      background: Color.lerp(background, other.background, t)!,
      border: Color.lerp(border, other.border, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryForeground: Color.lerp(primaryForeground, other.primaryForeground, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      secondaryForeground: Color.lerp(secondaryForeground, other.secondaryForeground, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      dangerForeground: Color.lerp(dangerForeground, other.dangerForeground, t)!,
      dangerSoft: Color.lerp(dangerSoft, other.dangerSoft, t)!,
      dangerSoftForeground: Color.lerp(dangerSoftForeground, other.dangerSoftForeground, t)!,
      success: Color.lerp(success, other.success, t)!,
      successForeground: Color.lerp(successForeground, other.successForeground, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningForeground: Color.lerp(warningForeground, other.warningForeground, t)!,
      disabled: Color.lerp(disabled, other.disabled, t)!,
      disabledForeground: Color.lerp(disabledForeground, other.disabledForeground, t)!,
      transparent: Color.lerp(transparent, other.transparent, t)!,
      card: Color.lerp(card, other.card, t)!,
      cardSecondary: Color.lerp(cardSecondary, other.cardSecondary, t)!,
      cardTertiary: Color.lerp(cardTertiary, other.cardTertiary, t)!,
      cardForeground: Color.lerp(cardForeground, other.cardForeground, t)!,
      cardMutedForeground:
          Color.lerp(cardMutedForeground, other.cardMutedForeground, t)!,
    );
  }
}
