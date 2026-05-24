import 'package:flutter/material.dart';

import 'huf_skeleton_style.dart';

/// Rettangolo o cerchio placeholder usato internamente da [HUFSkeleton].
class HUFSkeletonBlock extends StatelessWidget {
  const HUFSkeletonBlock({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
  });

  const HUFSkeletonBlock.circle({
    super.key,
    required double dimension,
  })  : width = dimension,
        height = dimension,
        borderRadius = null,
        shape = BoxShape.circle;

  final double? width;
  final double? height;
  final double? borderRadius;
  final BoxShape shape;

  @override
  Widget build(BuildContext context) {
    final colors = HUFSkeletonScope.of(context);
    final radius = shape == BoxShape.circle
        ? null
        : BorderRadius.circular(borderRadius ?? 6);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: colors.base,
        shape: shape,
        borderRadius: radius,
      ),
    );
  }
}

/// Colori skeleton iniettati da [HUFSkeleton].
class HUFSkeletonScope extends InheritedWidget {
  const HUFSkeletonScope({
    super.key,
    required this.colors,
    required super.child,
  });

  final HUFSkeletonColors colors;

  static HUFSkeletonColors of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<HUFSkeletonScope>();
    assert(scope != null, 'HUFSkeletonBlock richiede un antenato HUFSkeleton.');
    return scope!.colors;
  }

  @override
  bool updateShouldNotify(HUFSkeletonScope oldWidget) {
    return colors.base != oldWidget.colors.base ||
        colors.highlight != oldWidget.colors.highlight;
  }
}
