import 'package:flutter/material.dart';

import '../../theme/huf_theme.dart';
import 'huf_separator_orientation.dart';
import 'huf_separator_style.dart';
import 'huf_separator_variant.dart';

/// Separatore visivo del design system Hero UI Flutter.
///
/// Divide sezioni di contenuto in layout orizzontale o verticale.
/// Il colore deriva dai token del tema ([HUFThemeColors.border] e varianti
/// più tenue su [HUFThemeColors.cardMutedForeground]).
///
/// **Orizzontale:** larghezza piena del genitore, altezza [kHufSeparatorThickness].
///
/// **Verticale:** altezza piena del genitore, larghezza [kHufSeparatorThickness].
/// In una [Row] con altezza fissa (es. link di navigazione) il separatore
/// segue l'altezza del contenitore.
class HUFSeparator extends StatelessWidget {
  const HUFSeparator({
    super.key,
    this.orientation = HUFSeparatorOrientation.horizontal,
    this.variant = HUFSeparatorVariant.defaultVariant,
  });

  final HUFSeparatorOrientation orientation;
  final HUFSeparatorVariant variant;

  @override
  Widget build(BuildContext context) {
    final color = hufSeparatorColorFor(context.hufTheme.colors, variant);

    return switch (orientation) {
      HUFSeparatorOrientation.horizontal => SizedBox(
          width: double.infinity,
          height: kHufSeparatorThickness,
          child: ColoredBox(color: color),
        ),
      HUFSeparatorOrientation.vertical => SizedBox(
          width: kHufSeparatorThickness,
          height: double.infinity,
          child: ColoredBox(color: color),
        ),
    };
  }
}
