import 'package:flutter/material.dart';

import '../../theme/huf_theme.dart';
import 'huf_switch_size.dart';
import 'huf_switch_style.dart';

/// Switch a pill del design system Hero UI Flutter.
///
/// Uso singolo: passa [value] e [onChanged].
///
/// Uso in [HUFSwitchGroup]: passa solo [optionValue] (e opzionalmente icona,
/// colori, stile);
/// il gruppo fornisce [value] e [onChanged].
///
/// [activeColor] usa [HUFThemeColors.primary] di default; glow solo quando attivo.
class HUFSwitch extends StatelessWidget {
  const HUFSwitch({
    super.key,
    this.value,
    this.onChanged,
    this.optionValue,
    this.enabled = true,
    this.size = HUFSwitchSize.medium,
    this.glowSize,
    this.label,
    this.icon,
    this.activeColor,
    this.thumbColor,
    this.inactiveTrackColor,
    this.iconColor,
  }) : assert(
          optionValue == null || (value == null && onChanged == null),
          'Con optionValue lo switch è gestito da HUFSwitchGroup: '
          'non passare value né onChanged.',
        );

  /// Collegamento interno da [HUFSwitchGroup] (non usare direttamente).
  const HUFSwitch.wired({
    super.key,
    required this.value,
    required this.onChanged,
    this.optionValue,
    this.enabled = true,
    this.size = HUFSwitchSize.medium,
    this.glowSize,
    this.label,
    this.icon,
    this.activeColor,
    this.thumbColor,
    this.inactiveTrackColor,
    this.iconColor,
  });

  /// Stato attivo (uso singolo).
  final bool? value;

  /// Callback al tap (uso singolo). `null` disabilita il controllo.
  final ValueChanged<bool>? onChanged;

  /// Identificativo quando il widget è figlio di [HUFSwitchGroup].
  final Object? optionValue;

  /// Se `false`, lo switch non risponde al tap.
  final bool enabled;

  final HUFSwitchSize size;

  /// Override dell'intensità glow; se null usa [HUFTheme.glowSize].
  final HUFGlowSize? glowSize;

  final String? label;

  /// Icona nel thumb (opzionale).
  final Widget? icon;

  /// Colore del track quando attivo. Default: [HUFThemeColors.primary].
  final Color? activeColor;

  /// Colore del thumb. Default: bianco.
  final Color? thumbColor;

  /// Colore del track quando spento. Default: [HUFThemeColors.secondary].
  final Color? inactiveTrackColor;

  /// Colore dell'icona; se null usa [activeColor] quando attivo.
  final Color? iconColor;

  bool get _isDisabled => !enabled || onChanged == null;

  /// Copia lo switch con [value] e [onChanged] aggiornati ([HUFSwitchGroup]).
  HUFSwitch copyWith({
    bool? value,
    ValueChanged<bool>? onChanged,
    bool? enabled,
  }) {
    return HUFSwitch.wired(
      key: key,
      value: value ?? this.value ?? false,
      onChanged: onChanged ?? this.onChanged,
      optionValue: optionValue,
      enabled: enabled ?? this.enabled,
      size: size,
      glowSize: glowSize,
      label: label,
      icon: icon,
      activeColor: activeColor,
      thumbColor: thumbColor,
      inactiveTrackColor: inactiveTrackColor,
      iconColor: iconColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(
      optionValue != null || value != null,
      'HUFSwitch richiede value (uso singolo) o optionValue (uso in gruppo).',
    );

    final theme = context.hufTheme;
    final resolvedGlowSize = glowSize ?? theme.glowSize;
    final metrics = hufSwitchMetricsFor(size, theme.borderRadius);
    final trackRadius = hufSwitchTrackRadius(metrics);
    final thumbRadius = hufSwitchThumbRadius(metrics);
    final glowLayoutPadding = hufGlowLayoutPaddingFor(resolvedGlowSize);
    final isOn = value ?? false;
    final colors = hufSwitchColorsFor(
      theme.colors,
      isOn,
      _isDisabled,
      glowSize: resolvedGlowSize,
      activeColor: activeColor,
      thumbColor: thumbColor,
      inactiveTrackColor: inactiveTrackColor,
      iconColor: iconColor,
    );

    final splashColor = (activeColor ?? theme.colors.primary).withValues(alpha: 0.12);
    final highlightColor = (activeColor ?? theme.colors.primary).withValues(alpha: 0.08);

    final control = Padding(
      padding: glowLayoutPadding,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        width: metrics.trackWidth,
        height: metrics.trackHeight,
        decoration: BoxDecoration(
          color: colors.trackColor,
          borderRadius: BorderRadius.circular(trackRadius),
          boxShadow: colors.boxShadow,
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: metrics.thumbWidth,
            height: metrics.thumbHeight,
            margin: EdgeInsets.all(metrics.thumbInset),
            decoration: BoxDecoration(
              color: colors.thumbColor,
              borderRadius: BorderRadius.circular(thumbRadius),
            ),
            child: icon == null
                ? null
                : Center(
                    child: IconTheme(
                      data: IconThemeData(
                        color: colors.iconColor,
                        size: metrics.iconSize,
                      ),
                      child: icon!,
                    ),
                  ),
          ),
        ),
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
      toggled: isOn,
      enabled: !_isDisabled,
      label: label,
      child: Material(
        color: theme.colors.transparent,
        child: InkWell(
          onTap: _isDisabled ? null : () => onChanged!(!isOn),
          borderRadius: BorderRadius.circular(trackRadius + 4),
          splashColor: splashColor,
          highlightColor: highlightColor,
          child: content,
        ),
      ),
    );
  }

  double _labelFontSize(HUFSwitchSize size) {
    return switch (size) {
      HUFSwitchSize.small => 13,
      HUFSwitchSize.medium => 15,
      HUFSwitchSize.large => 16,
    };
  }
}
