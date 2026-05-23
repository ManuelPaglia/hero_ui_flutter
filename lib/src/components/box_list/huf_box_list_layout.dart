/// Layout visivo di [HUFBoxList] e degli item basati su [HUFBoxItem].
enum HUFBoxListLayout {
  /// Ogni item è un blocco distinto con spaziatura e radius su tutti gli angoli.
  separated,

  /// Gli item sono uniti in un unico blocco (come [HUFAccordion] variant card).
  united,
}
