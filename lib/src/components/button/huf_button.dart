import 'package:flutter/material.dart';

import '../../layout/huf_shrink_wrap_width.dart';
import '../../theme/huf_theme.dart';
import '../popover/huf_popover.dart';
import 'huf_button_popover.dart';
import 'huf_button_press_scale.dart';
import 'huf_button_size.dart';
import 'huf_button_style.dart';
import 'huf_button_variant.dart';

/// Pulsante personalizzato del design system Hero UI Flutter.
///
/// Per default ha larghezza intrinseca ([isFullWidth] è `false`).
/// Imposta [isFullWidth] a `true` solo quando deve occupare tutta la riga
/// (es. azioni in [HUFCard]).
///
/// Con [popover] impostato, il tap apre o chiude il popover ancorato al
/// pulsante; [onPressed] non viene invocato.
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
    this.popover,
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
    this.popover,
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

  /// Popover ancorato al pulsante; se non null il tap gestisce apertura/chiusura.
  final HUFButtonPopover? popover;

  @override
  State<HUFButton> createState() => _HUFButtonState();
}

class _HUFButtonState extends State<HUFButton> with HUFButtonPressScaleMixin {
  bool _isDisabledFor(VoidCallback? onPressed) =>
      onPressed == null || widget.isLoading;

  @override
  void dispose() {
    disposeHufButtonPressScale();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final popover = widget.popover;
    if (popover != null) {
      return HUFPopover(
        placement: popover.placement,
        showArrow: popover.showArrow,
        offset: popover.offset,
        isOpen: popover.isOpen,
        onOpenChanged: popover.onOpenChanged,
        initialOpen: popover.initialOpen,
        closeOnTapOutside: popover.closeOnTapOutside,
        triggerBuilder: (context, toggle, isOpen) =>
            _buildButton(onPressed: toggle),
        child: popover.child,
      );
    }

    return _buildButton(onPressed: widget.onPressed);
  }

  Widget _buildButton({required VoidCallback? onPressed}) {
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
      _isDisabledFor(onPressed),
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
      child: content,
    );

    final isDisabled = _isDisabledFor(onPressed);
    final scale = pressScaleFor(!isDisabled);

    Widget button = AnimatedScale(
      scale: scale,
      duration: HUFButtonPressScaleMixin.pressAnimationDuration,
      curve: Curves.easeOut,
      alignment: Alignment.center,
      child: Listener(
        onPointerDown: isDisabled ? null : (_) => handleHufButtonPressStart(),
        onPointerUp: isDisabled ? null : (_) => handleHufButtonPressEnd(),
        onPointerCancel: isDisabled ? null : (_) => handleHufButtonPressEnd(),
        child: Material(
          color: theme.colors.transparent,
          child: InkWell(
            onTap: isDisabled ? null : onPressed,
            borderRadius: borderRadius,
            splashColor: colors.foreground.withValues(alpha: 0.12),
            highlightColor: colors.foreground.withValues(alpha: 0.08),
            child: child,
          ),
        ),
      ),
    );

    if (widget.isIconOnly) {
      return HUFShrinkWrapWidth(
        child: SizedBox(
          width: metrics.iconOnlySize + 4,
          height: metrics.iconOnlySize + iconOnlyGlowReserve,
          child: Center(child: button),
        ),
      );
    }

    button = Padding(
      padding: glowLayoutPadding,
      child: button,
    );

    if (widget.isFullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }

    return HUFShrinkWrapWidth(child: button);
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
