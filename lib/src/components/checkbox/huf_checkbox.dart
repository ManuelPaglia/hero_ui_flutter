import 'package:flutter/material.dart';

import '../../theme/huf_theme.dart';
import 'huf_checkbox_size.dart';
import 'huf_checkbox_style.dart';

/// Checkbox del design system Hero UI Flutter.
///
/// Usa [HUFTheme.colors.primary] quando selezionato. Per override globali
/// personalizza [HUFThemeData] / [HUFThemeColors]; per override puntuali
/// passa [activeColor], [checkColor] o [borderColor]. [checkedIcon] e
/// [uncheckedIcon] permettono icone personalizzate negli stati selezionato e
/// non selezionato. L'intensità glow deriva da [HUFThemeData.glowSize];
/// [glowSize] sul widget la sovrascrive.
class HUFCheckbox extends StatelessWidget {
  const HUFCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.size = HUFCheckboxSize.medium,
    this.glowSize,
    this.label,
    this.checkedIcon,
    this.uncheckedIcon,
    this.activeColor,
    this.checkColor,
    this.borderColor,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final HUFCheckboxSize size;
  /// Override dell'intensità glow; se null usa [HUFTheme.glowSize].
  final HUFGlowSize? glowSize;
  final String? label;

  /// Icona mostrata quando [value] è `true`. Default: segno di spunta.
  final Widget? checkedIcon;

  /// Icona mostrata quando [value] è `false`. Se null il box resta vuoto.
  final Widget? uncheckedIcon;

  /// Colore di riempimento e bordo quando selezionato.
  final Color? activeColor;

  /// Colore del segno di spunta.
  final Color? checkColor;

  /// Colore del bordo quando non selezionato.
  final Color? borderColor;

  bool get _isDisabled => onChanged == null;

  @override
  Widget build(BuildContext context) {
    final theme = context.hufTheme;
    final resolvedGlowSize = glowSize ?? theme.glowSize;
    final metrics = hufCheckboxMetricsFor(size, theme.borderRadius);
    final glowLayoutPadding = hufGlowLayoutPaddingFor(resolvedGlowSize);
    final colors = hufCheckboxColorsFor(
      theme.colors,
      value,
      _isDisabled,
      glowSize: resolvedGlowSize,
      activeColor: activeColor,
      checkColor: checkColor,
      borderColor: borderColor,
    );

    final borderRadius = BorderRadius.circular(metrics.borderRadius);
    final splashColor = colors.activeBackground.withValues(alpha: 0.12);
    final highlightColor = colors.activeBackground.withValues(alpha: 0.08);

    final box = Padding(
      padding: glowLayoutPadding,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        width: metrics.size,
        height: metrics.size,
        decoration: BoxDecoration(
          color: value ? colors.activeBackground : colors.inactiveBackground,
          borderRadius: borderRadius,
          border: Border.all(
            color: value ? colors.activeBorder : colors.inactiveBorder,
            width: metrics.borderWidth,
          ),
          boxShadow: colors.boxShadow,
        ),
        child: _buildBoxIcon(
          value: value,
          metrics: metrics,
          colors: colors,
          theme: theme,
        ),
      ),
    );

    final Widget content;
    if (label == null) {
      content = box;
    } else {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          box,
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
      checked: value,
      enabled: !_isDisabled,
      button: true,
      label: label,
      child: Material(
        color: theme.colors.transparent,
        child: InkWell(
          onTap: _isDisabled ? null : () => onChanged!(!value),
          borderRadius: BorderRadius.circular(metrics.borderRadius + 4),
          splashColor: splashColor,
          highlightColor: highlightColor,
          child: content,
        ),
      ),
    );
  }

  double _labelFontSize(HUFCheckboxSize size) {
    return switch (size) {
      HUFCheckboxSize.small => 13,
      HUFCheckboxSize.medium => 15,
      HUFCheckboxSize.large => 16,
    };
  }

  Widget? _buildBoxIcon({
    required bool value,
    required HUFCheckboxMetrics metrics,
    required HUFCheckboxColors colors,
    required HUFTheme theme,
  }) {
    final Widget? icon;
    final Color iconColor;

    if (value) {
      icon = checkedIcon ?? const Icon(Icons.check_rounded);
      iconColor = colors.checkColor;
    } else {
      icon = uncheckedIcon;
      if (icon == null) return null;
      iconColor = _isDisabled
          ? theme.colors.disabled
          : colors.inactiveBorder;
    }

    return Center(
      child: IconTheme(
        data: IconThemeData(
          color: iconColor,
          size: metrics.checkIconSize,
        ),
        child: icon,
      ),
    );
  }
}
