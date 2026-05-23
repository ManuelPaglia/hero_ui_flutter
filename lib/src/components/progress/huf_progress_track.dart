import 'package:flutter/material.dart';

import 'huf_progress_style.dart';

/// Track della barra di progresso (determinato o indeterminato).
class HUFProgressTrack extends StatelessWidget {
  const HUFProgressTrack({
    super.key,
    required this.metrics,
    required this.colors,
    this.progress,
    this.indeterminate = false,
  }) : assert(
          (progress != null && !indeterminate) ||
              (progress == null && indeterminate),
          'Specificare progress oppure indeterminate.',
        );

  final HUFProgressMetrics metrics;
  final HUFProgressColors colors;
  final double? progress;
  final bool indeterminate;

  @override
  Widget build(BuildContext context) {
    if (indeterminate) {
      return _HUFProgressIndeterminateTrack(
        metrics: metrics,
        colors: colors,
      );
    }

    return _HUFProgressDeterminateTrack(
      metrics: metrics,
      colors: colors,
      progress: progress!.clamp(0.0, 1.0),
    );
  }
}

class _HUFProgressFill extends StatelessWidget {
  const _HUFProgressFill({
    required this.width,
    required this.height,
    required this.radius,
    required this.color,
  });

  final double width;
  final double height;
  final double radius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

class _HUFProgressDeterminateTrack extends StatelessWidget {
  const _HUFProgressDeterminateTrack({
    required this.metrics,
    required this.colors,
    required this.progress,
  });

  final HUFProgressMetrics metrics;
  final HUFProgressColors colors;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final radius = hufProgressTrackRadius(metrics);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final fillWidth = width * progress;

        return Semantics(
          value: '${(progress * 100).round()}%',
          child: SizedBox(
            height: metrics.trackHeight,
            width: width,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: ColoredBox(color: colors.trackColor),
                  ),
                  if (fillWidth > 0)
                    _HUFProgressFill(
                      width: fillWidth,
                      height: metrics.trackHeight,
                      radius: radius,
                      color: colors.fillColor,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _HUFProgressIndeterminateTrack extends StatefulWidget {
  const _HUFProgressIndeterminateTrack({
    required this.metrics,
    required this.colors,
  });

  final HUFProgressMetrics metrics;
  final HUFProgressColors colors;

  @override
  State<_HUFProgressIndeterminateTrack> createState() =>
      _HUFProgressIndeterminateTrackState();
}

class _HUFProgressIndeterminateTrackState
    extends State<_HUFProgressIndeterminateTrack>
    with SingleTickerProviderStateMixin {
  static const _duration = Duration(milliseconds: 1600);

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _duration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final radius = hufProgressTrackRadius(widget.metrics);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final segmentWidth = width * hufProgressIndeterminateSegmentRatio;
        final travel = width + segmentWidth;

        return Semantics(
          label: 'Caricamento in corso',
          child: SizedBox(
            height: widget.metrics.trackHeight,
            width: width,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: ColoredBox(
                color: widget.colors.trackColor,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    final t = Curves.easeIn.transform(_controller.value);
                    final left = -segmentWidth + t * travel;

                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          left: left,
                          top: 0,
                          child: _HUFProgressFill(
                            width: segmentWidth,
                            height: widget.metrics.trackHeight,
                            radius: radius,
                            color: widget.colors.fillColor,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
