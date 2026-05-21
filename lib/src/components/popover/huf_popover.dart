import 'package:flutter/material.dart';

import '../../layout/huf_shrink_wrap_width.dart';
import '../../theme/huf_theme.dart';
import 'huf_popover_placement.dart';
import 'huf_popover_style.dart';

/// Builder del trigger di [HUFPopover].
///
/// [toggle] apre o chiude il popover; [isOpen] indica lo stato corrente.
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
  OverlayEntry? _overlayEntry;
  int _overlayGeneration = 0;

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

  @override
  void didUpdateWidget(HUFPopover oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isControlled && widget.isOpen != oldWidget.isOpen) {
      _setOpen(widget.isOpen!, notify: false);
    }
    if (widget.placement != oldWidget.placement && _open) {
      _overlayEntry?.markNeedsBuild();
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

      final overlay = Overlay.maybeOf(context, rootOverlay: true);
      if (overlay == null) return;

      _overlayEntry = OverlayEntry(
        builder: (overlayContext) => _HUFPopoverOverlay(
          triggerKey: _triggerKey,
          requestedPlacement: widget.placement,
          showArrow: widget.showArrow,
          gap: _gapFor(context),
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
      child: widget.triggerBuilder(context, _toggle, _open),
    );
  }
}

class _HUFPopoverOverlay extends StatefulWidget {
  const _HUFPopoverOverlay({
    required this.triggerKey,
    required this.requestedPlacement,
    required this.showArrow,
    required this.gap,
    required this.closeOnTapOutside,
    required this.onTapOutside,
    required this.child,
  });

  final GlobalKey triggerKey;
  final HUFPopoverPlacement requestedPlacement;
  final bool showArrow;
  final double gap;
  final bool closeOnTapOutside;
  final VoidCallback onTapOutside;
  final Widget child;

  @override
  State<_HUFPopoverOverlay> createState() => _HUFPopoverOverlayState();
}

class _HUFPopoverOverlayState extends State<_HUFPopoverOverlay> {
  final _popoverKey = GlobalKey();
  Offset? _position;
  HUFPopoverPlacement? _resolvedPlacement;
  int _layoutAttempts = 0;

  static const _maxLayoutAttempts = 30;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _updatePosition());
  }

  @override
  void didUpdateWidget(_HUFPopoverOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.requestedPlacement != widget.requestedPlacement) {
      _resolvedPlacement = null;
      _position = null;
      _layoutAttempts = 0;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _updatePosition());
  }

  void _updatePosition() {
    if (!mounted) return;

    final overlayBox = context.findRenderObject() as RenderBox?;
    final triggerBox =
        widget.triggerKey.currentContext?.findRenderObject() as RenderBox?;
    final popoverBox =
        _popoverKey.currentContext?.findRenderObject() as RenderBox?;

    if (triggerBox == null || !triggerBox.hasSize) {
      if (_layoutAttempts++ < _maxLayoutAttempts) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _updatePosition());
      }
      return;
    }

    if (overlayBox == null ||
        !overlayBox.hasSize ||
        popoverBox == null ||
        !popoverBox.hasSize) {
      if (_layoutAttempts++ < _maxLayoutAttempts) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _updatePosition());
      }
      return;
    }

    _layoutAttempts = 0;

    final mediaQuery = MediaQuery.of(context);
    final viewport = Rect.fromLTWH(
      mediaQuery.padding.left,
      mediaQuery.padding.top,
      mediaQuery.size.width - mediaQuery.padding.horizontal,
      mediaQuery.size.height - mediaQuery.padding.vertical,
    );

    final triggerGlobal = triggerBox.localToGlobal(Offset.zero);
    final triggerRect = triggerGlobal & triggerBox.size;
    final popoverSize = popoverBox.size;

    final resolved = _resolvePlacementFor(
      requested: widget.requestedPlacement,
      triggerRect: triggerRect,
      popoverSize: popoverSize,
      viewport: viewport,
      gap: widget.gap,
    );

    final globalTopLeft = _popoverTopLeftFor(
      triggerRect: triggerRect,
      popoverSize: popoverSize,
      placement: resolved,
      gap: widget.gap,
      viewport: viewport,
    );

    final localTopLeft = overlayBox.globalToLocal(globalTopLeft);

    if (resolved != _resolvedPlacement || _position != localTopLeft) {
      setState(() {
        _resolvedPlacement = resolved;
        _position = localTopLeft;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.hufTheme;
    final metrics = hufPopoverMetricsFor(theme.borderRadius);
    final colors = hufPopoverColorsFor(theme.colors);
    final placement = _resolvedPlacement ?? widget.requestedPlacement;

    final surface = _HUFPopoverSurface(
      key: _popoverKey,
      metrics: metrics,
      colors: colors,
      placement: placement,
      showArrow: widget.showArrow,
      child: widget.child,
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        if (widget.closeOnTapOutside)
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: widget.onTapOutside,
            ),
          ),
        Positioned(
          left: _position?.dx ?? 0,
          top: _position?.dy ?? 0,
          child: IgnorePointer(
            ignoring: _position == null,
            child: TapRegion(
              onTapOutside: (_) {
                if (widget.closeOnTapOutside) widget.onTapOutside();
              },
              child: Opacity(
                opacity: _position != null ? 1 : 0,
                child: HUFShrinkWrapWidth(
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
                ),
              ),
            ),
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
    required this.placement,
    required this.showArrow,
    required this.child,
  });

  final HUFPopoverMetrics metrics;
  final HUFPopoverColors colors;
  final HUFPopoverPlacement placement;
  final bool showArrow;
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

    if (!showArrow) return card;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        card,
        _HUFPopoverArrow(
          placement: placement,
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
    required this.placement,
    required this.fillColor,
    required this.borderColor,
    required this.size,
  });

  final HUFPopoverPlacement placement;
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
        pointsUp: _pointsUp,
      ),
    );

    return Positioned(
      top: switch (placement) {
        HUFPopoverPlacement.bottom => -size + 1,
        HUFPopoverPlacement.start || HUFPopoverPlacement.end => 0,
        _ => null,
      },
      bottom: switch (placement) {
        HUFPopoverPlacement.top => -size + 1,
        HUFPopoverPlacement.start || HUFPopoverPlacement.end => 0,
        _ => null,
      },
      left: switch (placement) {
        HUFPopoverPlacement.bottom || HUFPopoverPlacement.top => 0,
        HUFPopoverPlacement.end => -size + 1,
        _ => null,
      },
      right: switch (placement) {
        HUFPopoverPlacement.bottom || HUFPopoverPlacement.top => 0,
        HUFPopoverPlacement.start => -size + 1,
        _ => null,
      },
      child: switch (placement) {
        HUFPopoverPlacement.bottom || HUFPopoverPlacement.top => Center(
            child: arrow,
          ),
        HUFPopoverPlacement.start || HUFPopoverPlacement.end => Center(
            child: RotatedBox(
              quarterTurns: placement == HUFPopoverPlacement.start ? 1 : 3,
              child: arrow,
            ),
          ),
      },
    );
  }

  bool get _pointsUp => placement == HUFPopoverPlacement.bottom;
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
  required double gap,
  required Rect viewport,
}) {
  final raw = switch (placement) {
    HUFPopoverPlacement.bottom => Offset(
        triggerRect.center.dx - popoverSize.width / 2,
        triggerRect.bottom + gap,
      ),
    HUFPopoverPlacement.top => Offset(
        triggerRect.center.dx - popoverSize.width / 2,
        triggerRect.top - gap - popoverSize.height,
      ),
    HUFPopoverPlacement.start => Offset(
        triggerRect.left - gap - popoverSize.width,
        triggerRect.center.dy - popoverSize.height / 2,
      ),
    HUFPopoverPlacement.end => Offset(
        triggerRect.right + gap,
        triggerRect.center.dy - popoverSize.height / 2,
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
  required double gap,
}) {
  final topLeft = _popoverTopLeftFor(
    triggerRect: triggerRect,
    popoverSize: popoverSize,
    placement: placement,
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
  required Rect triggerRect,
  required Size popoverSize,
  required Rect viewport,
  required double gap,
}) {
  final primary = _popoverRectFor(
    triggerRect: triggerRect,
    popoverSize: popoverSize,
    placement: requested,
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
    gap: gap,
  );

  if (_fitsInViewport(fallback, viewport)) {
    return flipped;
  }

  return requested;
}
