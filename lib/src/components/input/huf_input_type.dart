/// Tipo di campo per [HUFInput].
enum HUFInputType {
  /// Testo generico.
  text,

  /// Indirizzo email (solo caratteri validi per email).
  email,

  /// Password mascherata con toggle visibilità.
  password,

  /// Codice OTP/PIN a celle separate.
  otp,

  /// Telefono con prefisso fisso e sole cifre.
  tel,
}
