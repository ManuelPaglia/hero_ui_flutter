/// Temi colore predefiniti allineati a HeroUI (`@heroui/styles`).
enum HUFThemePreset {
  /// Tema design system predefinito del package.
  defaultTheme,

  sky,
  lavender,
  mint,
  netflix,
  uber,
  spotify,
  coinbase,
  airbnb,
  discord,
  rabbit,
}

/// Etichetta leggibile per UI e debug.
extension HUFThemePresetLabel on HUFThemePreset {
  String get label => switch (this) {
        HUFThemePreset.defaultTheme => 'Default',
        HUFThemePreset.sky => 'Sky',
        HUFThemePreset.lavender => 'Lavender',
        HUFThemePreset.mint => 'Mint',
        HUFThemePreset.netflix => 'Netflix',
        HUFThemePreset.uber => 'Uber',
        HUFThemePreset.spotify => 'Spotify',
        HUFThemePreset.coinbase => 'Coinbase',
        HUFThemePreset.airbnb => 'Airbnb',
        HUFThemePreset.discord => 'Discord',
        HUFThemePreset.rabbit => 'Rabbit',
      };
}
