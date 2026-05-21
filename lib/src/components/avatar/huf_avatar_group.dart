import 'package:flutter/material.dart';

import '../../layout/huf_shrink_wrap_width.dart';
import '../../theme/huf_theme.dart';
import 'huf_avatar.dart';
import 'huf_avatar_color.dart';
import 'huf_avatar_size.dart';
import 'huf_avatar_style.dart';
import 'huf_avatar_variant.dart';

/// Gruppo di [HUFAvatar] sovrapposti orizzontalmente.
///
/// Con [max] limita gli avatar visibili: mostra al massimo `max - 1` avatar
/// seguiti da un contatore `+N` con il numero di elementi rimanenti.
class HUFAvatarGroup extends StatelessWidget {
  const HUFAvatarGroup({
    super.key,
    required this.children,
    this.max,
    this.size = HUFAvatarSize.medium,
    this.color = HUFAvatarColor.defaultColor,
    this.variant = HUFAvatarVariant.defaultVariant,
    this.overlap,
    this.ringWidth,
    this.ringColor,
    this.overflowBackgroundColor,
    this.overflowForegroundColor,
  }) : assert(children.length > 0, 'Fornire almeno un avatar');

  final List<HUFAvatar> children;
  final int? max;
  final HUFAvatarSize size;
  final HUFAvatarColor color;
  final HUFAvatarVariant variant;
  final double? overlap;
  final double? ringWidth;
  final Color? ringColor;
  final Color? overflowBackgroundColor;
  final Color? overflowForegroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = context.hufTheme;
    final metrics = hufAvatarMetricsFor(size, theme.borderRadius);
    final effectiveOverlap = overlap ?? metrics.defaultOverlap;
    final effectiveRingWidth = ringWidth ?? metrics.defaultRingWidth;
    final effectiveRingColor = ringColor ?? theme.colors.background;
    final step = metrics.diameter - effectiveOverlap;

    final total = children.length;
    final limit = max;
    final hasOverflow = limit != null && total > limit;
    final visibleCount = hasOverflow ? limit - 1 : total;
    final remaining = hasOverflow ? total - visibleCount : 0;
    final itemCount = visibleCount + (hasOverflow ? 1 : 0);

    final visibleAvatars = children.take(visibleCount).toList();

    return HUFShrinkWrapWidth(
      child: SizedBox(
        width: metrics.diameter + (itemCount - 1) * step,
        height: metrics.diameter,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            for (var i = 0; i < visibleAvatars.length; i++)
              Positioned(
                left: i * step,
                child: _buildAvatar(
                  visibleAvatars[i],
                  ringColor: effectiveRingColor,
                  ringWidth: effectiveRingWidth,
                ),
              ),
            if (hasOverflow)
              Positioned(
                left: visibleCount * step,
                child: _buildAvatar(
                  _overflowAvatar(context, remaining),
                  ringColor: effectiveRingColor,
                  ringWidth: effectiveRingWidth,
                ),
              ),
          ],
        ),
      ),
    );
  }

  HUFAvatar _overflowAvatar(BuildContext context, int remaining) {
    final theme = context.hufTheme;
    final overflowColors = hufAvatarOverflowColorsFor(theme.colors);

    return HUFAvatar(
      size: size,
      initials: '+$remaining',
      backgroundColor:
          overflowBackgroundColor ?? overflowColors.background,
      foregroundColor:
          overflowForegroundColor ?? overflowColors.foreground,
    );
  }

  Widget _buildAvatar(
    HUFAvatar avatar, {
    required Color ringColor,
    required double ringWidth,
  }) {
    return HUFAvatar(
      size: size,
      color: color,
      variant: variant,
      image: avatar.image,
      initials: avatar.initials,
      icon: avatar.icon,
      backgroundColor: avatar.backgroundColor,
      foregroundColor: avatar.foregroundColor,
      ringColor: ringColor,
      ringWidth: ringWidth,
      semanticsLabel: avatar.semanticsLabel,
    );
  }
}
