import 'package:flutter/material.dart';

import '../../theme/huf_theme.dart';
import 'huf_slider_size.dart';
import 'huf_slider_style.dart';
import 'huf_slider_track.dart';

/// Range slider (doppio handle) del design system Hero UI Flutter.
///
/// [label] è obbligatoria; [showValue] mostra l'intervallo selezionato a destra.
/// [activeColor] usa [HUFThemeColors.primary] di default.
class HUFRangeSlider extends StatefulWidget {
  const HUFRangeSlider({
    super.key,
    required this.label,
    required this.values,
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
  final RangeValues values;
  final ValueChanged<RangeValues>? onChanged;

  final double min;
  final double max;
  final double? step;
  final bool enabled;
  final bool showValue;
  final String Function(RangeValues values)? valueFormatter;
  final HUFSliderSize size;
  final Color? activeColor;
  final Color? inactiveTrackColor;
  final Color? thumbColor;

  @override
  State<HUFRangeSlider> createState() => _HUFRangeSliderState();
}

class _HUFRangeSliderState extends State<HUFRangeSlider> {
  RangeValues? _localValues;

  bool get _isDisabled => !widget.enabled || widget.onChanged == null;

  @override
  void didUpdateWidget(HUFRangeSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.values != oldWidget.values) {
      _localValues = null;
    }
  }

  RangeValues _resolveValues(RangeValues raw) {
    var start = hufSliderSnapToStep(
      raw.start,
      min: widget.min,
      max: widget.max,
      step: widget.step,
    );
    var end = hufSliderSnapToStep(
      raw.end,
      min: widget.min,
      max: widget.max,
      step: widget.step,
    );
    if (start > end) {
      final swap = start;
      start = end;
      end = swap;
    }
    return RangeValues(start, end);
  }

  RangeValues get _displayValues =>
      _resolveValues(_localValues ?? widget.values);

  void _handleChanged(RangeValues values) {
    final resolved = _resolveValues(values);
    setState(() => _localValues = resolved);
    widget.onChanged?.call(resolved);
  }

  String _formatValues(RangeValues v) {
    if (widget.valueFormatter != null) return widget.valueFormatter!(v);
    String fmt(double n) {
      if (widget.step != null && widget.step! >= 1) return n.round().toString();
      return n == n.roundToDouble()
          ? n.round().toString()
          : n.toStringAsFixed(2);
    }

    return '${fmt(v.start)} – ${fmt(v.end)}';
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
    final display = _displayValues;

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
                _formatValues(display),
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
          rangeStart: display.start,
          rangeEnd: display.end,
          onRangeChanged: _isDisabled ? null : _handleChanged,
        ),
      ],
    );
  }
}
