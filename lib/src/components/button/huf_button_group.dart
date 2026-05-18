import 'package:flutter/material.dart';

import '../../theme/huf_theme.dart';
import 'huf_button_group_item.dart';
import 'huf_button_size.dart';
import 'huf_button_style.dart';
import 'huf_button_variant.dart';

/// Gruppo di pulsanti affiancati con aspetto di un unico controllo.
///
/// Richiede almeno due [items]. Condividono [variant] e [size] con [HUFButton];
/// solo il primo e l'ultimo segmento ricevono il border radius esterno del tema.
class HUFButtonGroup extends StatelessWidget {
  const HUFButtonGroup({
    super.key,
    required this.items,
    this.variant = HUFButtonVariant.primary,
    this.size = HUFButtonSize.medium,
    this.isFullWidth = false,
  }) : assert(
          items.length >= 2,
          'HUFButtonGroup richiede almeno 2 elementi.',
        );

  final List<HUFButtonGroupItem> items;
  final HUFButtonVariant variant;
  final HUFButtonSize size;
  final bool isFullWidth;

  @override
  Widget build(BuildContext context) {
    final theme = context.hufTheme;
    final metrics = hufButtonMetricsFor(
      size,
      false,
      theme.borderRadius,
    );
    final allDisabled = items.every((item) => item.onPressed == null);
    final colors = hufButtonColorsFor(
      theme.colors,
      variant,
      allDisabled,
    );

    final radius = metrics.borderRadius;
    final groupRadius = BorderRadius.circular(radius);
    final dividerColor = colors.foreground.withValues(alpha: 0.28);

    final segments = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      final isFirst = i == 0;
      final isLast = i == items.length - 1;
      final segmentRadius = hufButtonGroupSegmentRadius(
        radius: radius,
        isFirst: isFirst,
        isLast: isLast,
      );

      Widget segment = _HUFButtonGroupSegment(
        item: item,
        metrics: metrics,
        colors: colors,
        segmentRadius: segmentRadius,
        showDivider: !isLast,
        dividerColor: dividerColor,
      );

      if (isFullWidth) {
        segment = Expanded(child: segment);
      }

      segments.add(segment);
    }

    Widget group = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: groupRadius,
        border: colors.border,
        boxShadow: colors.boxShadow,
      ),
      child: ClipRRect(
        borderRadius: groupRadius,
        child: Material(
          color: colors.background,
          child: IntrinsicHeight(
            child: Row(
              mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: segments,
            ),
          ),
        ),
      ),
    );

    group = Padding(
      padding: hufButtonGlowLayoutPadding,
      child: group,
    );

    if (isFullWidth) {
      return SizedBox(width: double.infinity, child: group);
    }

    return group;
  }
}

class _HUFButtonGroupSegment extends StatefulWidget {
  const _HUFButtonGroupSegment({
    required this.item,
    required this.metrics,
    required this.colors,
    required this.segmentRadius,
    required this.showDivider,
    required this.dividerColor,
  });

  final HUFButtonGroupItem item;
  final HUFButtonMetrics metrics;
  final HUFButtonColors colors;
  final BorderRadius segmentRadius;
  final bool showDivider;
  final Color dividerColor;

  @override
  State<_HUFButtonGroupSegment> createState() => _HUFButtonGroupSegmentState();
}

class _HUFButtonGroupSegmentState extends State<_HUFButtonGroupSegment> {
  static const double _pressedScale = 0.97;
  static const Duration _pressAnimationDuration = Duration(milliseconds: 120);

  bool _isPressed = false;

  bool get _isDisabled => widget.item.onPressed == null;

  Color get _foreground {
    if (_isDisabled) {
      return context.hufTheme.colors.disabled;
    }
    return widget.colors.foreground;
  }

  void _setPressed(bool value) {
    if (_isPressed == value) return;
    setState(() => _isPressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final metrics = widget.metrics;
    final horizontalPadding = widget.item.isIconOnly
        ? (metrics.height - metrics.iconSize) / 2
        : metrics.horizontalPadding;

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.item.icon != null) ...[
          IconTheme(
            data: IconThemeData(
              color: _foreground,
              size: metrics.iconSize,
            ),
            child: widget.item.icon!,
          ),
          if (widget.item.label != null && widget.item.label!.isNotEmpty)
            SizedBox(width: metrics.gap),
        ],
        if (widget.item.label != null && widget.item.label!.isNotEmpty)
          Text(
            widget.item.label!,
            style: TextStyle(
              color: _foreground,
              fontSize: metrics.fontSize,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
      ],
    );

    final scale = !_isDisabled && _isPressed ? _pressedScale : 1.0;

    return AnimatedScale(
      scale: scale,
      duration: _pressAnimationDuration,
      curve: Curves.easeOut,
      alignment: Alignment.center,
      child: Material(
        color: widget.colors.background,
        child: InkWell(
          onTap: _isDisabled ? null : widget.item.onPressed,
          onTapDown: _isDisabled ? null : (_) => _setPressed(true),
          onTapUp: _isDisabled ? null : (_) => _setPressed(false),
          onTapCancel: _isDisabled ? null : () => _setPressed(false),
          borderRadius: widget.segmentRadius,
          splashColor: _foreground.withValues(alpha: 0.12),
          highlightColor: _foreground.withValues(alpha: 0.08),
          child: Container(
            height: metrics.height,
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: widget.showDivider
                  ? Border(
                      right: BorderSide(
                        color: widget.dividerColor,
                        width: 1,
                      ),
                    )
                  : null,
            ),
            child: content,
          ),
        ),
      ),
    );
  }
}
