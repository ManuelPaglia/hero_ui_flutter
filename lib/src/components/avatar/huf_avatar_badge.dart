import 'package:flutter/material.dart';

import 'huf_avatar_badge_color.dart';
import 'huf_avatar_badge_placement.dart';

/// Configurazione del badge di [HUFAvatar].
///
/// Dot, icona, numero o testo breve (es. `New`, `Old`). Tutte le varianti
/// compatte condividono la stessa dimensione base, scalata con [HUFAvatarSize].
class HUFAvatarBadge {
  const HUFAvatarBadge({
    this.content,
    this.icon,
    this.color = HUFAvatarBadgeColor.success,
    this.placement = HUFAvatarBadgePlacement.topRight,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
  }) : assert(
          icon == null || content == null,
          'Specificare content o icon, non entrambi',
        );

  /// Dot indicator senza contenuto.
  const HUFAvatarBadge.dot({
    this.color = HUFAvatarBadgeColor.success,
    this.placement = HUFAvatarBadgePlacement.topRight,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
  })  : content = null,
        icon = null;

  /// Badge con icona.
  const HUFAvatarBadge.icon(
    this.icon, {
    this.color = HUFAvatarBadgeColor.success,
    this.placement = HUFAvatarBadgePlacement.topRight,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
  }) : content = null;

  /// Badge numerico (conteggio notifiche).
  const HUFAvatarBadge.count(
    int this.content, {
    this.color = HUFAvatarBadgeColor.danger,
    this.placement = HUFAvatarBadgePlacement.topRight,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
  }) : icon = null;

  /// Badge testuale (pill con stessa altezza del dot).
  const HUFAvatarBadge.label(
    String this.content, {
    this.color = HUFAvatarBadgeColor.accent,
    this.placement = HUFAvatarBadgePlacement.topRight,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
  }) : icon = null;

  /// Etichetta predefinita «New».
  static const HUFAvatarBadge newLabel = HUFAvatarBadge.label('New');

  /// Etichetta predefinita «Old».
  static const HUFAvatarBadge oldLabel = HUFAvatarBadge.label('Old');

  final Object? content;
  final Widget? icon;
  final HUFAvatarBadgeColor color;
  final HUFAvatarBadgePlacement placement;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
}
