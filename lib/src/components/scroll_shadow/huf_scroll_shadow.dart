import 'package:flutter/material.dart';

import '../../theme/huf_theme.dart';

/// Ombre a gradiente sui bordi di un'area scrollabile.
///
/// Avvolge qualsiasi widget scrollabile ([ListView], [SingleChildScrollView],
/// [GridView], …) oppure usa i factory [HUFScrollShadow.verticalList],
/// [HUFScrollShadow.horizontalList], [HUFScrollShadow.column] e
/// [HUFScrollShadow.row] per i casi più comuni.
///
/// L'ombra iniziale (sopra o a sinistra) sparisce quando lo scroll è all'inizio;
/// quella finale (sotto o a destra) quando si raggiunge la fine. Il colore
/// deriva dal tema ([HUFTheme.colors.card] di default) e la profondità del
/// gradiente è regolata con [size].
class HUFScrollShadow extends StatefulWidget {
  const HUFScrollShadow({
    super.key,
    required this.child,
    this.direction = Axis.vertical,
    this.size = 32,
    this.color,
  });

  /// Lista verticale scrollabile con ombre sopra/sotto.
  factory HUFScrollShadow.verticalList({
    Key? key,
    required List<Widget> children,
    double size = 32,
    Color? color,
    EdgeInsetsGeometry? padding,
    bool shrinkWrap = false,
    ScrollPhysics? physics,
  }) {
    return HUFScrollShadow(
      key: key,
      direction: Axis.vertical,
      size: size,
      color: color,
      child: ListView(
        padding: padding,
        shrinkWrap: shrinkWrap,
        physics: physics,
        children: children,
      ),
    );
  }

  /// Lista orizzontale scrollabile con ombre a sinistra/destra.
  factory HUFScrollShadow.horizontalList({
    Key? key,
    required List<Widget> children,
    double size = 32,
    Color? color,
    EdgeInsetsGeometry? padding,
    bool shrinkWrap = false,
    ScrollPhysics? physics,
  }) {
    return HUFScrollShadow(
      key: key,
      direction: Axis.horizontal,
      size: size,
      color: color,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: padding,
        shrinkWrap: shrinkWrap,
        physics: physics,
        children: children,
      ),
    );
  }

  /// [Column] dentro [SingleChildScrollView] verticale.
  factory HUFScrollShadow.column({
    Key? key,
    required List<Widget> children,
    double size = 32,
    Color? color,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    ScrollPhysics? physics,
  }) {
    return HUFScrollShadow(
      key: key,
      direction: Axis.vertical,
      size: size,
      color: color,
      child: SingleChildScrollView(
        physics: physics,
        child: Column(
          crossAxisAlignment: crossAxisAlignment,
          mainAxisAlignment: mainAxisAlignment,
          mainAxisSize: mainAxisSize,
          children: children,
        ),
      ),
    );
  }

  /// [Row] dentro [SingleChildScrollView] orizzontale.
  factory HUFScrollShadow.row({
    Key? key,
    required List<Widget> children,
    double size = 32,
    Color? color,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    ScrollPhysics? physics,
  }) {
    return HUFScrollShadow(
      key: key,
      direction: Axis.horizontal,
      size: size,
      color: color,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: physics,
        child: Row(
          mainAxisAlignment: mainAxisAlignment,
          mainAxisSize: mainAxisSize,
          crossAxisAlignment: crossAxisAlignment,
          children: children,
        ),
      ),
    );
  }

  final Widget child;
  final Axis direction;
  final double size;
  final Color? color;

  @override
  State<HUFScrollShadow> createState() => _HUFScrollShadowState();
}

class _HUFScrollShadowState extends State<HUFScrollShadow> {
  static const _epsilon = 0.5;

  bool _showStart = false;
  bool _showEnd = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_syncScrollMetrics);
  }

  @override
  void didUpdateWidget(covariant HUFScrollShadow oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback(_syncScrollMetrics);
  }

  bool _metricsMatchDirection(ScrollMetrics metrics) {
    return metrics.axis == widget.direction;
  }

  void _updateFromMetrics(ScrollMetrics metrics) {
    if (!_metricsMatchDirection(metrics)) return;

    final hasOverflow = metrics.maxScrollExtent > _epsilon;
    final showStart =
        hasOverflow && metrics.pixels > metrics.minScrollExtent + _epsilon;
    final showEnd = hasOverflow &&
        metrics.pixels < metrics.maxScrollExtent - _epsilon;

    if (showStart == _showStart && showEnd == _showEnd) return;

    setState(() {
      _showStart = showStart;
      _showEnd = showEnd;
    });
  }

  void _syncScrollMetrics(_) {
    if (!mounted) return;

    final metrics = _findScrollMetrics(context);
    if (metrics != null) {
      _updateFromMetrics(metrics);
    }
  }

  ScrollMetrics? _findScrollMetrics(BuildContext from) {
    ScrollMetrics? result;

    void visit(Element element) {
      if (result != null) return;
      if (element is StatefulElement && element.state is ScrollableState) {
        result = (element.state as ScrollableState).position;
        return;
      }
      element.visitChildren(visit);
    }

    from.visitChildElements(visit);
    return result;
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification.depth != 0) return false;
    if (notification is ScrollUpdateNotification ||
        notification is ScrollMetricsNotification ||
        notification is ScrollEndNotification) {
      _updateFromMetrics(notification.metrics);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final shadowColor = widget.color ?? context.hufTheme.colors.card;

    return NotificationListener<ScrollNotification>(
      onNotification: _onScrollNotification,
      child: Stack(
        fit: StackFit.passthrough,
        clipBehavior: Clip.hardEdge,
        children: [
          widget.child,
          if (_showStart)
            _HUFScrollShadowEdge(
              key: const Key('huf_scroll_shadow_start'),
              direction: widget.direction,
              isStart: true,
              size: widget.size,
              color: shadowColor,
            ),
          if (_showEnd)
            _HUFScrollShadowEdge(
              key: const Key('huf_scroll_shadow_end'),
              direction: widget.direction,
              isStart: false,
              size: widget.size,
              color: shadowColor,
            ),
        ],
      ),
    );
  }
}

class _HUFScrollShadowEdge extends StatelessWidget {
  const _HUFScrollShadowEdge({
    super.key,
    required this.direction,
    required this.isStart,
    required this.size,
    required this.color,
  });

  final Axis direction;
  final bool isStart;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final gradient = _gradientForEdge();

    return Positioned(
      top: direction == Axis.vertical ? (isStart ? 0 : null) : 0,
      bottom: direction == Axis.vertical ? (isStart ? null : 0) : 0,
      left: direction == Axis.horizontal ? (isStart ? 0 : null) : 0,
      right: direction == Axis.horizontal ? (isStart ? null : 0) : 0,
      height: direction == Axis.vertical ? size : null,
      width: direction == Axis.horizontal ? size : null,
      child: IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(gradient: gradient),
        ),
      ),
    );
  }

  LinearGradient _gradientForEdge() {
    if (direction == Axis.vertical) {
      if (isStart) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color, color.withValues(alpha: 0)],
        );
      }
      return LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [color, color.withValues(alpha: 0)],
      );
    }

    if (isStart) {
      return LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [color, color.withValues(alpha: 0)],
      );
    }
    return LinearGradient(
      begin: Alignment.centerRight,
      end: Alignment.centerLeft,
      colors: [color, color.withValues(alpha: 0)],
    );
  }
}
