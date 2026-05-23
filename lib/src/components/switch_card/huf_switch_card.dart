import 'package:flutter/material.dart';

import '../../theme/huf_theme.dart';
import '../box_item/huf_box_item.dart';
import '../box_item/huf_box_item_style.dart';
import '../switch/huf_switch_size.dart';
import '../switch/huf_switch_style.dart';
import 'huf_switch_card_style.dart';

/// Card cliccabile con switch, titolo e sottotitolo opzionale.
///
/// Costruita su [HUFBoxItem]. Uso in gruppo tramite [HUFSwitchCardGroup] + [HUFBoxList].
class HUFSwitchCard extends StatelessWidget {
  const HUFSwitchCard({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.value,
    this.onChanged,
    this.optionValue,
    this.enabled = true,
    this.size = HUFSwitchSize.medium,
    this.glowSize,
    this.switchIcon,
    this.activeColor,
    this.thumbColor,
    this.inactiveTrackColor,
    this.iconColor,
  }) : assert(
          optionValue == null || (value == null && onChanged == null),
          'Con optionValue la card è gestita da HUFSwitchCardGroup: '
          'non passare value né onChanged.',
        );

  const HUFSwitchCard.wired({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.icon,
    this.optionValue,
    this.enabled = true,
    this.size = HUFSwitchSize.medium,
    this.glowSize,
    this.switchIcon,
    this.activeColor,
    this.thumbColor,
    this.inactiveTrackColor,
    this.iconColor,
  });

  final String title;
  final String? subtitle;
  final Widget? icon;
  final bool? value;
  final ValueChanged<bool>? onChanged;
  final Object? optionValue;
  final bool enabled;
  final HUFSwitchSize size;
  final HUFGlowSize? glowSize;
  final Widget? switchIcon;
  final Color? activeColor;
  final Color? thumbColor;
  final Color? inactiveTrackColor;
  final Color? iconColor;

  bool get _isDisabled => !enabled || onChanged == null;

  HUFSwitchCard copyWith({
    bool? value,
    ValueChanged<bool>? onChanged,
    bool? enabled,
  }) {
    return HUFSwitchCard.wired(
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
      switchIcon: switchIcon,
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
      'HUFSwitchCard richiede value (uso singolo) o optionValue (uso in gruppo).',
    );

    final theme = context.hufTheme;
    final resolvedGlowSize = glowSize ?? theme.glowSize;
    final isOn = value ?? false;
    final boxSize = hufBoxItemSizeFromSwitch(size);
    final boxColors = hufBoxItemColorsFor(
      theme.colors,
      isOn,
      _isDisabled,
      activeColor: activeColor,
    );
    final switchMetrics =
        hufSwitchCardSwitchMetricsFor(size, theme.borderRadius);
    final switchColors = hufSwitchCardSwitchColorsFor(
      theme.colors,
      isOn,
      _isDisabled,
      glowSize: resolvedGlowSize,
      activeColor: activeColor,
      thumbColor: thumbColor,
      inactiveTrackColor: inactiveTrackColor,
      iconColor: iconColor,
    );

    return HUFBoxItem(
      title: title,
      subtitle: subtitle,
      icon: icon,
      enabled: enabled,
      highlighted: isOn,
      size: boxSize,
      colors: boxColors,
      activeColor: activeColor,
      onTap: _isDisabled ? null : () => onChanged!(!isOn),
      semanticsToggled: isOn,
      action: _buildSwitchIndicator(
        isOn: isOn,
        switchMetrics: switchMetrics,
        switchColors: switchColors,
      ),
    );
  }

  Widget _buildSwitchIndicator({
    required bool isOn,
    required HUFSwitchMetrics switchMetrics,
    required HUFSwitchColors switchColors,
  }) {
    final trackRadius = hufSwitchTrackRadius(switchMetrics);
    final thumbRadius = hufSwitchThumbRadius(switchMetrics);

    return IgnorePointer(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        width: switchMetrics.trackWidth,
        height: switchMetrics.trackHeight,
        decoration: BoxDecoration(
          color: switchColors.trackColor,
          borderRadius: BorderRadius.circular(trackRadius),
          boxShadow: switchColors.boxShadow,
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: switchMetrics.thumbWidth,
            height: switchMetrics.thumbHeight,
            margin: EdgeInsets.all(switchMetrics.thumbInset),
            decoration: BoxDecoration(
              color: switchColors.thumbColor,
              borderRadius: BorderRadius.circular(thumbRadius),
            ),
            child: switchIcon == null
                ? null
                : Center(
                    child: IconTheme(
                      data: IconThemeData(
                        color: switchColors.iconColor,
                        size: switchMetrics.iconSize,
                      ),
                      child: switchIcon!,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
