import 'package:flutter/material.dart';

import '../../layout/huf_shrink_wrap_width.dart';
import '../../theme/huf_theme.dart';
import 'huf_avatar_badge.dart';
import 'huf_avatar_badge_placement.dart';
import 'huf_avatar_color.dart';
import 'huf_avatar_size.dart';
import 'huf_avatar_style.dart';
import 'huf_avatar_variant.dart';

/// Avatar del design system Hero UI Flutter.
///
/// Mostra un'immagine, fino a due iniziali oppure un'icona di fallback.
/// Il border radius segue [HUFBorderRadius] del tema (limitato a metà lato).
/// Supporta un badge opzionale ([HUFAvatarBadge]) per dot, conteggi o etichette.
/// Per avatar sovrapposti usa [HUFAvatarGroup].
class HUFAvatar extends StatelessWidget {
  const HUFAvatar({
    super.key,
    this.size = HUFAvatarSize.medium,
    this.color = HUFAvatarColor.defaultColor,
    this.variant = HUFAvatarVariant.defaultVariant,
    this.image,
    this.initials,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.ringColor,
    this.ringWidth = 0,
    this.badge,
    this.semanticsLabel,
  }) : assert(
          image != null || initials != null || icon != null,
          'Fornire image, initials o icon',
        );

  final HUFAvatarSize size;
  final HUFAvatarColor color;
  final HUFAvatarVariant variant;
  final ImageProvider? image;
  final String? initials;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? ringColor;
  final double ringWidth;
  final HUFAvatarBadge? badge;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final theme = context.hufTheme;
    final metrics = hufAvatarMetricsFor(size, theme.borderRadius);
    final fallbackColors = hufAvatarFallbackColorsFor(
      theme.colors,
      color,
      variant,
    );

    final bg = backgroundColor ?? fallbackColors.background;
    final fg = foregroundColor ?? fallbackColors.foreground;
    final ring = ringColor ?? theme.colors.background;
    final shapeRadius = BorderRadius.circular(metrics.borderRadius);

    final content = image != null
        ? _ImageContent(image: image!)
        : _FallbackContent(
            initials: _normalizedInitials(initials),
            icon: icon,
            foreground: fg,
            fontSize: metrics.fontSize,
            iconSize: metrics.iconSize,
          );

    final avatarBody = SizedBox.square(
      dimension: metrics.diameter,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: image != null ? null : bg,
          borderRadius: shapeRadius,
          border: ringWidth > 0
              ? Border.all(color: ring, width: ringWidth)
              : null,
        ),
        child: ClipRRect(
          borderRadius: shapeRadius,
          child: content,
        ),
      ),
    );

    final avatar = badge == null
        ? avatarBody
        : _BadgedAvatar(
            avatar: avatarBody,
            badge: badge!,
            size: size,
            theme: theme,
          );

    final wrapped = HUFShrinkWrapWidth(child: avatar);

    if (semanticsLabel == null) {
      return wrapped;
    }

    return Semantics(
      label: semanticsLabel,
      image: image != null,
      child: wrapped,
    );
  }

  static String? _normalizedInitials(String? value) {
    if (value == null || value.isEmpty) return null;
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    return trimmed.length <= 2
        ? trimmed.toUpperCase()
        : trimmed.substring(0, 2).toUpperCase();
  }
}

class _BadgedAvatar extends StatelessWidget {
  const _BadgedAvatar({
    required this.avatar,
    required this.badge,
    required this.size,
    required this.theme,
  });

  final Widget avatar;
  final HUFAvatarBadge badge;
  final HUFAvatarSize size;
  final HUFTheme theme;

  @override
  Widget build(BuildContext context) {
    final badgeMetrics = hufAvatarBadgeMetricsFor(size);
    final padding = hufAvatarBadgePaddingFor(
      badge.placement,
      badgeMetrics.outwardOffset,
    );
    final protrusion = badgeMetrics.outwardOffset;

    return Padding(
      padding: padding,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          avatar,
          Positioned(
            top: _isTop(badge.placement) ? -protrusion : null,
            bottom: _isBottom(badge.placement) ? -protrusion : null,
            left: _isLeft(badge.placement) ? -protrusion : null,
            right: _isRight(badge.placement) ? -protrusion : null,
            child: _AvatarBadgeView(
              badge: badge,
              metrics: badgeMetrics,
              theme: theme,
            ),
          ),
        ],
      ),
    );
  }

  bool _isTop(HUFAvatarBadgePlacement placement) =>
      placement == HUFAvatarBadgePlacement.topRight ||
      placement == HUFAvatarBadgePlacement.topLeft;

  bool _isBottom(HUFAvatarBadgePlacement placement) =>
      placement == HUFAvatarBadgePlacement.bottomRight ||
      placement == HUFAvatarBadgePlacement.bottomLeft;

  bool _isLeft(HUFAvatarBadgePlacement placement) =>
      placement == HUFAvatarBadgePlacement.topLeft ||
      placement == HUFAvatarBadgePlacement.bottomLeft;

  bool _isRight(HUFAvatarBadgePlacement placement) =>
      placement == HUFAvatarBadgePlacement.topRight ||
      placement == HUFAvatarBadgePlacement.bottomRight;
}

class _AvatarBadgeView extends StatelessWidget {
  const _AvatarBadgeView({
    required this.badge,
    required this.metrics,
    required this.theme,
  });

  final HUFAvatarBadge badge;
  final HUFAvatarBadgeMetrics metrics;
  final HUFTheme theme;

  @override
  Widget build(BuildContext context) {
    final colors = hufAvatarBadgeColorsFor(theme.colors, badge.color);
    final background = badge.backgroundColor ?? colors.background;
    final foreground = badge.foregroundColor ?? colors.foreground;
    final borderColor = badge.borderColor ?? theme.colors.background;
    final isLabel = badge.content is String && badge.icon == null;
    final shapeRadius = BorderRadius.circular(metrics.size / 2);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: shapeRadius,
        border: Border.all(color: borderColor, width: metrics.borderWidth),
      ),
      child: isLabel
          ? ConstrainedBox(
              constraints: BoxConstraints(minHeight: metrics.size),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: metrics.horizontalPadding,
                ),
                child: Center(
                  child: Text(
                    badge.content! as String,
                    style: TextStyle(
                      color: foreground,
                      fontSize: metrics.fontSize,
                      fontWeight: FontWeight.w600,
                      height: 1,
                    ),
                  ),
                ),
              ),
            )
          : SizedBox.square(
              dimension: metrics.size,
              child: Center(child: _badgeInner(foreground)),
            ),
    );
  }

  Widget _badgeInner(Color foreground) {
    if (badge.icon != null) {
      return IconTheme(
        data: IconThemeData(
          color: foreground,
          size: metrics.iconSize,
        ),
        child: badge.icon!,
      );
    }

    if (badge.content == null) {
      return const SizedBox.shrink();
    }

    return Text(
      _badgeLabel(badge.content)!,
      style: TextStyle(
        color: foreground,
        fontSize: metrics.fontSize,
        fontWeight: FontWeight.w600,
        height: 1,
      ),
    );
  }

  String? _badgeLabel(Object? content) {
    if (content == null) return null;
    return switch (content) {
      int value => '$value',
      String value => value,
      _ => content.toString(),
    };
  }
}

class _ImageContent extends StatelessWidget {
  const _ImageContent({required this.image});

  final ImageProvider image;

  @override
  Widget build(BuildContext context) {
    return Image(
      image: image,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => const SizedBox.expand(),
    );
  }
}

class _FallbackContent extends StatelessWidget {
  const _FallbackContent({
    required this.initials,
    required this.icon,
    required this.foreground,
    required this.fontSize,
    required this.iconSize,
  });

  final String? initials;
  final Widget? icon;
  final Color foreground;
  final double fontSize;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    if (initials != null) {
      return Center(
        child: Text(
          initials!,
          style: TextStyle(
            color: foreground,
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            height: 1,
          ),
        ),
      );
    }

    return Center(
      child: IconTheme(
        data: IconThemeData(color: foreground, size: iconSize),
        child: icon!,
      ),
    );
  }
}
