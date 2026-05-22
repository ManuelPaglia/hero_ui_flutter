import 'dart:async';

import 'package:flutter/material.dart';

import '../components/alert/huf_alert_color.dart';
import '../components/toast/huf_toast.dart';
import '../components/toast/huf_toast_position.dart';

/// Dati per un toast mostrato nell'overlay globale.
@immutable
class HUFToastOverlayEntry {
  const HUFToastOverlayEntry({
    required this.id,
    required this.position,
    required this.margin,
    required this.duration,
    required this.toast,
    this.onDismissed,
  });

  final String id;
  final HUFToastPosition position;
  final EdgeInsets margin;
  final Duration? duration;
  final HUFToast toast;
  final VoidCallback? onDismissed;
}

/// Scope che ospita i toast in overlay (centro alto / centro basso, senza scrim).
///
/// Avvolgi l'app nel [MaterialApp.builder] (può convivere con [HUFAlertOverlay]):
///
/// ```dart
/// MaterialApp(
///   builder: (context, child) => HUFToastOverlay(
///     child: HUFAlertOverlay(child: child!),
///   ),
/// );
/// ```
class HUFToastOverlay extends StatefulWidget {
  const HUFToastOverlay({
    super.key,
    required this.child,
  });

  final Widget child;

  static HUFToastOverlayState? maybeOf(BuildContext context) {
    return context.findAncestorStateOfType<HUFToastOverlayState>();
  }

  @override
  State<HUFToastOverlay> createState() => HUFToastOverlayState();
}

class HUFToastOverlayState extends State<HUFToastOverlay> {
  final _entries = <HUFToastOverlayEntry>[];
  final _exitHandlers = <String, VoidCallback>{};

  List<HUFToastOverlayEntry> get entries => List.unmodifiable(_entries);

  void insert(HUFToastOverlayEntry entry) {
    setState(() => _entries.add(entry));
  }

  void _registerExit(String id, VoidCallback exit) {
    _exitHandlers[id] = exit;
  }

  void _unregisterExit(String id) {
    _exitHandlers.remove(id);
  }

  void dismiss(String id) {
    final exit = _exitHandlers[id];
    if (exit != null) {
      exit();
      return;
    }
    _removeEntry(id);
  }

  void _removeEntry(String id) {
    final index = _entries.indexWhere((e) => e.id == id);
    if (index < 0) return;
    final entry = _entries.removeAt(index);
    _exitHandlers.remove(id);
    setState(() {});
    entry.onDismissed?.call();
  }

  void dismissAll() {
    if (_entries.isEmpty) return;
    final ids = _entries.map((e) => e.id).toList();
    for (final id in ids) {
      dismiss(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        widget.child,
        for (final entry in _entries)
          _PositionedToast(
            key: ValueKey(entry.id),
            entry: entry,
            onRegisterExit: (exit) => _registerExit(entry.id, exit),
            onUnregisterExit: () => _unregisterExit(entry.id),
            onDismiss: () => _removeEntry(entry.id),
          ),
      ],
    );
  }
}

class _PositionedToast extends StatelessWidget {
  const _PositionedToast({
    super.key,
    required this.entry,
    required this.onRegisterExit,
    required this.onUnregisterExit,
    required this.onDismiss,
  });

  final HUFToastOverlayEntry entry;
  final ValueChanged<VoidCallback> onRegisterExit;
  final VoidCallback onUnregisterExit;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final safe = media.padding;
    final margin = entry.margin;

    final inset = EdgeInsets.only(
      left: safe.left + margin.left,
      top: safe.top + margin.top,
      right: safe.right + margin.right,
      bottom: safe.bottom + margin.bottom,
    );

    return Positioned(
      left: inset.left,
      right: inset.right,
      top: entry.position == HUFToastPosition.topCenter ? inset.top : null,
      bottom:
          entry.position == HUFToastPosition.bottomCenter ? inset.bottom : null,
      child: Align(
        alignment: entry.position == HUFToastPosition.topCenter
            ? Alignment.topCenter
            : Alignment.bottomCenter,
        child: _AnimatedToast(
          position: entry.position,
          duration: entry.duration,
          onRegisterExit: onRegisterExit,
          onUnregisterExit: onUnregisterExit,
          onDismiss: onDismiss,
          child: entry.toast,
        ),
      ),
    );
  }
}

class _AnimatedToast extends StatefulWidget {
  const _AnimatedToast({
    required this.position,
    required this.duration,
    required this.onRegisterExit,
    required this.onUnregisterExit,
    required this.onDismiss,
    required this.child,
  });

  final HUFToastPosition position;
  final Duration? duration;
  final ValueChanged<VoidCallback> onRegisterExit;
  final VoidCallback onUnregisterExit;
  final VoidCallback onDismiss;
  final HUFToast child;

  @override
  State<_AnimatedToast> createState() => _AnimatedToastState();
}

class _AnimatedToastState extends State<_AnimatedToast>
    with SingleTickerProviderStateMixin {
  static const _enterDuration = Duration(milliseconds: 280);
  static const _exitDuration = Duration(milliseconds: 200);

  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<double> _slide;
  bool _exiting = false;
  Timer? _autoDismissTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _enterDuration,
      reverseDuration: _exitDuration,
    );
    _opacity = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );
    _slide = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    widget.onRegisterExit(_exit);
    _controller.forward();

    final duration = widget.duration;
    if (duration != null) {
      _autoDismissTimer = Timer(duration, () {
        if (mounted) _exit();
      });
    }
  }

  @override
  void dispose() {
    _autoDismissTimer?.cancel();
    widget.onUnregisterExit();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _exit() async {
    if (_exiting || !mounted) return;
    _exiting = true;
    _autoDismissTimer?.cancel();
    _autoDismissTimer = null;
    await _controller.reverse();
    if (mounted) widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) {
    final slideOffset = switch (widget.position) {
      HUFToastPosition.topCenter => -24.0,
      HUFToastPosition.bottomCenter => 24.0,
    };

    return FadeTransition(
      opacity: _opacity,
      child: AnimatedBuilder(
        animation: _slide,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, slideOffset * (1 - _slide.value)),
            child: child,
          );
        },
        child: Material(
          type: MaterialType.transparency,
          child: widget.child,
        ),
      ),
    );
  }
}

/// Configurazione per [hufShowToast].
@immutable
class HUFShowToastOptions {
  const HUFShowToastOptions({
    this.id,
    this.position = HUFToastPosition.bottomCenter,
    this.margin = const EdgeInsets.all(16),
    this.durationSeconds,
    this.onDismissed,
    this.leading,
    this.icon,
    this.isLoading = false,
    required this.title,
    this.description,
    this.action,
    this.trailing,
    this.color = HUFAlertColor.defaultColor,
  });

  final String? id;
  final HUFToastPosition position;
  final EdgeInsets margin;

  /// Durata in secondi prima della scomparsa con fade; `null` = persistente.
  final double? durationSeconds;

  final VoidCallback? onDismissed;
  final Widget? leading;
  final Widget? icon;
  final bool isLoading;
  final String title;
  final String? description;
  final HUFToastAction? action;
  final Widget? trailing;
  final HUFAlertColor color;

  Duration? get duration => durationSeconds != null
      ? Duration(
          milliseconds: (durationSeconds! * 1000).round(),
        )
      : null;

  HUFToast toToast() {
    return HUFToast(
      leading: leading,
      icon: icon,
      isLoading: isLoading,
      title: title,
      description: description,
      action: action,
      trailing: trailing,
      color: color,
    );
  }
}
