import 'package:flutter/material.dart';

import '../components/alert/huf_alert.dart';
import '../components/alert/huf_alert_color.dart';
import '../components/alert/huf_alert_position.dart';
import '../components/alert/huf_alert_size.dart';
/// Dati per un alert mostrato nell'overlay globale.
@immutable
class HUFAlertOverlayEntry {
  const HUFAlertOverlayEntry({
    required this.id,
    required this.position,
    required this.margin,
    required this.duration,
    required this.alert,
    this.onDismissed,
  });

  final String id;
  final HUFAlertPosition position;
  final EdgeInsets margin;
  final Duration? duration;
  final HUFAlert alert;
  final VoidCallback? onDismissed;
}

/// Scope che ospita gli alert in overlay (angoli dello schermo, senza scrim).
///
/// Avvolgi l'app nel [MaterialApp.builder]:
///
/// ```dart
/// MaterialApp(
///   builder: (context, child) => HUFAlertOverlay(child: child!),
/// );
/// ```
class HUFAlertOverlay extends StatefulWidget {
  const HUFAlertOverlay({
    super.key,
    required this.child,
  });

  final Widget child;

  static HUFAlertOverlayState? maybeOf(BuildContext context) {
    return context.findAncestorStateOfType<HUFAlertOverlayState>();
  }

  @override
  State<HUFAlertOverlay> createState() => HUFAlertOverlayState();
}

class HUFAlertOverlayState extends State<HUFAlertOverlay> {
  final _entries = <HUFAlertOverlayEntry>[];

  List<HUFAlertOverlayEntry> get entries => List.unmodifiable(_entries);

  void insert(HUFAlertOverlayEntry entry) {
    setState(() => _entries.add(entry));
    if (entry.duration != null) {
      Future<void>.delayed(entry.duration!, () {
        if (!mounted) return;
        dismiss(entry.id);
      });
    }
  }

  void dismiss(String id) {
    final index = _entries.indexWhere((e) => e.id == id);
    if (index < 0) return;
    final entry = _entries.removeAt(index);
    setState(() {});
    entry.onDismissed?.call();
  }

  void dismissAll() {
    if (_entries.isEmpty) return;
    final callbacks = _entries.map((e) => e.onDismissed).toList();
    _entries.clear();
    setState(() {});
    for (final callback in callbacks) {
      callback?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        widget.child,
        for (final entry in _entries)
          _PositionedAlert(
            key: ValueKey(entry.id),
            entry: entry,
            onDismiss: () => dismiss(entry.id),
          ),
      ],
    );
  }
}

class _PositionedAlert extends StatelessWidget {
  const _PositionedAlert({
    super.key,
    required this.entry,
    required this.onDismiss,
  });

  final HUFAlertOverlayEntry entry;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final safe = media.padding;
    final margin = entry.margin;

    final slideBegin = switch (entry.position) {
      HUFAlertPosition.topLeft => const Offset(-0.08, -0.04),
      HUFAlertPosition.topRight => const Offset(0.08, -0.04),
      HUFAlertPosition.bottomLeft => const Offset(-0.08, 0.04),
      HUFAlertPosition.bottomRight => const Offset(0.08, 0.04),
    };

    final alert = _bindDismiss(entry.alert, onDismiss);

    final inset = EdgeInsets.only(
      left: safe.left + margin.left,
      top: safe.top + margin.top,
      right: safe.right + margin.right,
      bottom: safe.bottom + margin.bottom,
    );

    return Positioned(
      left: switch (entry.position) {
        HUFAlertPosition.topLeft || HUFAlertPosition.bottomLeft => inset.left,
        _ => null,
      },
      right: switch (entry.position) {
        HUFAlertPosition.topRight || HUFAlertPosition.bottomRight => inset.right,
        _ => null,
      },
      top: switch (entry.position) {
        HUFAlertPosition.topLeft || HUFAlertPosition.topRight => inset.top,
        _ => null,
      },
      bottom: switch (entry.position) {
        HUFAlertPosition.bottomLeft ||
        HUFAlertPosition.bottomRight =>
          inset.bottom,
        _ => null,
      },
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(
                slideBegin.dx * (1 - value) * 80,
                slideBegin.dy * (1 - value) * 40,
              ),
              child: child,
            ),
          );
        },
        child: Material(
          type: MaterialType.transparency,
          child: alert,
        ),
      ),
    );
  }

  HUFAlert _bindDismiss(HUFAlert alert, VoidCallback onDismiss) {
    return HUFAlert(
      leading: alert.leading,
      icon: alert.icon,
      isLoading: alert.isLoading,
      title: alert.title,
      description: alert.description,
      content: alert.content,
      action: alert.action,
      trailing: alert.trailing,
      showCloseButton: alert.showCloseButton,
      onDismiss: () {
        alert.onDismiss?.call();
        onDismiss();
      },
      color: alert.color,
      size: alert.size,
    );
  }
}

/// Configurazione per [hufShowAlert].
@immutable
class HUFShowAlertOptions {
  const HUFShowAlertOptions({
    this.id,
    this.position = HUFAlertPosition.topRight,
    this.margin = const EdgeInsets.all(16),
    this.duration,
    this.onDismissed,
    this.leading,
    this.icon,
    this.isLoading = false,
    this.title,
    this.description,
    this.content,
    this.action,
    this.trailing,
    this.showCloseButton = true,
    this.onDismiss,
    this.color = HUFAlertColor.accent,
    this.size = HUFAlertSize.medium,
  });

  final String? id;
  final HUFAlertPosition position;
  final EdgeInsets margin;
  final Duration? duration;
  final VoidCallback? onDismissed;
  final Widget? leading;
  final Widget? icon;
  final bool isLoading;
  final String? title;
  final String? description;
  final Widget? content;
  final HUFAlertAction? action;
  final Widget? trailing;
  final bool showCloseButton;
  final VoidCallback? onDismiss;
  final HUFAlertColor color;
  final HUFAlertSize size;

  HUFAlert toAlert() {
    return HUFAlert(
      leading: leading,
      icon: icon,
      isLoading: isLoading,
      title: title,
      description: description,
      content: content,
      action: action,
      trailing: trailing,
      showCloseButton: showCloseButton,
      onDismiss: onDismiss,
      color: color,
      size: size,
    );
  }
}

