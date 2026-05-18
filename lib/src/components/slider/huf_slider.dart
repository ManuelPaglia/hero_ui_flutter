import 'package:flutter/material.dart';

import '../../theme/huf_theme.dart';
import 'huf_slider_size.dart';
import 'huf_slider_style.dart';
import 'huf_slider_track.dart';

/// Slider a valore singolo del design system Hero UI Flutter.
///
/// [label] è obbligatoria; [showValue] mostra il valore corrente a destra.
/// [activeColor] usa [HUFThemeColors.primary] di default.
class HUFSlider extends StatefulWidget {
  const HUFSlider({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 100,
    this.step,
    this.enabled = true,
    this.showValue = false,
    this.valueFormatter,
    this.size = HUFSliderSize.medium,
    this.activeColor,
    this.inactiveTrackColor,
    this.thumbColor,
  }) : assert(min < max, 'min deve essere minore di max.');

  final String label;
  final double value;
  final ValueChanged<double>? onChanged;

  final double min;
  final double max;
  final double? step;
  final bool enabled;
  final bool showValue;
  final String Function(double value)? valueFormatter;
  final HUFSliderSize size;
  final Color? activeColor;
  final Color? inactiveTrackColor;
  final Color? thumbColor;

  @override
  State<HUFSlider> createState() => _HUFSliderState();
}

class _HUFSliderState extends State<HUFSlider> {
  double? _localValue;

  bool get _isDisabled => !widget.enabled || widget.onChanged == null;

  @override
  void didUpdateWidget(HUFSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _localValue = null;
    }
  }

  double get _displayValue => hufSliderSnapToStep(
        _localValue ?? widget.value,
        min: widget.min,
        max: widget.max,
        step: widget.step,
      );

  void _handleChanged(double value) {
    final resolved = hufSliderSnapToStep(
      value,
      min: widget.min,
      max: widget.max,
      step: widget.step,
    );
    setState(() => _localValue = resolved);
    widget.onChanged?.call(resolved);
  }

  String _formatValue(double v) {
    if (widget.valueFormatter != null) return widget.valueFormatter!(v);
    if (widget.step != null && widget.step! >= 1) {
      return v.round().toString();
    }
    return v == v.roundToDouble()
        ? v.round().toString()
        : v.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.hufTheme;
    final metrics = hufSliderMetricsFor(widget.size, theme.borderRadius);
    final colors = hufSliderColorsFor(
      theme.colors,
      _isDisabled,
      activeColor: widget.activeColor,
      inactiveTrackColor: widget.inactiveTrackColor,
      thumbColor: widget.thumbColor,
    );
    final displayValue = _displayValue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.label,
                style: TextStyle(
                  fontSize: metrics.labelFontSize,
                  fontWeight: FontWeight.w500,
                  color: colors.labelColor,
                  height: 1.3,
                ),
              ),
            ),
            if (widget.showValue)
              Text(
                _formatValue(displayValue),
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
        HUFSliderTrack(
          min: widget.min,
          max: widget.max,
          step: widget.step,
          metrics: metrics,
          colors: colors,
          enabled: !_isDisabled,
          value: displayValue,
          onValueChanged: _isDisabled ? null : _handleChanged,
        ),
      ],
    );
  }
}
