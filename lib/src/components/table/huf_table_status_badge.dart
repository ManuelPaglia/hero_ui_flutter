import 'package:flutter/material.dart';

import '../../theme/huf_theme.dart';

/// Stato semantico per [HUFTableStatusBadge].
enum HUFTableStatusTone {
  active,
  inactive,
  onLeave,
  custom,
}

/// Badge pill per celle stato in [HUFTable].
class HUFTableStatusBadge extends StatelessWidget {
  const HUFTableStatusBadge({
    super.key,
    required this.label,
    this.tone = HUFTableStatusTone.custom,
    this.backgroundColor,
    this.foregroundColor,
  });

  final String label;
  final HUFTableStatusTone tone;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final palette = context.hufTheme.colors;
    final resolved = _resolveColors(palette);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: resolved.background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Text(
          label,
          style: TextStyle(
            color: resolved.foreground,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
        ),
      ),
    );
  }

  ({Color background, Color foreground}) _resolveColors(HUFThemeColors palette) {
    if (backgroundColor != null && foregroundColor != null) {
      return (background: backgroundColor!, foreground: foregroundColor!);
    }

    return switch (tone) {
      HUFTableStatusTone.active => (
          background: palette.success.withValues(alpha: 0.18),
          foreground: palette.success,
        ),
      HUFTableStatusTone.inactive => (
          background: palette.dangerSoft,
          foreground: palette.dangerSoftForeground,
        ),
      HUFTableStatusTone.onLeave => (
          background: palette.warning.withValues(alpha: 0.18),
          foreground: palette.warning,
        ),
      HUFTableStatusTone.custom => (
          background: palette.secondary,
          foreground: palette.secondaryForeground,
        ),
    };
  }
}
