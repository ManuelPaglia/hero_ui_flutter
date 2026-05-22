import 'package:flutter/material.dart';

import '../components/drawer/huf_drawer.dart';
import '../components/drawer/huf_drawer_open_from.dart';
import '../components/drawer/huf_drawer_style.dart';
import '../theme/huf_theme.dart';

export '../components/drawer/huf_drawer_open_from.dart' show HUFDrawerOpenFrom;

/// Opzioni per [hufShowDrawer].
@immutable
class HUFShowDrawerOptions {
  const HUFShowDrawerOptions({
    this.openFrom = HUFDrawerOpenFrom.left,
    this.isFullWidth = false,
    this.content = const [],
    this.width,
    this.height,
    this.onDismissed,
    this.barrierColor,
  });

  final HUFDrawerOpenFrom openFrom;
  final bool isFullWidth;
  final List<Widget> content;

  /// Larghezza fissa se `openFrom` è `left` o `right` (solo se [isFullWidth] è `false`).
  final double? width;

  /// Altezza fissa se `openFrom` è `bottom` (solo se [isFullWidth] è `false`).
  final double? height;
  final VoidCallback? onDismissed;
  final Color? barrierColor;
}

/// Mostra [HUFDrawerPanel] con overlay e animazione slide.
Future<T?> hufShowDrawer<T>(
  BuildContext context, {
  required HUFShowDrawerOptions options,
}) {
  final theme = HUFTheme.of(context);
  final metrics = hufDrawerMetricsFor(theme, barrierColor: options.barrierColor);
  final barrierDismissible = !options.isFullWidth;

  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: metrics.barrierColor,
    transitionDuration: const Duration(milliseconds: 280),
    pageBuilder: (dialogContext, animation, secondaryAnimation) {
      void dismiss() {
        Navigator.of(dialogContext).pop();
        options.onDismissed?.call();
      }

      return _HUFDrawerDialogBody(
        openFrom: options.openFrom,
        isFullWidth: options.isFullWidth,
        content: options.content,
        width: options.width,
        height: options.height,
        onClose: dismiss,
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final openFrom = options.openFrom;
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );

      return SlideTransition(
        position: Tween<Offset>(
          begin: switch (openFrom) {
            HUFDrawerOpenFrom.left => const Offset(-1, 0),
            HUFDrawerOpenFrom.right => const Offset(1, 0),
            HUFDrawerOpenFrom.bottom => const Offset(0, 1),
          },
          end: Offset.zero,
        ).animate(curved),
        child: child,
      );
    },
  );
}

extension HUFDrawerContext on BuildContext {
  Future<T?> showHufDrawer<T>({required HUFShowDrawerOptions options}) {
    return hufShowDrawer<T>(this, options: options);
  }

  void dismissHufDrawer<T>([T? result]) {
    Navigator.of(this).pop(result);
  }
}

class _HUFDrawerDialogBody extends StatelessWidget {
  const _HUFDrawerDialogBody({
    required this.openFrom,
    required this.isFullWidth,
    required this.content,
    required this.onClose,
    this.width,
    this.height,
  });

  final HUFDrawerOpenFrom openFrom;
  final bool isFullWidth;
  final List<Widget> content;
  final VoidCallback onClose;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final panel = HUFDrawerPanel(
      openFrom: openFrom,
      content: content,
      onClose: onClose,
      isFullWidth: isFullWidth,
      width: width,
      height: height,
      showCloseButton: isFullWidth,
    );

    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          Positioned(
            left: switch (openFrom) {
              HUFDrawerOpenFrom.right => null,
              _ => 0.0,
            },
            right: switch (openFrom) {
              HUFDrawerOpenFrom.left => null,
              _ => 0.0,
            },
            top: openFrom == HUFDrawerOpenFrom.bottom ? null : 0,
            bottom: 0,
            child: panel,
          ),
        ],
      ),
    );
  }
}
