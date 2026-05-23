import 'package:flutter/material.dart';

import '../../layout/huf_shrink_wrap_width.dart';
import '../../theme/huf_theme.dart';
import 'huf_popover_placement.dart';
import 'huf_popover_style.dart';

/// Builder del trigger di [HUFPopover] (uso interno da [HUFButton] con [HUFButtonPopover]).
typedef HUFPopoverTriggerBuilder = Widget Function(
  BuildContext context,
  VoidCallback toggle,
  bool isOpen,
);

/// Contenuto predefinito con titolo e descrizione opzionali.
class HUFPopoverContent extends StatelessWidget {
  const HUFPopoverContent({
    super.key,
    this.title,
    this.description,
    this.child,
  });

  final String? title;
  final String? description;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme = context.hufTheme;
    final metrics = hufPopoverMetricsFor(theme.borderRadius);
    final colors = hufPopoverColorsFor(theme.colors);

    final children = <Widget>[];

    if (title != null) {
      children.add(
        Text(
          title!,
          style: TextStyle(
            fontSize: metrics.titleFontSize,
            fontWeight: FontWeight.w600,
            color: colors.titleColor,
            height: 1.3,
            decoration: TextDecoration.none,
          ),
        ),
      );
    }

    if (description != null) {
      if (children.isNotEmpty) {
        children.add(SizedBox(height: kHufPopoverTitleDescriptionGap));
      }
      children.add(
        Text(
          description!,
          style: TextStyle(
            fontSize: metrics.descriptionFontSize,
            fontWeight: FontWeight.w400,
            color: colors.descriptionColor,
            height: 1.4,
            decoration: TextDecoration.none,
          ),
        ),
      );
    }

    if (child != null) {
      if (children.isNotEmpty) {
        children.add(SizedBox(height: metrics.gap));
      }
      children.add(
        DefaultTextStyle(
          style: TextStyle(
            fontSize: metrics.descriptionFontSize,
            fontWeight: FontWeight.w400,
            color: colors.descriptionColor,
            height: 1.4,
            decoration: TextDecoration.none,
          ),
          child: child!,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}

/// Popover ancorato a un trigger, attivato al tap.
///
/// Non usare direttamente: imposta [HUFButton.popover] con [HUFButtonPopover].
/// Usa lo stesso token [HUFBorderRadius.value] e i colori card del tema.
/// Con [placement] predefinito [HUFPopoverPlacement.bottom]: se non c'è spazio
/// sufficiente nel viewport, il popover viene mostrato dalla parte opposta
/// (top ↔ bottom, start ↔ end).
class HUFPopover extends StatefulWidget {
  const HUFPopover({
    super.key,
    required this.triggerBuilder,
    required this.child,
    this.placement = HUFPopoverPlacement.bottom,
    this.align = HUFPopoverAlign.center,
    this.showArrow = false,
    this.offset,
    this.isOpen,
    this.onOpenChanged,
    this.initialOpen = false,
    this.closeOnTapOutside = true,
  });

  /// Costruisce il widget trigger; usa [toggle] come handler del tap.
  final HUFPopoverTriggerBuilder triggerBuilder;

  /// Contenuto del popover (es. [HUFPopoverContent] o widget custom).
  final Widget child;

  /// Posizione preferita rispetto al trigger.
  final HUFPopoverPlacement placement;

  /// Allineamento del popover sul trigger (`center`, `left`, `right`).
  final HUFPopoverAlign align;

  /// Mostra una freccia che punta verso il trigger.
  final bool showArrow;

  /// Gap tra trigger e popover; se null usa [HUFPopoverMetrics.gap].
  final double? offset;

  /// Stato aperto controllato dall'esterno.
  final bool? isOpen;

  /// Invocato quando lo stato aperto/chiuso cambia.
  final ValueChanged<bool>? onOpenChanged;

  /// Stato iniziale in modalità non controllata.
  final bool initialOpen;

  /// Chiude il popover al tap fuori dal contenuto.
  final bool closeOnTapOutside;

  @override
  State<HUFPopover> createState() => _HUFPopoverState();
}

class _HUFPopoverState extends State<HUFPopover> {
  final _triggerKey = GlobalKey();
  final Object _tapRegionGroup = Object();
  OverlayEntry? _overlayEntry;
  int _overlayGeneration = 0;
  int _overlayContentRebuildGeneration = 0;

  late bool _isOpen;

  bool get _isControlled => widget.isOpen != null;

  bool get _open => _isControlled ? widget.isOpen! : _isOpen;

  @override
  void initState() {
    super.initState();
    _isOpen = widget.isOpen ?? widget.initialOpen;
    if (_isOpen) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _open) _showOverlay();
      });
    }
  }

  /// Evita `markNeedsBuild` durante il build (es. setState dal contenuto).
  void _scheduleOverlayContentRebuild() {
    if (!_open || _overlayEntry == null) return;

    final generation = ++_overlayContentRebuildGeneration;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted ||
          !_open ||
          generation != _overlayContentRebuildGeneration) {
        return;
      }
      _overlayEntry?.markNeedsBuild();
    });
  }

  @override
  void didUpdateWidget(HUFPopover oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isControlled && widget.isOpen != oldWidget.isOpen) {
      _setOpen(widget.isOpen!, notify: false);
    }
    if (!_open || _overlayEntry == null) return;

    final placementChanged =
        widget.placement != oldWidget.placement ||
        widget.align != oldWidget.align;
    final contentChanged = widget.child != oldWidget.child;

    if (placementChanged || contentChanged) {
      _scheduleOverlayContentRebuild();
    }
  }

  @override
  void dispose() {
    _overlayGeneration++;
    _removeOverlay();
    super.dispose();
  }

  void _toggle() {
    final current = _isControlled ? widget.isOpen! : _isOpen;
    _setOpen(!current);
  }

  void _close() => _setOpen(false);

  void _setOpen(bool open, {bool notify = true}) {
    final current = _isControlled ? widget.isOpen! : _isOpen;
    if (current == open) return;

    if (!_isControlled) {
      setState(() => _isOpen = open);
    }

    if (open) {
      _showOverlay();
    } else {
      _removeOverlay();
    }

    if (notify) {
      widget.onOpenChanged?.call(open);
    }
  }

  void _showOverlay() {
    if (!mounted) return;

    _removeOverlay();
    final generation = ++_overlayGeneration;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_open || generation != _overlayGeneration) return;

      final triggerBox =
          _triggerKey.currentContext?.findRenderObject() as RenderBox?;
      final overlay = Overlay.maybeOf(context, rootOverlay: true);
      if (overlay == null) return;

      final gap = _gapFor(context);
      Offset? initialPosition;
      final overlayBox =
          overlay.context.findRenderObject() as RenderBox?;
      if (triggerBox != null &&
          triggerBox.hasSize &&
          overlayBox != null &&
          overlayBox.hasSize) {
        final mediaQuery = MediaQuery.of(context);
        final viewport = Rect.fromLTWH(
          mediaQuery.padding.left,
          mediaQuery.padding.top,
          mediaQuery.size.width - mediaQuery.padding.horizontal,
          mediaQuery.size.height - mediaQuery.padding.vertical,
        );
        final triggerRect =
            triggerBox.localToGlobal(Offset.zero) & triggerBox.size;
        final globalTopLeft = _popoverTopLeftFor(
          triggerRect: triggerRect,
          popoverSize: Size.zero,
          placement: widget.placement,
          align: widget.align,
          gap: gap,
          viewport: viewport,
        );
        initialPosition = overlayBox.globalToLocal(globalTopLeft);
      }

      _overlayEntry = OverlayEntry(
        builder: (overlayContext) => _HUFPopoverOverlay(
          triggerKey: _triggerKey,
          tapRegionGroup: _tapRegionGroup,
          requestedPlacement: widget.placement,
          align: widget.align,
          showArrow: widget.showArrow,
          gap: gap,
          initialPosition: initialPosition,
          closeOnTapOutside: widget.closeOnTapOutside,
          onTapOutside: _close,
          child: widget.child,
        ),
      );
      overlay.insert(_overlayEntry!);
    });
  }

  void _removeOverlay() {
    _overlayGeneration++;
    final entry = _overlayEntry;
    _overlayEntry = null;
    entry?.remove();
  }

  double _gapFor(BuildContext context) {
    final metrics = hufPopoverMetricsFor(context.hufTheme.borderRadius);
    return widget.offset ?? metrics.gap;
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _triggerKey,
      child: TapRegion(
        groupId: _tapRegionGroup,
        child: widget.triggerBuilder(context, _toggle, _open),
      ),
    );
  }
}

class _HUFPopoverOverlay extends StatefulWidget {
  const _HUFPopoverOverlay({
    required this.triggerKey,
    required this.tapRegionGroup,
    required this.requestedPlacement,
    required this.align,
    required this.showArrow,
    required this.gap,
    required this.initialPosition,
    required this.closeOnTapOutside,
    required this.onTapOutside,
    required this.child,
  });

  final GlobalKey triggerKey;
  final Object tapRegionGroup;
  final HUFPopoverPlacement requestedPlacement;
  final HUFPopoverAlign align;
  final bool showArrow;
  final double gap;
  final Offset? initialPosition;
  final bool closeOnTapOutside;
  final VoidCallback onTapOutside;
  final Widget child;

  @override
  State<_HUFPopoverOverlay> createState() => _HUFPopoverOverlayState();
}

class _HUFPopoverOverlayState extends State<_HUFPopoverOverlay>
    with SingleTickerProviderStateMixin {
  final _popoverKey = GlobalKey();
  Offset? _position;
  HUFPopoverPlacement? _resolvedPlacement;
  int _layoutAttempts = 0;
  bool _positionFinalized = false;

  static const _maxLayoutAttempts = 30;
  static const _entranceDuration = Duration(milliseconds: 160);

  late final AnimationController _entranceController;
  late final Animation<double> _entranceAnimation;

  @override
  void initState() {
    super.initState();
    _position = widget.initialPosition;
    _entranceController = AnimationController(
      vsync: this,
      duration: _entranceDuration,
    );
    _entranceAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _updatePosition());
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_HUFPopoverOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.requestedPlacement != widget.requestedPlacement ||
        oldWidget.align != widget.align) {
      _resolvedPlacement = null;
      _position = null;
      _positionFinalized = false;
      _layoutAttempts = 0;
      _entranceController.reset();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _updatePosition());
  }

  Alignment _scaleAlignmentFor(
    HUFPopoverPlacement placement,
    HUFPopoverAlign align,
  ) {
    final crossAxis = switch (align) {
      HUFPopoverAlign.center => 0.0,
      HUFPopoverAlign.left => -1.0,
      HUFPopoverAlign.right => 1.0,
    };
    return switch (placement) {
      HUFPopoverPlacement.bottom => Alignment(crossAxis, -1),
      HUFPopoverPlacement.top => Alignment(crossAxis, 1),
      HUFPopoverPlacement.start => Alignment(1, crossAxis),
      HUFPopoverPlacement.end => Alignment(-1, crossAxis),
    };
  }

  void _scheduleLayoutRetry() {
    if (_layoutAttempts++ < _maxLayoutAttempts) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _updatePosition());
    }
  }

  void _updatePosition() {
    if (!mounted) return;

    final overlayBox = context.findRenderObject() as RenderBox?;
    final triggerBox =
        widget.triggerKey.currentContext?.findRenderObject() as RenderBox?;
    final popoverBox =
        _popoverKey.currentContext?.findRenderObject() as RenderBox?;

    if (overlayBox == null ||
        !overlayBox.hasSize ||
        triggerBox == null ||
        !triggerBox.hasSize) {
      _scheduleLayoutRetry();
      return;
    }

    final mediaQuery = MediaQuery.of(context);
    final viewport = Rect.fromLTWH(
      mediaQuery.padding.left,
      mediaQuery.padding.top,
      mediaQuery.size.width - mediaQuery.padding.horizontal,
      mediaQuery.size.height - mediaQuery.padding.vertical,
    );

    final triggerGlobal = triggerBox.localToGlobal(Offset.zero);
    final triggerRect = triggerGlobal & triggerBox.size;
    final placement = _resolvedPlacement ?? widget.requestedPlacement;

    if (popoverBox == null || !popoverBox.hasSize) {
      final provisionalGlobal = _popoverTopLeftFor(
        triggerRect: triggerRect,
        popoverSize: Size.zero,
        placement: placement,
        align: widget.align,
        gap: widget.gap,
        viewport: viewport,
      );
      final local = overlayBox.globalToLocal(provisionalGlobal);
      if (_position != local) {
        setState(() => _position = local);
      }
      _scheduleLayoutRetry();
      return;
    }

    _layoutAttempts = 0;

    final popoverSize = popoverBox.size;
    final resolved = _resolvePlacementFor(
      requested: widget.requestedPlacement,
      align: widget.align,
      triggerRect: triggerRect,
      popoverSize: popoverSize,
      viewport: viewport,
      gap: widget.gap,
    );

    final globalTopLeft = _popoverTopLeftFor(
      triggerRect: triggerRect,
      popoverSize: popoverSize,
      placement: resolved,
      align: widget.align,
      gap: widget.gap,
      viewport: viewport,
    );

    final localTopLeft = overlayBox.globalToLocal(globalTopLeft);
    final shouldAnimate = !_positionFinalized;

    if (resolved != _resolvedPlacement ||
        _position != localTopLeft ||
        shouldAnimate) {
      setState(() {
        _resolvedPlacement = resolved;
        _position = localTopLeft;
        _positionFinalized = true;
      });
      if (shouldAnimate) {
        _entranceController.forward(from: 0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.hufTheme;
    final metrics = hufPopoverMetricsFor(theme.borderRadius);
    final colors = hufPopoverColorsFor(theme.colors);
    final placement = _resolvedPlacement ?? widget.requestedPlacement;

    final arrowEdge = widget.showArrow && _positionFinalized
        ? hufPopoverArrowEdgeForPlacement(placement)
        : null;

    double? arrowCrossAxisOffset;
    if (arrowEdge != null && _position != null) {
      final triggerBox =
          widget.triggerKey.currentContext?.findRenderObject() as RenderBox?;
      if (triggerBox != null && triggerBox.hasSize) {
        final triggerRect =
            triggerBox.localToGlobal(Offset.zero) & triggerBox.size;
        final overlayBox = context.findRenderObject() as RenderBox?;
        if (overlayBox != null && overlayBox.hasSize) {
          final popoverGlobalTopLeft =
              overlayBox.localToGlobal(_position!);
          arrowCrossAxisOffset = hufPopoverArrowCrossAxisOffset(
            edge: arrowEdge,
            triggerRect: triggerRect,
            popoverGlobalTopLeft: popoverGlobalTopLeft,
            arrowSize: metrics.arrowSize,
          );
        }
      }
    }

    final surface = _HUFPopoverSurface(
      key: _popoverKey,
      metrics: metrics,
      colors: colors,
      arrowEdge: arrowEdge,
      arrowCrossAxisOffset: arrowCrossAxisOffset,
      child: widget.child,
    );

    final popover = HUFShrinkWrapWidth(
      alignment: AlignmentDirectional.centerStart,
      child: UnconstrainedBox(
        alignment: AlignmentDirectional.centerStart,
        constrainedAxis: Axis.horizontal,
        clipBehavior: Clip.none,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: metrics.maxWidth),
          child: surface,
        ),
      ),
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        if (_position != null)
          Positioned(
            left: _position!.dx,
            top: _position!.dy,
            child: TapRegion(
              groupId: widget.tapRegionGroup,
              onTapOutside: (_) {
                if (widget.closeOnTapOutside) widget.onTapOutside();
              },
              child: FadeTransition(
                opacity: _entranceAnimation,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.96, end: 1).animate(
                    _entranceAnimation,
                  ),
                  alignment: _scaleAlignmentFor(placement, widget.align),
                  child: popover,
                ),
              ),
            ),
          )
        else
          Positioned.fill(
            child: IgnorePointer(
              child: Opacity(opacity: 0, child: popover),
            ),
          ),
      ],
    );
  }
}

class _HUFPopoverSurface extends StatelessWidget {
  const _HUFPopoverSurface({
    super.key,
    required this.metrics,
    required this.colors,
    required this.arrowEdge,
    this.arrowCrossAxisOffset,
    required this.child,
  });

  final HUFPopoverMetrics metrics;
  final HUFPopoverColors colors;
  final HUFPopoverArrowEdge? arrowEdge;
  final double? arrowCrossAxisOffset;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(metrics.borderRadius);

    final card = DecoratedBox(
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: borderRadius,
        border: Border.all(color: colors.border),
        boxShadow: metrics.shadow,
      ),
      child: DefaultTextStyle(
        style: DefaultTextStyle.of(context).style.copyWith(
          decoration: TextDecoration.none,
        ),
        child: Padding(
          padding: metrics.padding,
          child: child,
        ),
      ),
    );

    final edge = arrowEdge;
    if (edge == null) return card;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        card,
        _HUFPopoverArrow(
          edge: edge,
          crossAxisOffset: arrowCrossAxisOffset,
          fillColor: colors.background,
          borderColor: colors.border,
          size: metrics.arrowSize,
        ),
      ],
    );
  }
}

class _HUFPopoverArrow extends StatelessWidget {
  const _HUFPopoverArrow({
    required this.edge,
    this.crossAxisOffset,
    required this.fillColor,
    required this.borderColor,
    required this.size,
  });

  final HUFPopoverArrowEdge edge;
  final double? crossAxisOffset;
  final Color fillColor;
  final Color borderColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    final arrow = CustomPaint(
      size: Size(size * 2, size),
      painter: _HUFPopoverArrowPainter(
        fillColor: fillColor,
        borderColor: borderColor,
        pointsUp: edge == HUFPopoverArrowEdge.top,
      ),
    );

    final rotated = switch (edge) {
      HUFPopoverArrowEdge.top || HUFPopoverArrowEdge.bottom => arrow,
      HUFPopoverArrowEdge.left => RotatedBox(quarterTurns: 3, child: arrow),
      HUFPopoverArrowEdge.right => RotatedBox(quarterTurns: 1, child: arrow),
    };

    final crossAxis = crossAxisOffset;
    final centerOnCrossAxis = crossAxis == null;

    return Positioned(
      top: switch (edge) {
        HUFPopoverArrowEdge.top => -size + 1,
        HUFPopoverArrowEdge.left ||
        HUFPopoverArrowEdge.right =>
          centerOnCrossAxis ? 0 : crossAxis,
        _ => null,
      },
      bottom: switch (edge) {
        HUFPopoverArrowEdge.bottom => -size + 1,
        HUFPopoverArrowEdge.left ||
        HUFPopoverArrowEdge.right =>
          centerOnCrossAxis ? 0 : null,
        _ => null,
      },
      left: switch (edge) {
        HUFPopoverArrowEdge.left => -size + 1,
        HUFPopoverArrowEdge.top ||
        HUFPopoverArrowEdge.bottom =>
          centerOnCrossAxis ? 0 : crossAxis,
        _ => null,
      },
      right: switch (edge) {
        HUFPopoverArrowEdge.right => -size + 1,
        HUFPopoverArrowEdge.top ||
        HUFPopoverArrowEdge.bottom =>
          centerOnCrossAxis ? 0 : null,
        _ => null,
      },
      child: centerOnCrossAxis ? Center(child: rotated) : rotated,
    );
  }
}

class _HUFPopoverArrowPainter extends CustomPainter {
  const _HUFPopoverArrowPainter({
    required this.fillColor,
    required this.borderColor,
    required this.pointsUp,
  });

  final Color fillColor;
  final Color borderColor;
  final bool pointsUp;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    if (pointsUp) {
      path
        ..moveTo(size.width / 2, 0)
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close();
    } else {
      path
        ..moveTo(0, 0)
        ..lineTo(size.width, 0)
        ..lineTo(size.width / 2, size.height)
        ..close();
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = fillColor
        ..style = PaintingStyle.fill,
    );

    canvas.drawPath(
      path,
      Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(covariant _HUFPopoverArrowPainter oldDelegate) {
    return oldDelegate.fillColor != fillColor ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.pointsUp != pointsUp;
  }
}

Offset _popoverTopLeftFor({
  required Rect triggerRect,
  required Size popoverSize,
  required HUFPopoverPlacement placement,
  required HUFPopoverAlign align,
  required double gap,
  required Rect viewport,
}) {
  final crossAxis = hufPopoverAlignAxisOffset(
    align: align,
    placement: placement,
    triggerRect: triggerRect,
    popoverSize: popoverSize,
  );

  final raw = switch (placement) {
    HUFPopoverPlacement.bottom => Offset(
        crossAxis,
        triggerRect.bottom + gap,
      ),
    HUFPopoverPlacement.top => Offset(
        crossAxis,
        triggerRect.top - gap - popoverSize.height,
      ),
    HUFPopoverPlacement.start => Offset(
        triggerRect.left - gap - popoverSize.width,
        crossAxis,
      ),
    HUFPopoverPlacement.end => Offset(
        triggerRect.right + gap,
        crossAxis,
      ),
  };

  return switch (placement) {
    HUFPopoverPlacement.bottom || HUFPopoverPlacement.top => Offset(
        raw.dx.clamp(
          viewport.left,
          viewport.right - popoverSize.width,
        ),
        raw.dy,
      ),
    HUFPopoverPlacement.start || HUFPopoverPlacement.end => Offset(
        raw.dx,
        raw.dy.clamp(
          viewport.top,
          viewport.bottom - popoverSize.height,
        ),
      ),
  };
}

Rect _popoverRectFor({
  required Rect triggerRect,
  required Size popoverSize,
  required HUFPopoverPlacement placement,
  required HUFPopoverAlign align,
  required double gap,
}) {
  final topLeft = _popoverTopLeftFor(
    triggerRect: triggerRect,
    popoverSize: popoverSize,
    placement: placement,
    align: align,
    gap: gap,
    viewport: const Rect.fromLTWH(0, 0, double.infinity, double.infinity),
  );
  return topLeft & popoverSize;
}

bool _fitsInViewport(Rect rect, Rect viewport) {
  return rect.left >= viewport.left &&
      rect.top >= viewport.top &&
      rect.right <= viewport.right &&
      rect.bottom <= viewport.bottom;
}

HUFPopoverPlacement _resolvePlacementFor({
  required HUFPopoverPlacement requested,
  required HUFPopoverAlign align,
  required Rect triggerRect,
  required Size popoverSize,
  required Rect viewport,
  required double gap,
}) {
  final primary = _popoverRectFor(
    triggerRect: triggerRect,
    popoverSize: popoverSize,
    placement: requested,
    align: align,
    gap: gap,
  );

  if (_fitsInViewport(primary, viewport)) {
    return requested;
  }

  final flipped = hufPopoverFlipPlacement(requested);
  final fallback = _popoverRectFor(
    triggerRect: triggerRect,
    popoverSize: popoverSize,
    placement: flipped,
    align: align,
    gap: gap,
  );

  if (_fitsInViewport(fallback, viewport)) {
    return flipped;
  }

  return requested;
}
