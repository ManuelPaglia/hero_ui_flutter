import 'package:flutter/material.dart';

import '../../theme/huf_theme.dart';
import 'huf_progress_size.dart';
import 'huf_progress_style.dart';
import 'huf_progress_track.dart';

/// Barra di progresso del design system Hero UI Flutter.
///
/// [label] è obbligatoria; [showValue] mostra il valore a destra (nascosto in
/// [isLoading]). [maxValue] e [valueSuffix] controllano la formattazione del
/// valore (`%` → percentuale arrotondata).
///
/// Con [isLoading] un segmento colorato attraversa il track (esce
/// completamente a destra prima di ripartire da sinistra) con easing
/// [Curves.easeIn] (partenza lenta, accelerazione verso destra).
/// Track e fill usano il border radius del tema.
class HUFProgress extends StatelessWidget {
  const HUFProgress({
    super.key,
    required this.label,
    this.value = 0,
    this.maxValue = 100,
    this.valueSuffix = '%',
    this.showValue = true,
    this.isLoading = false,
    this.size = HUFProgressSize.medium,
    this.fillColor,
    this.trackColor,
  }) : assert(maxValue > 0, 'maxValue deve essere maggiore di zero.');

  final String label;
  final double value;
  final double maxValue;
  final String valueSuffix;
  final bool showValue;
  final bool isLoading;
  final HUFProgressSize size;
  final Color? fillColor;
  final Color? trackColor;

  @override
  Widget build(BuildContext context) {
    final theme = context.hufTheme;
    final metrics = hufProgressMetricsFor(size, theme.borderRadius);
    final colors = hufProgressColorsFor(
      theme.colors,
      fillColor: fillColor,
      trackColor: trackColor,
    );
    final progress = isLoading ? null : (value / maxValue).clamp(0.0, 1.0);
    final displayValue = hufProgressFormatValue(
      value: value,
      maxValue: maxValue,
      valueSuffix: valueSuffix,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: metrics.labelFontSize,
                  fontWeight: FontWeight.w500,
                  color: colors.labelColor,
                  height: 1.3,
                ),
              ),
            ),
            if (showValue && !isLoading)
              Text(
                displayValue,
                style: TextStyle(
                  fontSize: metrics.valueFontSize,
                  fontWeight: FontWeight.w500,
                  color: colors.valueColor,
                  height: 1.3,
                ),
              ),
          ],
        ),
        SizedBox(height: metrics.headerGap),
        HUFProgressTrack(
          metrics: metrics,
          colors: colors,
          progress: progress,
          indeterminate: isLoading,
        ),
      ],
    );
  }
}
