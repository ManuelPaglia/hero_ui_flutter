import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/huf_theme.dart';
import 'huf_skeleton_animation.dart';
import 'huf_skeleton_block.dart';
import 'huf_skeleton_mapper.dart';
import 'huf_skeleton_style.dart';

export 'huf_skeleton_animation.dart';

/// Wrapper che sostituisce i componenti Hero UI con placeholder skeleton.
///
/// Imposta [active] a `true` per mostrare gli skeleton; con `false` (default)
/// viene renderizzato il [child] originale senza modifiche.
///
/// Il [child] può contenere uno o più widget del design system (anche dentro
/// [Column], [Row], [ListView], …): ogni componente `HUF*` riconosciuto viene
/// sostituito da un placeholder con dimensioni coerenti.
///
/// ```dart
/// HUFSkeleton(
///   active: isLoading,
///   animation: HUFSkeletonAnimation.shimmer,
///   child: Column(
///     children: [
///       HUFAvatar(initials: 'AB'),
///       HUFButton(label: 'Continua', onPressed: () {}),
///     ],
///   ),
/// )
/// ```
class HUFSkeleton extends StatefulWidget {
  const HUFSkeleton({
    super.key,
    required this.child,
    this.active = false,
    this.animation = HUFSkeletonAnimation.shimmer,
  });

  /// Contenuto reale (o struttura con componenti da skeletonizzare).
  final Widget child;

  /// Se `true`, mostra gli skeleton al posto dei componenti HUF.
  final bool active;

  /// Effetto visivo sui placeholder (`shimmer` di default).
  final HUFSkeletonAnimation animation;

  @override
  State<HUFSkeleton> createState() => _HUFSkeletonState();
}

class _HUFSkeletonState extends State<HUFSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  bool get _needsAnimation =>
      widget.active && widget.animation != HUFSkeletonAnimation.none;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _syncAnimation();
  }

  @override
  void didUpdateWidget(HUFSkeleton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animation != widget.animation ||
        oldWidget.active != widget.active) {
      _syncAnimation();
    }
  }

  /// Avvia o ferma il ticker senza dispose: con
  /// [SingleTickerProviderStateMixin] non si può crearne uno nuovo dopo il dispose.
  void _syncAnimation() {
    if (_needsAnimation) {
      if (!_controller.isAnimating) {
        _controller.repeat();
      }
    } else {
      _controller
        ..stop()
        ..value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.active) {
      return widget.child;
    }

    final theme = context.hufTheme;
    final colors = HUFSkeletonColors.fromTheme(theme);

    return HUFSkeletonScope(
      colors: colors,
      child: _HUFSkeletonAnimatedLayer(
        animation: widget.animation,
        colors: colors,
        controller: _needsAnimation ? _controller : null,
        child: HUFSkeletonMapper.map(context, widget.child),
      ),
    );
  }
}

class _HUFSkeletonAnimatedLayer extends StatelessWidget {
  const _HUFSkeletonAnimatedLayer({
    required this.animation,
    required this.colors,
    required this.controller,
    required this.child,
  });

  final HUFSkeletonAnimation animation;
  final HUFSkeletonColors colors;
  final AnimationController? controller;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (animation == HUFSkeletonAnimation.none || controller == null) {
      return child;
    }

    return AnimatedBuilder(
      animation: controller!,
      builder: (context, skeletonChild) {
        return switch (animation) {
          HUFSkeletonAnimation.shimmer => _ShimmerMask(
              progress: controller!.value,
              colors: colors,
              child: skeletonChild!,
            ),
          HUFSkeletonAnimation.pulse => Opacity(
              opacity: 0.45 +
                  0.55 *
                      (0.5 +
                          0.5 * math.sin(controller!.value * 2 * math.pi)),
              child: skeletonChild,
            ),
          HUFSkeletonAnimation.none => skeletonChild!,
        };
      },
      child: child,
    );
  }
}

class _ShimmerMask extends StatelessWidget {
  const _ShimmerMask({
    required this.progress,
    required this.colors,
    required this.child,
  });

  final double progress;
  final HUFSkeletonColors colors;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (bounds) {
        final slide = progress * 2 - 1;
        return LinearGradient(
          begin: Alignment(slide - 1, 0),
          end: Alignment(slide + 1, 0),
          colors: [
            colors.base,
            colors.highlight,
            colors.base,
          ],
          stops: const [0.25, 0.5, 0.75],
        ).createShader(bounds);
      },
      child: child,
    );
  }
}
