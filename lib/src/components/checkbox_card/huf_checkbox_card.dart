import 'package:flutter/material.dart';

import '../../theme/huf_theme.dart';
import '../checkbox/huf_checkbox_size.dart';
import 'huf_checkbox_card_style.dart';

/// Card cliccabile con checkbox circolare, titolo e sottotitolo opzionale.
///
/// Uso singolo: passa [value] e [onChanged].
///
/// Uso in [HUFCheckboxCardGroup]: passa solo [optionValue] (e titolo, icone, stile);
/// il gruppo fornisce [value] e [onChanged].
class HUFCheckboxCard extends StatelessWidget {
  const HUFCheckboxCard({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.value,
    this.onChanged,
    this.optionValue,
    this.enabled = true,
    this.size = HUFCheckboxSize.medium,
    this.checkedIcon,
    this.uncheckedIcon,
    this.activeColor,
    this.checkColor,
    this.borderColor,
  }) : assert(
          optionValue == null || (value == null && onChanged == null),
          'Con optionValue la card è gestita da HUFCheckboxCardGroup: '
          'non passare value né onChanged.',
        );

  /// Collegamento interno da [HUFCheckboxCardGroup] (non usare direttamente).
  const HUFCheckboxCard.wired({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.icon,
    this.optionValue,
    this.enabled = true,
    this.size = HUFCheckboxSize.medium,
    this.checkedIcon,
    this.uncheckedIcon,
    this.activeColor,
    this.checkColor,
    this.borderColor,
  });

  final String title;
  final String? subtitle;
  final Widget? icon;

  /// Stato selezionato (uso singolo).
  final bool? value;

  /// Callback al tap (uso singolo). `null` disabilita il controllo.
  final ValueChanged<bool>? onChanged;

  /// Identificativo dell'opzione quando il widget è figlio di [HUFCheckboxCardGroup].
  final Object? optionValue;

  /// Se `false`, la card non risponde al tap.
  final bool enabled;

  final HUFCheckboxSize size;

  /// Icona mostrata quando selezionato. Default: segno di spunta.
  final Widget? checkedIcon;

  /// Icona mostrata quando non selezionato. Se null l'indicatore resta vuoto.
  final Widget? uncheckedIcon;

  final Color? activeColor;
  final Color? checkColor;
  final Color? borderColor;

  bool get _isDisabled => !enabled || onChanged == null;

  /// Copia la card con [value] e [onChanged] aggiornati ([HUFCheckboxCardGroup]).
  HUFCheckboxCard copyWith({
    bool? value,
    ValueChanged<bool>? onChanged,
    bool? enabled,
  }) {
    return HUFCheckboxCard.wired(
      key: key,
      title: title,
      subtitle: subtitle,
      icon: icon,
      value: value ?? this.value ?? false,
      onChanged: onChanged ?? this.onChanged,
      optionValue: optionValue,
      enabled: enabled ?? this.enabled,
      size: size,
      checkedIcon: checkedIcon,
      uncheckedIcon: uncheckedIcon,
      activeColor: activeColor,
      checkColor: checkColor,
      borderColor: borderColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(
      optionValue != null || value != null,
      'HUFCheckboxCard richiede value (uso singolo) o optionValue (uso in gruppo).',
    );

    final theme = context.hufTheme;
    final metrics = hufCheckboxCardMetricsFor(size, theme.borderRadius);
    final isChecked = value ?? false;
    final colors = hufCheckboxCardColorsFor(
      theme.colors,
      isChecked,
      _isDisabled,
      activeColor: activeColor,
      checkColor: checkColor,
      borderColor: borderColor,
    );

    final cardBorderRadius = BorderRadius.circular(metrics.borderRadius);
    final splashColor = colors.leadingIconColor.withValues(alpha: 0.12);
    final highlightColor = colors.leadingIconColor.withValues(alpha: 0.08);

    return Semantics(
      checked: isChecked,
      enabled: !_isDisabled,
      button: true,
      label: subtitle == null ? title : '$title. $subtitle',
      child: Material(
        color: theme.colors.transparent,
        child: InkWell(
          onTap: _isDisabled ? null : () => onChanged!(!isChecked),
          borderRadius: cardBorderRadius,
          splashColor: splashColor,
          highlightColor: highlightColor,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            width: double.infinity,
            padding: metrics.padding,
            decoration: BoxDecoration(
              color: isChecked ? colors.activeBackground : colors.inactiveBackground,
              borderRadius: cardBorderRadius,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  IconTheme(
                    data: IconThemeData(
                      color: colors.leadingIconColor,
                      size: metrics.leadingIconSize,
                    ),
                    child: icon!,
                  ),
                  SizedBox(width: metrics.iconGap),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: metrics.titleFontSize,
                          fontWeight: FontWeight.w600,
                          color: colors.titleColor,
                          height: 1.3,
                        ),
                      ),
                      if (subtitle != null) ...[
                        SizedBox(height: metrics.titleSubtitleGap),
                        Text(
                          subtitle!,
                          style: TextStyle(
                            fontSize: metrics.subtitleFontSize,
                            fontWeight: FontWeight.w400,
                            color: colors.subtitleColor,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(width: metrics.indicatorGap),
                _buildIndicator(
                  isChecked: isChecked,
                  metrics: metrics,
                  colors: colors,
                  theme: theme,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIndicator({
    required bool isChecked,
    required HUFCheckboxCardMetrics metrics,
    required HUFCheckboxCardColors colors,
    required HUFTheme theme,
  }) {
    final Widget? iconWidget;
    final Color iconColor;

    if (isChecked) {
      iconWidget = checkedIcon ?? const Icon(Icons.check_rounded);
      iconColor = colors.indicatorCheckedIconColor;
    } else {
      iconWidget = uncheckedIcon;
      iconColor = _isDisabled
          ? theme.colors.disabled
          : colors.indicatorUncheckedBorder;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      width: metrics.indicatorSize,
      height: metrics.indicatorSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(metrics.indicatorBorderRadius),
        color: isChecked
            ? colors.indicatorCheckedBackground
            : colors.indicatorUncheckedBackground,
        border: Border.all(
          color: isChecked
              ? colors.indicatorCheckedBackground
              : colors.indicatorUncheckedBorder,
          width: 1.5,
        ),
      ),
      child: iconWidget == null
          ? null
          : Center(
              child: IconTheme(
                data: IconThemeData(
                  color: iconColor,
                  size: metrics.indicatorIconSize,
                ),
                child: iconWidget,
              ),
            ),
    );
  }
}
