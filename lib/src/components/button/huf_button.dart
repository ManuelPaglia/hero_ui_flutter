import 'package:flutter/material.dart';

import '../../theme/huf_theme.dart';
import 'huf_button_size.dart';
import 'huf_button_style.dart';
import 'huf_button_variant.dart';

/// Pulsante personalizzato del design system Hero UI Flutter.
class HUFButton extends StatefulWidget {
  const HUFButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = HUFButtonVariant.primary,
    this.size = HUFButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.glowSize,
  }) : isIconOnly = false;

  /// Pulsante quadrato con sola icona.
  const HUFButton.iconOnly({
    super.key,
    required this.icon,
    this.onPressed,
    this.variant = HUFButtonVariant.primary,
    this.size = HUFButtonSize.medium,
    this.isLoading = false,
    this.glowSize,
  })  : label = '',
        isFullWidth = false,
        isIconOnly = true;

  final String label;
  final VoidCallback? onPressed;
  final HUFButtonVariant variant;
  final HUFButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final bool isIconOnly;
  final Widget? icon;

  /// Override dell'intensità glow; se null usa [HUFTheme.glowSize].
  final HUFGlowSize? glowSize;

  @override
  State<HUFButton> createState() => _HUFButtonState();
}

class _HUFButtonState extends State<HUFButton> {
  static const double _pressedScale = 0.97;
  static const Duration _pressAnimationDuration = Duration(milliseconds: 120);

  bool _isPressed = false;

  bool get _isDisabled => widget.onPressed == null || widget.isLoading;

  void _setPressed(bool value) {
    if (_isPressed == value) return;
    setState(() => _isPressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.hufTheme;
    final glowSize = widget.glowSize ?? theme.glowSize;
    final glowLayoutPadding = hufGlowLayoutPaddingFor(glowSize);
    final iconOnlyGlowReserve = hufIconOnlyGlowReserveFor(glowSize);
    final metrics = hufButtonMetricsFor(
      widget.size,
      widget.isIconOnly,
      theme.borderRadius,
    );
    final colors = hufButtonColorsFor(
      theme.colors,
      widget.variant,
      _isDisabled,
      isIconOnly: widget.isIconOnly,
      glowSize: glowSize,
    );

    final Widget content;
    if (widget.isIconOnly) {
      content = _buildIconOnlyContent(metrics, colors);
    } else {
      content = _buildLabeledContent(metrics, colors);
    }

    final borderRadius = BorderRadius.circular(metrics.borderRadius);

    final decoration = BoxDecoration(
      color: colors.background,
      borderRadius: borderRadius,
      border: colors.border,
      boxShadow: colors.boxShadow,
    );

    Widget child = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: widget.isIconOnly ? metrics.iconOnlySize : null,
      height: widget.isIconOnly ? metrics.iconOnlySize : metrics.height,
      padding: widget.isIconOnly
          ? EdgeInsets.zero
          : EdgeInsets.symmetric(horizontal: metrics.horizontalPadding),
      decoration: decoration,
      child: Center(child: content),
    );

    final scale = !_isDisabled && _isPressed ? _pressedScale : 1.0;

    Widget button = AnimatedScale(
      scale: scale,
      duration: _pressAnimationDuration,
      curve: Curves.easeOut,
      alignment: Alignment.center,
      child: Material(
        color: theme.colors.transparent,
        child: InkWell(
          onTap: _isDisabled ? null : widget.onPressed,
          onTapDown: _isDisabled ? null : (_) => _setPressed(true),
          onTapUp: _isDisabled ? null : (_) => _setPressed(false),
          onTapCancel: _isDisabled ? null : () => _setPressed(false),
          borderRadius: borderRadius,
          splashColor: colors.foreground.withValues(alpha: 0.12),
          highlightColor: colors.foreground.withValues(alpha: 0.08),
          child: child,
        ),
      ),
    );

    if (widget.isIconOnly) {
      return SizedBox(
        width: metrics.iconOnlySize + 4,
        height: metrics.iconOnlySize + iconOnlyGlowReserve,
        child: Center(child: button),
      );
    }

    button = Padding(
      padding: glowLayoutPadding,
      child: button,
    );

    if (widget.isFullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }

    return IntrinsicWidth(child: button);
  }

  Widget _buildIconOnlyContent(HUFButtonMetrics metrics, HUFButtonColors colors) {
    if (widget.isLoading) {
      return SizedBox(
        width: metrics.iconSize,
        height: metrics.iconSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: colors.foreground,
        ),
      );
    }

    return IconTheme(
      data: IconThemeData(
        color: colors.foreground,
        size: metrics.iconSize,
      ),
      child: widget.icon!,
    );
  }

  Widget _buildLabeledContent(HUFButtonMetrics metrics, HUFButtonColors colors) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.isLoading) ...[
          SizedBox(
            width: metrics.iconSize,
            height: metrics.iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: colors.foreground,
            ),
          ),
          SizedBox(width: metrics.gap),
        ] else if (widget.icon != null) ...[
          IconTheme(
            data: IconThemeData(
              color: colors.foreground,
              size: metrics.iconSize,
            ),
            child: widget.icon!,
          ),
          SizedBox(width: metrics.gap),
        ],
        Text(
          widget.label,
          style: TextStyle(
            color: colors.foreground,
            fontSize: metrics.fontSize,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}
