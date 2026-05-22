import 'package:flutter/material.dart';

import '../components/alert/huf_alert_color.dart';
import '../components/alert_dialog/huf_alert_dialog.dart';
import '../components/alert_dialog/huf_alert_dialog_position.dart';
import '../components/alert_dialog/huf_alert_dialog_style.dart';
import '../theme/huf_theme.dart';

export '../components/alert_dialog/huf_alert_dialog_position.dart'
    show HUFAlertDialogPosition;

/// Opzioni per [hufShowAlertDialog]; corrispondono alle proprietà di
/// [HUFAlertDialog] più posizione e barriera.
@immutable
class HUFShowAlertDialogOptions {
  const HUFShowAlertDialogOptions({
    this.leading,
    this.icon,
    this.isLoading = false,
    this.title,
    this.description,
    this.content,
    this.actions = const [],
    this.onDismissed,
    this.color = HUFAlertColor.defaultColor,
    this.position = HUFAlertDialogPosition.center,
    this.barrierDismissible = false,
    this.barrierColor,
  });

  final Widget? leading;
  final Widget? icon;
  final bool isLoading;
  final String? title;
  final String? description;
  final Widget? content;
  final List<Widget> actions;
  final VoidCallback? onDismissed;
  final HUFAlertColor color;
  final HUFAlertDialogPosition position;
  final bool barrierDismissible;
  final Color? barrierColor;

  HUFAlertDialog toDialog({required VoidCallback onDismiss}) {
    return HUFAlertDialog(
      leading: leading,
      icon: icon,
      isLoading: isLoading,
      title: title,
      description: description,
      content: content,
      actions: actions,
      onDismiss: onDismiss,
      color: color,
    );
  }
}

/// Mostra [HUFAlertDialog] con overlay scuro e transizione fade.
///
/// Passa [dialog] già costruito oppure [options] per crearlo automaticamente.
Future<T?> hufShowAlertDialog<T>(
  BuildContext context, {
  HUFShowAlertDialogOptions? options,
  HUFAlertDialog? dialog,
  HUFAlertDialogPosition? position,
  bool? barrierDismissible,
  Color? barrierColor,
}) {
  assert(
    options != null || dialog != null,
    'Specificare options o dialog.',
  );

  final resolvedOptions = options ?? const HUFShowAlertDialogOptions();
  final resolvedPosition = position ?? resolvedOptions.position;
  final resolvedBarrierDismissible =
      barrierDismissible ?? resolvedOptions.barrierDismissible;
  final resolvedBarrierColor = barrierColor ?? resolvedOptions.barrierColor;

  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: resolvedBarrierDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: resolvedBarrierColor ?? const Color(0xB3000000),
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (dialogContext, animation, secondaryAnimation) {
      final alertDialog = dialog ?? resolvedOptions.toDialog(onDismiss: () {});

      void dismiss() {
        Navigator.of(dialogContext).pop();
        if (dialog != null) {
          alertDialog.onDismiss();
        }
        resolvedOptions.onDismissed?.call();
      }

      return _HUFAlertDialogScaffold(
        position: resolvedPosition,
        child: HUFAlertDialog(
          leading: alertDialog.leading,
          icon: alertDialog.icon,
          isLoading: alertDialog.isLoading,
          title: alertDialog.title,
          description: alertDialog.description,
          content: alertDialog.content,
          actions: alertDialog.actions,
          color: alertDialog.color,
          onDismiss: dismiss,
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        ),
        child: child,
      );
    },
  );
}

/// Chiude il dialog modale corrente se aperto con [hufShowAlertDialog].
void hufDismissAlertDialog<T>(BuildContext context, [T? result]) {
  Navigator.of(context).pop(result);
}

extension HUFAlertDialogContext on BuildContext {
  Future<T?> showHufAlertDialog<T>({
    HUFShowAlertDialogOptions? options,
    HUFAlertDialog? dialog,
    HUFAlertDialogPosition? position,
    bool? barrierDismissible,
    Color? barrierColor,
  }) {
    return hufShowAlertDialog<T>(
      this,
      options: options,
      dialog: dialog,
      position: position,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
    );
  }

  void dismissHufAlertDialog<T>([T? result]) {
    hufDismissAlertDialog<T>(this, result);
  }
}

class _HUFAlertDialogScaffold extends StatelessWidget {
  const _HUFAlertDialogScaffold({
    required this.position,
    required this.child,
  });

  final HUFAlertDialogPosition position;
  final HUFAlertDialog child;

  @override
  Widget build(BuildContext context) {
    final metrics = hufAlertDialogMetricsFor(context.hufTheme.borderRadius);
    final margin = metrics.viewportMargin;

    final alignment = switch (position) {
      HUFAlertDialogPosition.center => Alignment.center,
      HUFAlertDialogPosition.top => Alignment.topCenter,
      HUFAlertDialogPosition.bottom => Alignment.bottomCenter,
    };

    return SafeArea(
      child: Align(
        alignment: alignment,
        child: Padding(
          padding: margin,
          child: child,
        ),
      ),
    );
  }
}
