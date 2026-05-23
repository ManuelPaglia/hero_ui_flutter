import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/huf_theme.dart';
import 'huf_table_style.dart';

/// Footer di paginazione per [HUFTable].
class HUFTablePaginationFooter extends StatelessWidget {
  const HUFTablePaginationFooter({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.pageSize,
    this.onPageChanged,
    this.resultsLabelBuilder,
  }) : assert(currentPage >= 1),
       assert(totalPages >= 1),
       assert(pageSize > 0);

  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int pageSize;
  final ValueChanged<int>? onPageChanged;
  final String Function(int from, int to, int total)? resultsLabelBuilder;

  int get _from => totalItems == 0 ? 0 : (currentPage - 1) * pageSize + 1;

  int get _to {
    if (totalItems == 0) return 0;
    final end = currentPage * pageSize;
    return end > totalItems ? totalItems : end;
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.hufTheme;
    final metrics = hufTableMetricsFor(theme.borderRadius);
    final colors = hufTableColorsFor(theme.colors);
    final label = resultsLabelBuilder?.call(_from, _to, totalItems) ??
        '$_from to $_to of $totalItems results';

    final canGoPrev = currentPage > 1 && onPageChanged != null;
    final canGoNext = currentPage < totalPages && onPageChanged != null;
    final navButtonRadius = math.max(metrics.borderRadius / 2, 4.0);
    final pageButtonRadius = math.min(16.0, metrics.borderRadius);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: metrics.cellPaddingHorizontal,
        vertical: metrics.cellPaddingVertical,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: colors.footerTextColor,
                fontSize: metrics.footerFontSize,
              ),
            ),
          ),
          _NavButton(
            label: 'Prev',
            icon: Icons.chevron_left,
            iconOnStart: true,
            enabled: canGoPrev,
            foreground: colors.bodyTextColor,
            muted: colors.footerTextColor,
            borderRadius: navButtonRadius,
            onTap: canGoPrev ? () => onPageChanged!(currentPage - 1) : null,
          ),
          const SizedBox(width: 8),
          ...List.generate(totalPages, (index) {
            final page = index + 1;
            final isActive = page == currentPage;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: _PageNumber(
                page: page,
                isActive: isActive,
                activeColor: colors.rowSelectedColor,
                textColor: colors.bodyTextColor,
                mutedColor: colors.footerTextColor,
                borderRadius: pageButtonRadius,
                onTap: onPageChanged != null && !isActive
                    ? () => onPageChanged!(page)
                    : null,
              ),
            );
          }),
          const SizedBox(width: 8),
          _NavButton(
            label: 'Next',
            icon: Icons.chevron_right,
            enabled: canGoNext,
            foreground: colors.bodyTextColor,
            muted: colors.footerTextColor,
            borderRadius: navButtonRadius,
            onTap: canGoNext ? () => onPageChanged!(currentPage + 1) : null,
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.label,
    required this.icon,
    required this.enabled,
    required this.foreground,
    required this.muted,
    required this.borderRadius,
    this.iconOnStart = false,
    this.onTap,
  });

  final String label;
  final IconData icon;
  final bool iconOnStart;
  final bool enabled;
  final Color foreground;
  final Color muted;
  final double borderRadius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = enabled ? foreground : muted;
    final child = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (iconOnStart) ...[
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 4),
        ],
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (!iconOnStart) ...[
          const SizedBox(width: 4),
          Icon(icon, size: 18, color: color),
        ],
      ],
    );

    if (!enabled || onTap == null) {
      return Opacity(opacity: enabled ? 1 : 0.5, child: child);
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(borderRadius),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: child,
      ),
    );
  }
}

class _PageNumber extends StatelessWidget {
  const _PageNumber({
    required this.page,
    required this.isActive,
    required this.activeColor,
    required this.textColor,
    required this.mutedColor,
    required this.borderRadius,
    this.onTap,
  });

  final int page;
  final bool isActive;
  final Color activeColor;
  final Color textColor;
  final Color mutedColor;
  final double borderRadius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = SizedBox(
      width: 32,
      height: 32,
      child: Center(
        child: Text(
          '$page',
          style: TextStyle(
            color: isActive ? textColor : mutedColor,
            fontSize: 13,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );

    final shape = BorderRadius.circular(borderRadius);

    if (!isActive && onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: shape,
        child: content,
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isActive ? activeColor : null,
        borderRadius: shape,
      ),
      child: content,
    );
  }
}
