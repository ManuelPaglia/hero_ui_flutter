import 'package:flutter/material.dart';

import '../../theme/huf_theme.dart';
import '../box_item/huf_box_item.dart';
import '../box_item/huf_box_item_style.dart';
import '../checkbox/huf_checkbox_size.dart';
import 'huf_checkbox_card_style.dart';

/// Card cliccabile con checkbox circolare, titolo e sottotitolo opzionale.
///
/// Costruita su [HUFBoxItem]. Uso singolo: passa [value] e [onChanged].
///
/// Uso in [HUFCheckboxCardGroup]: passa solo [optionValue]; il gruppo usa
/// [HUFBoxList] e fornisce [value] e [onChanged].
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
  final bool? value;
  final ValueChanged<bool>? onChanged;
  final Object? optionValue;
  final bool enabled;
  final HUFCheckboxSize size;
  final Widget? checkedIcon;
  final Widget? uncheckedIcon;
  final Color? activeColor;
  final Color? checkColor;
  final Color? borderColor;

  bool get _isDisabled => !enabled || onChanged == null;

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
    final isChecked = value ?? false;
    final boxSize = hufBoxItemSizeFromCheckbox(size);
    final boxColors = hufBoxItemColorsFor(
      theme.colors,
      isChecked,
      _isDisabled,
      activeColor: activeColor,
    );
    final indicatorMetrics =
        hufCheckboxCardIndicatorMetricsFor(size, theme.borderRadius);
    final indicatorColors = hufCheckboxCardIndicatorColorsFor(
      theme.colors,
      isChecked,
      _isDisabled,
      activeColor: activeColor,
      checkColor: checkColor,
      borderColor: borderColor,
    );

    return HUFBoxItem(
      title: title,
      subtitle: subtitle,
      icon: icon,
      enabled: enabled,
      highlighted: isChecked,
      size: boxSize,
      colors: boxColors,
      activeColor: activeColor,
      onTap: _isDisabled ? null : () => onChanged!(!isChecked),
      semanticsChecked: isChecked,
      action: _buildIndicator(
        isChecked: isChecked,
        metrics: indicatorMetrics,
        colors: indicatorColors,
        theme: theme,
      ),
    );
  }

  Widget _buildIndicator({
    required bool isChecked,
    required HUFCheckboxCardIndicatorMetrics metrics,
    required HUFCheckboxCardIndicatorColors colors,
    required HUFTheme theme,
  }) {
    final Widget? iconWidget;
    final Color iconColor;

    if (isChecked) {
      iconWidget = checkedIcon ?? const Icon(Icons.check_rounded);
      iconColor = colors.checkedIconColor;
    } else {
      iconWidget = uncheckedIcon;
      iconColor = _isDisabled
          ? theme.colors.disabled
          : colors.uncheckedBorder;
    }

    return IgnorePointer(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        width: metrics.indicatorSize,
        height: metrics.indicatorSize,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(metrics.indicatorBorderRadius),
          color: isChecked ? colors.checkedBackground : colors.uncheckedBackground,
          border: Border.all(
            color: isChecked ? colors.checkedBackground : colors.uncheckedBorder,
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
      ),
    );
  }
}
