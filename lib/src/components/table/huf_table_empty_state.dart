import 'package:flutter/material.dart';

import '../../theme/huf_theme.dart';
import 'huf_table_style.dart';

/// Stato vuoto predefinito per [HUFTable].
class HUFTableEmptyState extends StatelessWidget {
  const HUFTableEmptyState({
    super.key,
    this.message = 'No results found',
    this.icon = Icons.inbox_outlined,
    this.minHeight = 200,
  });

  final String message;
  final IconData icon;
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    final theme = context.hufTheme;
    final metrics = hufTableMetricsFor(theme.borderRadius);
    final colors = hufTableColorsFor(theme.colors);

    return SizedBox(
      height: minHeight,
      width: double.infinity,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: metrics.emptyStateIconSize,
              color: colors.emptyStateColor,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: TextStyle(
                color: colors.emptyStateColor,
                fontSize: metrics.headerFontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
