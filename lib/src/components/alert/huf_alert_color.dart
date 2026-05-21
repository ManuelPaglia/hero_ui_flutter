/// Colore semantico di accento per [HUFAlert] (icona, titolo, azione).
///
/// Allineato ai token HeroUI: `default` → testo principale della card,
/// `accent` → [HUFThemeColors.primary], ecc.
enum HUFAlertColor {
  /// Accento neutro ([HUFThemeColors.cardForeground]).
  defaultColor,

  /// Accento primario del tema.
  accent,

  success,
  warning,
  danger,
}
