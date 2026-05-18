import 'package:flutter/material.dart';

import '../../theme/huf_theme.dart';
import 'huf_button_size.dart';
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
  }) : isIconOnly = false;

  /// Pulsante quadrato con sola icona.
  const HUFButton.iconOnly({
    super.key,
    required this.icon,
    this.onPressed,
    this.variant = HUFButtonVariant.primary,
    this.size = HUFButtonSize.medium,
    this.isLoading = false,
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

  @override
  State<HUFButton> createState() => _HUFButtonState();
}

class _HUFButtonState extends State<HUFButton> {
  static const double _pressedScale = 0.99;
  static const Duration _pressAnimationDuration = Duration(milliseconds: 120);
  static const double _iconOnlyGlowReserve = 12;

  bool _isPressed = false;

  bool get _isDisabled => widget.onPressed == null || widget.isLoading;

  void _setPressed(bool value) {
    if (_isPressed == value) return;
    setState(() => _isPressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.hufTheme;
    final metrics = _metricsFor(widget.size, widget.isIconOnly, theme.borderRadius);
    final colors = _colorsFor(
      theme.colors,
      widget.variant,
      _isDisabled,
      isIconOnly: widget.isIconOnly,
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

    final child = AnimatedContainer(
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
      button = SizedBox(
        width: metrics.iconOnlySize + 4,
        height: metrics.iconOnlySize + _iconOnlyGlowReserve,
        child: Center(child: button),
      );
    } else if (colors.boxShadow != null) {
      button = Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
        child: button,
      );
    }

    if (widget.isFullWidth && !widget.isIconOnly) {
      return SizedBox(width: double.infinity, child: button);
    }

    return button;
  }

  Widget _buildIconOnlyContent(_HUFButtonMetrics metrics, _HUFButtonColors colors) {
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

  Widget _buildLabeledContent(_HUFButtonMetrics metrics, _HUFButtonColors colors) {
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

class _HUFButtonMetrics {
  const _HUFButtonMetrics({
    required this.height,
    required this.horizontalPadding,
    required this.fontSize,
    required this.borderRadius,
    required this.iconSize,
    required this.gap,
    required this.iconOnlySize,
  });

  final double height;
  final double horizontalPadding;
  final double fontSize;
  final double borderRadius;
  final double iconSize;
  final double gap;

  /// Lato del quadrato icon-only (include compensazione bordo).
  final double iconOnlySize;
}

class _HUFButtonColors {
  const _HUFButtonColors({
    required this.background,
    required this.foreground,
    this.border,
    this.boxShadow,
  });

  final Color background;
  final Color foreground;
  final Border? border;
  final List<BoxShadow>? boxShadow;
}

List<BoxShadow> _glowShadow(Color color) {
  return [
    BoxShadow(
      color: color.withValues(alpha: 0.38),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: color.withValues(alpha: 0.22),
      blurRadius: 22,
      spreadRadius: 1,
    ),
  ];
}

_HUFButtonMetrics _metricsFor(
  HUFButtonSize size,
  bool isIconOnly,
  HUFBorderRadius borderRadius,
) {
  return switch (size) {
    HUFButtonSize.small => _HUFButtonMetrics(
        height: 36,
        horizontalPadding: 14,
        fontSize: 13,
        borderRadius: borderRadius.sm,
        iconSize: isIconOnly ? 18 : 16,
        gap: 6,
        iconOnlySize: 36,
      ),
    HUFButtonSize.medium => _HUFButtonMetrics(
        height: 44,
        horizontalPadding: 18,
        fontSize: 15,
        borderRadius: borderRadius.md,
        iconSize: isIconOnly ? 20 : 18,
        gap: 8,
        iconOnlySize: 44,
      ),
    HUFButtonSize.large => _HUFButtonMetrics(
        height: 52,
        horizontalPadding: 22,
        fontSize: 16,
        borderRadius: borderRadius.lg,
        iconSize: isIconOnly ? 22 : 20,
        gap: 10,
        iconOnlySize: 52,
      ),
  };
}

const double _labeledOutlinedBorderWidth = 1;
const double _iconOnlyOutlinedBorderWidth = 1.5;

_HUFButtonColors _colorsFor(
  HUFThemeColors palette,
  HUFButtonVariant variant,
  bool isDisabled, {
  required bool isIconOnly,
}) {
  Border? outlinedBorder(Color color) {
    if (variant != HUFButtonVariant.outlined) return null;
    final width =
        isIconOnly ? _iconOnlyOutlinedBorderWidth : _labeledOutlinedBorderWidth;
    return Border.all(color: color, width: width);
  }

  if (isDisabled) {
    return switch (variant) {
      HUFButtonVariant.outlined => _HUFButtonColors(
          background: palette.transparent,
          foreground: palette.disabled,
          border: outlinedBorder(palette.disabled),
        ),
      HUFButtonVariant.ghost => _HUFButtonColors(
          background: palette.transparent,
          foreground: palette.disabled,
        ),
      HUFButtonVariant.dangerSoft =>
        _HUFButtonColors(
          background: palette.disabled.withValues(alpha: 0.35),
          foreground: palette.disabled,
        ),
      HUFButtonVariant.primary ||
      HUFButtonVariant.secondary ||
      HUFButtonVariant.danger =>
        _HUFButtonColors(
          background: palette.disabled,
          foreground: palette.disabledForeground,
        ),
    };
  }

  return switch (variant) {
    HUFButtonVariant.primary => _HUFButtonColors(
        background: palette.primary,
        foreground: palette.primaryForeground,
        boxShadow: _glowShadow(palette.primary),
      ),
    HUFButtonVariant.secondary => _HUFButtonColors(
        background: palette.secondary,
        foreground: palette.secondaryForeground,
      ),
    HUFButtonVariant.outlined => _HUFButtonColors(
        background: isIconOnly
            ? palette.primary.withValues(alpha: 0.1)
            : palette.transparent,
        foreground: palette.primary,
        border: outlinedBorder(palette.primary),
      ),
    HUFButtonVariant.ghost => _HUFButtonColors(
        background: palette.transparent,
        foreground: palette.primary,
      ),
    HUFButtonVariant.danger => _HUFButtonColors(
        background: palette.danger,
        foreground: palette.dangerForeground,
        boxShadow: _glowShadow(palette.danger),
      ),
    HUFButtonVariant.dangerSoft => _HUFButtonColors(
        background: palette.dangerSoft,
        foreground: palette.dangerSoftForeground,
      ),
  };
}
