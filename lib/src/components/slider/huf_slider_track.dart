import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'huf_slider_style.dart';

/// Track interattivo conmotionato per slider singolo e range.
class HUFSliderTrack extends StatefulWidget {
  const HUFSliderTrack({
    super.key,
    required this.min,
    required this.max,
    required this.metrics,
    required this.colors,
    required this.enabled,
    this.value,
    this.rangeStart,
    this.rangeEnd,
    this.step,
    this.onValueChanged,
    this.onRangeChanged,
  }) : assert(
          (value != null && rangeStart == null && rangeEnd == null) ||
              (rangeStart != null && rangeEnd != null && value == null),
          'Usare value (singolo) oppure rangeStart/rangeEnd (range).',
        );

  final double min;
  final double max;
  final double? step;
  final HUFSliderMetrics metrics;
  final HUFSliderColors colors;
  final bool enabled;

  final double? value;
  final ValueChanged<double>? onValueChanged;

  final double? rangeStart;
  final double? rangeEnd;
  final ValueChanged<RangeValues>? onRangeChanged;

  bool get isRange => rangeStart != null;

  @override
  State<HUFSliderTrack> createState() => _HUFSliderTrackState();
}

class _HUFSliderTrackState extends State<HUFSliderTrack> {
  _RangeThumb? _activeRangeThumb;

  double _dxToValue(double dx, double width) {
    final thumbExtent = widget.metrics.thumbWidth;
    final usable = width - thumbExtent;
    if (usable <= 0) return widget.min;
    final t = ((dx - thumbExtent / 2) / usable).clamp(0.0, 1.0);
    return hufSliderSnapToStep(
      widget.min + t * (widget.max - widget.min),
      min: widget.min,
      max: widget.max,
      step: widget.step,
    );
  }

  double _valueToDx(double value, double width) {
    final thumbExtent = widget.metrics.thumbWidth;
    final span = widget.max - widget.min;
    if (span <= 0) return thumbExtent / 2;
    final t = ((value - widget.min) / span).clamp(0.0, 1.0);
    return t * (width - thumbExtent) + thumbExtent / 2;
  }

  _RangeThumb _nearestThumb(double dx, double width, double start, double end) {
    final startDx = _valueToDx(start, width);
    final endDx = _valueToDx(end, width);
    return (dx - startDx).abs() <= (dx - endDx).abs()
        ? _RangeThumb.start
        : _RangeThumb.end;
  }

  void _handlePointer(double dx, double width) {
    if (widget.isRange) {
      final start = widget.rangeStart!;
      final end = widget.rangeEnd!;
      final next = _dxToValue(dx, width);
      final thumb = _activeRangeThumb ?? _nearestThumb(dx, width, start, end);
      if (thumb == _RangeThumb.start) {
        widget.onRangeChanged?.call(
          RangeValues(next.clamp(widget.min, end), end),
        );
      } else {
        widget.onRangeChanged?.call(
          RangeValues(start, next.clamp(start, widget.max)),
        );
      }
    } else {
      widget.onValueChanged?.call(_dxToValue(dx, width));
    }
  }

  @override
  Widget build(BuildContext context) {
    final trackRadius = hufSliderTrackRadius(widget.metrics);
    final thumbRadius = hufSliderThumbRadius(widget.metrics);
    final trackTop =
        (widget.metrics.touchHeight - widget.metrics.trackHeight) / 2;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        Widget buildTrackLane({
          required double activeLeft,
          required double activeWidth,
          required List<double> thumbCenters,
        }) {
          return Positioned(
            left: 0,
            top: trackTop,
            width: width,
            height: widget.metrics.trackHeight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(trackRadius),
              child: Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  Positioned.fill(
                    child: ColoredBox(
                      color: widget.colors.inactiveTrackColor,
                    ),
                  ),
                  Positioned(
                    left: activeLeft,
                    width: activeWidth.clamp(0.0, width),
                    top: 0,
                    bottom: 0,
                    child: ColoredBox(
                      color: widget.colors.activeColor,
                    ),
                  ),
                  for (final centerX in thumbCenters)
                    Positioned(
                      left: centerX - widget.metrics.thumbWidth / 2,
                      top: 0,
                      child: Container(
                        width: widget.metrics.thumbWidth,
                        height: widget.metrics.trackHeight,
                        decoration: BoxDecoration(
                          color: widget.colors.thumbColor,
                          borderRadius: BorderRadius.circular(thumbRadius),
                          border: Border.all(
                            color: widget.colors.thumbBorderColor,
                            width: widget.metrics.thumbBorderWidth,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        }

        Widget buildVisual() {
          if (widget.isRange) {
            final start = widget.rangeStart!;
            final end = widget.rangeEnd!;
            final startX = _valueToDx(start, width);
            final endX = _valueToDx(end, width);

            return Stack(
              clipBehavior: Clip.none,
              children: [
                buildTrackLane(
                  activeLeft: startX.clamp(0.0, width),
                  activeWidth: (endX - startX).clamp(0.0, width),
                  thumbCenters: [startX, endX],
                ),
              ],
            );
          }

          final thumbX = _valueToDx(widget.value!, width);

          return Stack(
            clipBehavior: Clip.none,
            children: [
              buildTrackLane(
                activeLeft: 0,
                activeWidth: thumbX,
                thumbCenters: [thumbX],
              ),
            ],
          );
        }

        final visual = buildVisual();

        if (!widget.enabled) {
          return Semantics(
            slider: true,
            enabled: false,
            child: SizedBox(
              height: widget.metrics.touchHeight,
              width: width,
              child: visual,
            ),
          );
        }

        return Semantics(
          slider: true,
          enabled: true,
          child: SizedBox(
            height: widget.metrics.touchHeight,
            width: width,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: (details) {
                if (widget.isRange) {
                  _activeRangeThumb = _nearestThumb(
                    details.localPosition.dx,
                    width,
                    widget.rangeStart!,
                    widget.rangeEnd!,
                  );
                } else {
                  HapticFeedback.selectionClick();
                }
                _handlePointer(details.localPosition.dx, width);
              },
              onHorizontalDragStart: (details) {
                if (widget.isRange) {
                  _activeRangeThumb = _nearestThumb(
                    details.localPosition.dx,
                    width,
                    widget.rangeStart!,
                    widget.rangeEnd!,
                  );
                }
                _handlePointer(details.localPosition.dx, width);
              },
              onHorizontalDragUpdate: (details) {
                _handlePointer(details.localPosition.dx, width);
              },
              onHorizontalDragEnd: (_) => _activeRangeThumb = null,
              onHorizontalDragCancel: () => _activeRangeThumb = null,
              child: visual,
            ),
          ),
        );
      },
    );
  }
}

enum _RangeThumb { start, end }
