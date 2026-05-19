import 'package:flutter/material.dart';

import '../../theme/huf_theme.dart';
import 'huf_radio_button_size.dart';
import 'huf_radio_button_style.dart';

/// Radio button circolare del design system Hero UI Flutter.
///
/// A differenza di [HUFCheckbox], non usa [HUFBorderRadius] del tema:
/// la forma è sempre un cerchio.
///
/// Uso singolo: passa [value] e [onChanged].
///
/// Uso in [HUFRadioButtonGroup]: passa solo [optionValue] (e label, stile);
/// il gruppo fornisce [value] e [onChanged].
///
/// Comportamento uguale per tutti i preset ([HUFThemePreset]):
/// selezionato → sfondo [HUFThemeColors.card], anello spesso [HUFThemeColors.primary] + glow,
/// pallino [HUFThemeColors.primaryForeground] sempre visibile;
/// non selezionato → disco card + bordo [HUFThemeColors.border], senza glow.
///
/// Per override puntuali passa [activeColor], [dotColor] o [borderColor].
class HUFRadioButton extends StatelessWidget {
  const HUFRadioButton({
    super.key,
    this.value,
    this.onChanged,
    this.optionValue,
    this.enabled = true,
    this.size = HUFRadioButtonSize.medium,
    this.glowSize,
    this.label,
    this.activeColor,
    this.dotColor,
    this.borderColor,
  }) : assert(
          optionValue == null || (value == null && onChanged == null),
          'Con optionValue il radio è gestito da HUFRadioButtonGroup: '
          'non passare value né onChanged.',
        );

  /// Collegamento interno da [HUFRadioButtonGroup] (non usare direttamente).
  const HUFRadioButton.wired({
    super.key,
    required this.value,
    required this.onChanged,
    this.optionValue,
    this.enabled = true,
    this.size = HUFRadioButtonSize.medium,
    this.glowSize,
    this.label,
    this.activeColor,
    this.dotColor,
    this.borderColor,
  });

  /// Stato selezionato (uso singolo).
  final bool? value;

  /// Callback al tap (uso singolo). `null` disabilita il controllo.
  final ValueChanged<bool>? onChanged;

  /// Identificativo dell'opzione quando il widget è figlio di [HUFRadioButtonGroup].
  final Object? optionValue;

  /// Se `false`, il radio non risponde al tap.
  final bool enabled;

  final HUFRadioButtonSize size;

  /// Override dell'intensità glow; se null usa [HUFTheme.glowSize].
  final HUFGlowSize? glowSize;

  final String? label;

  /// Bordo e glow quando selezionato. Default: [HUFThemeColors.primary].
  final Color? activeColor;

  /// Pallino interno. Default: [HUFThemeColors.primaryForeground] (come thumb ON).
  final Color? dotColor;

  /// Override del bordo (selezionato o meno a seconda dello stato).
  final Color? borderColor;

  bool get _isDisabled => !enabled || onChanged == null;

  /// Copia il radio con [value] e [onChanged] aggiornati ([HUFRadioButtonGroup]).
  HUFRadioButton copyWith({
    bool? value,
    ValueChanged<bool>? onChanged,
    bool? enabled,
  }) {
    return HUFRadioButton.wired(
      key: key,
      value: value ?? this.value ?? false,
      onChanged: onChanged ?? this.onChanged,
      optionValue: optionValue,
      enabled: enabled ?? this.enabled,
      size: size,
      glowSize: glowSize,
      label: label,
      activeColor: activeColor,
      dotColor: dotColor,
      borderColor: borderColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(
      optionValue != null || value != null,
      'HUFRadioButton richiede value (uso singolo) o optionValue (uso in gruppo).',
    );

    final theme = context.hufTheme;
    final resolvedGlowSize = glowSize ?? theme.glowSize;
    final metrics = hufRadioButtonMetricsFor(size);
    final glowLayoutPadding = hufGlowLayoutPaddingFor(resolvedGlowSize);
    final isSelected = value ?? false;
    final colors = hufRadioButtonColorsFor(
      theme.colors,
      isSelected,
      _isDisabled,
      glowSize: resolvedGlowSize,
      activeColor: activeColor,
      dotColor: dotColor,
      borderColor: borderColor,
    );

    final splashColor = (isSelected ? (activeColor ?? theme.colors.primary) : theme.colors.border)
        .withValues(alpha: 0.12);
    final highlightColor = (isSelected ? (activeColor ?? theme.colors.primary) : theme.colors.border)
        .withValues(alpha: 0.08);

    final control = Padding(
      padding: glowLayoutPadding,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        width: metrics.size,
        height: metrics.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colors.backgroundColor,
          border: Border.all(
            color: colors.borderColor,
            width: isSelected ? metrics.selectedBorderWidth : metrics.borderWidth,
          ),
          boxShadow: colors.boxShadow,
        ),
        child: isSelected
            ? Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeOut,
                  width: metrics.dotSize,
                  height: metrics.dotSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.dotColor,
                  ),
                ),
              )
            : null,
      ),
    );

    final Widget content;
    if (label == null) {
      content = control;
    } else {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          control,
          SizedBox(width: metrics.labelGap),
          Text(
            label!,
            style: TextStyle(
              fontSize: _labelFontSize(size),
              fontWeight: FontWeight.w500,
              color: _isDisabled
                  ? theme.colors.disabled
                  : theme.colors.secondaryForeground,
              height: 1.3,
            ),
          ),
        ],
      );
    }

    return Semantics(
      checked: isSelected,
      enabled: !_isDisabled,
      button: true,
      label: label,
      child: Material(
        color: theme.colors.transparent,
        child: InkWell(
          onTap: _isDisabled || isSelected ? null : () => onChanged!(true),
          customBorder: label == null ? const CircleBorder() : null,
          splashColor: splashColor,
          highlightColor: highlightColor,
          child: content,
        ),
      ),
    );
  }

  double _labelFontSize(HUFRadioButtonSize size) {
    return switch (size) {
      HUFRadioButtonSize.small => 13,
      HUFRadioButtonSize.medium => 15,
      HUFRadioButtonSize.large => 16,
    };
  }
}
