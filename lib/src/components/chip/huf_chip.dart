import 'package:flutter/material.dart';

import '../../theme/huf_theme.dart';
import 'huf_chip_size.dart';
import 'huf_chip_style.dart';
import 'huf_chip_variant.dart';

/// Etichetta compatta del design system Hero UI Flutter.
///
/// Non è interattiva: serve solo a mostrare testo (e opzionalmente un'icona).
/// Le varianti visive rispecchiano [HUFButton] primary, outlined e ghost,
/// senza glow e con dimensioni inferiori ai pulsanti.
class HUFChip extends StatelessWidget {
  const HUFChip({
    super.key,
    required this.label,
    this.variant = HUFChipVariant.primary,
    this.size = HUFChipSize.medium,
    this.icon,
    this.isDisabled = false,
  });

  final String label;
  final HUFChipVariant variant;
  final HUFChipSize size;
  final Widget? icon;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    final theme = context.hufTheme;
    final metrics = hufChipMetricsFor(size, theme.borderRadius);
    final colors = hufChipColorsFor(theme.colors, variant, isDisabled);

    return IntrinsicWidth(
      child: Container(
        height: metrics.height,
        padding: EdgeInsets.symmetric(horizontal: metrics.horizontalPadding),
        decoration: BoxDecoration(
          color: colors.background,
          borderRadius: BorderRadius.circular(metrics.borderRadius),
          border: colors.border,
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                IconTheme(
                  data: IconThemeData(
                    color: colors.foreground,
                    size: metrics.iconSize,
                  ),
                  child: icon!,
                ),
                SizedBox(width: metrics.gap),
              ],
              Text(
                label,
                style: TextStyle(
                  color: colors.foreground,
                  fontSize: metrics.fontSize,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
