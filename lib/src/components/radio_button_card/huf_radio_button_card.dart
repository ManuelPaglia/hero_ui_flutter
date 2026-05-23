import 'package:flutter/material.dart';

import '../../theme/huf_theme.dart';
import '../box_item/huf_box_item.dart';
import '../box_item/huf_box_item_style.dart';
import '../radio_button/huf_radio_button_size.dart';
import '../radio_button/huf_radio_button_style.dart';
import 'huf_radio_button_card_style.dart';

/// Card cliccabile con radio button, titolo e sottotitolo opzionale.
///
/// Costruita su [HUFBoxItem]. Uso in gruppo tramite [HUFRadioButtonCardGroup] + [HUFBoxList].
class HUFRadioButtonCard extends StatelessWidget {
  const HUFRadioButtonCard({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.value,
    this.onChanged,
    this.optionValue,
    this.enabled = true,
    this.size = HUFRadioButtonSize.medium,
    this.glowSize,
    this.activeColor,
    this.dotColor,
    this.borderColor,
  }) : assert(
          optionValue == null || (value == null && onChanged == null),
          'Con optionValue la card è gestita da HUFRadioButtonCardGroup: '
          'non passare value né onChanged.',
        );

  const HUFRadioButtonCard.wired({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.icon,
    this.optionValue,
    this.enabled = true,
    this.size = HUFRadioButtonSize.medium,
    this.glowSize,
    this.activeColor,
    this.dotColor,
    this.borderColor,
  });

  final String title;
  final String? subtitle;
  final Widget? icon;
  final bool? value;
  final ValueChanged<bool>? onChanged;
  final Object? optionValue;
  final bool enabled;
  final HUFRadioButtonSize size;
  final HUFGlowSize? glowSize;
  final Color? activeColor;
  final Color? dotColor;
  final Color? borderColor;

  bool get _isDisabled => !enabled || onChanged == null;

  HUFRadioButtonCard copyWith({
    bool? value,
    ValueChanged<bool>? onChanged,
    bool? enabled,
  }) {
    return HUFRadioButtonCard.wired(
      key: key,
      title: title,
      subtitle: subtitle,
      icon: icon,
      value: value ?? this.value ?? false,
      onChanged: onChanged ?? this.onChanged,
      optionValue: optionValue,
      enabled: enabled ?? this.enabled,
      size: size,
      glowSize: glowSize,
      activeColor: activeColor,
      dotColor: dotColor,
      borderColor: borderColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(
      optionValue != null || value != null,
      'HUFRadioButtonCard richiede value (uso singolo) o optionValue (uso in gruppo).',
    );

    final theme = context.hufTheme;
    final resolvedGlowSize = glowSize ?? theme.glowSize;
    final isSelected = value ?? false;
    final boxSize = hufBoxItemSizeFromRadio(size);
    final boxColors = hufBoxItemColorsFor(
      theme.colors,
      isSelected,
      _isDisabled,
      activeColor: activeColor,
    );
    final radioMetrics = hufRadioButtonCardRadioMetricsFor(size);
    final radioColors = hufRadioButtonCardRadioColorsFor(
      theme.colors,
      isSelected,
      _isDisabled,
      glowSize: resolvedGlowSize,
      activeColor: activeColor,
      dotColor: dotColor,
      borderColor: borderColor,
    );

    return HUFBoxItem(
      title: title,
      subtitle: subtitle,
      icon: icon,
      enabled: enabled,
      highlighted: isSelected,
      size: boxSize,
      colors: boxColors,
      activeColor: activeColor,
      onTap: _isDisabled || isSelected ? null : () => onChanged!(true),
      semanticsChecked: isSelected,
      action: _buildRadioIndicator(
        isSelected: isSelected,
        radioMetrics: radioMetrics,
        radioColors: radioColors,
      ),
    );
  }

  Widget _buildRadioIndicator({
    required bool isSelected,
    required HUFRadioButtonMetrics radioMetrics,
    required HUFRadioButtonColors radioColors,
  }) {
    return IgnorePointer(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        width: radioMetrics.size,
        height: radioMetrics.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: radioColors.backgroundColor,
          border: Border.all(
            color: radioColors.borderColor,
            width: isSelected
                ? radioMetrics.selectedBorderWidth
                : radioMetrics.borderWidth,
          ),
          boxShadow: radioColors.boxShadow,
        ),
        child: isSelected
            ? Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeOut,
                  width: radioMetrics.dotSize,
                  height: radioMetrics.dotSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: radioColors.dotColor,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
