import 'package:flutter/material.dart';

import '../../theme/huf_theme.dart';
import '../button/huf_button.dart';
import '../button/huf_button_size.dart';
import '../button/huf_button_variant.dart';
import 'huf_drawer_open_from.dart';
import 'huf_drawer_style.dart';

/// Pannello drawer del design system Hero UI Flutter.
///
/// Sfondo [HUFThemeColors.card]. [content] viene impilato in una [Column].
///
/// Con [isFullWidth] mostra il pulsante di chiusura icon-only in alto a destra
/// e non chiude al tap sull'overlay. Altrimenti overlay cliccabile per chiudere.
///
/// Drawer dal basso: senza [height] l'altezza segue il contenuto (con tetto
/// massimo); con [height] usa un valore fisso; con [isFullWidth] occupa tutto
/// lo schermo.
///
/// Per aprirlo in modo imperativo usa [hufShowDrawer].
class HUFDrawerPanel extends StatelessWidget {
  const HUFDrawerPanel({
    super.key,
    required this.openFrom,
    required this.content,
    required this.onClose,
    this.isFullWidth = false,
    this.width,
    this.height,
    this.showCloseButton = false,
  });

  final HUFDrawerOpenFrom openFrom;
  final List<Widget> content;
  final VoidCallback onClose;
  final bool isFullWidth;

  /// Larghezza fissa del pannello per `left` / `right` (ignorata se [isFullWidth]).
  final double? width;

  /// Altezza fissa del pannello per `bottom` (ignorata se [isFullWidth]).
  /// Se `null`, l'altezza segue il contenuto.
  final double? height;

  final bool showCloseButton;

  @override
  Widget build(BuildContext context) {
    final theme = context.hufTheme;
    final metrics = hufDrawerMetricsFor(theme);
    final media = MediaQuery.sizeOf(context);
    final decoration = _panelDecoration(theme, metrics);

    return switch (openFrom) {
      HUFDrawerOpenFrom.left || HUFDrawerOpenFrom.right => _buildSidePanel(
          context: context,
          metrics: metrics,
          media: media,
          decoration: decoration,
        ),
      HUFDrawerOpenFrom.bottom => _buildBottomPanel(
          metrics: metrics,
          media: media,
          decoration: decoration,
        ),
    };
  }

  BoxDecoration _panelDecoration(HUFTheme theme, HUFDrawerMetrics metrics) {
    return BoxDecoration(
      color: theme.colors.card,
      borderRadius: hufDrawerPanelBorderRadius(
        openFrom,
        metrics.borderRadius,
        isFullWidth: isFullWidth,
      ),
      border: isFullWidth ? null : Border.all(color: theme.colors.border),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: theme.isDark ? 0.4 : 0.15),
          blurRadius: 24,
          offset: switch (openFrom) {
            HUFDrawerOpenFrom.left => const Offset(4, 0),
            HUFDrawerOpenFrom.right => const Offset(-4, 0),
            HUFDrawerOpenFrom.bottom => const Offset(0, -4),
          },
        ),
      ],
    );
  }

  Widget _buildInner(HUFDrawerMetrics metrics) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showCloseButton) ...[
          Align(
            alignment: Alignment.centerRight,
            child: HUFButton.iconOnly(
              icon: const Icon(Icons.close),
              variant: HUFButtonVariant.secondary,
              size: HUFButtonSize.medium,
              onPressed: onClose,
            ),
          ),
          SizedBox(height: metrics.closeHeaderGap),
        ],
        ..._buildContent(metrics),
      ],
    );
  }

  Widget _buildSidePanel({
    required BuildContext context,
    required HUFDrawerMetrics metrics,
    required Size media,
    required BoxDecoration decoration,
  }) {
    final extent = hufDrawerSideExtent(
      media.width,
      isFullWidth: isFullWidth,
      metrics: metrics,
      width: width,
    );

    return SizedBox(
      width: extent,
      height: media.height,
      child: DecoratedBox(
        decoration: decoration,
        child: SafeArea(
          child: Padding(
            padding: metrics.padding,
            child: SingleChildScrollView(child: _buildInner(metrics)),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomPanel({
    required HUFDrawerMetrics metrics,
    required Size media,
    required BoxDecoration decoration,
  }) {
    final inner = _buildInner(metrics);
    final fixedHeight = hufDrawerBottomExtent(
      media.height,
      isFullWidth: isFullWidth,
      metrics: metrics,
      height: height,
    );

    final padded = Padding(
      padding: metrics.padding,
      child: inner,
    );

    if (fixedHeight != null) {
      return SizedBox(
        width: media.width,
        height: fixedHeight,
        child: DecoratedBox(
          decoration: decoration,
          child: SafeArea(
            top: false,
            bottom: true,
            child: SingleChildScrollView(child: padded),
          ),
        ),
      );
    }

    return SizedBox(
      width: media.width,
      child: DecoratedBox(
        decoration: decoration,
        child: SafeArea(
          top: false,
          bottom: true,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: hufDrawerBottomMaxHeight(media.height, metrics),
            ),
            child: SingleChildScrollView(child: padded),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildContent(HUFDrawerMetrics metrics) {
    if (content.isEmpty) return const [];

    final children = <Widget>[];
    for (var i = 0; i < content.length; i++) {
      if (i > 0) children.add(SizedBox(height: metrics.contentGap));
      children.add(content[i]);
    }
    return children;
  }
}

/// Drawer overlay con animazione slide; da posizionare in uno [Stack] a tutto schermo.
class HUFDrawer extends StatefulWidget {
  const HUFDrawer({
    super.key,
    required this.isOpen,
    required this.onClose,
    this.openFrom = HUFDrawerOpenFrom.left,
    this.isFullWidth = false,
    this.content = const [],
    this.width,
    this.height,
    this.barrierColor,
  });

  final bool isOpen;
  final VoidCallback onClose;
  final HUFDrawerOpenFrom openFrom;
  final bool isFullWidth;
  final List<Widget> content;
  final double? width;
  final double? height;
  final Color? barrierColor;

  @override
  State<HUFDrawer> createState() => _HUFDrawerState();
}

class _HUFDrawerState extends State<HUFDrawer> with SingleTickerProviderStateMixin {
  static const _duration = Duration(milliseconds: 280);

  late final AnimationController _controller;
  late final Animation<double> _progress;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _duration);
    _progress = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    if (widget.isOpen) {
      _visible = true;
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(HUFDrawer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isOpen && !_visible) {
      setState(() => _visible = true);
      _controller.forward();
    } else if (!widget.isOpen && _visible) {
      _controller.reverse().then((_) {
        if (mounted) setState(() => _visible = false);
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleClose() {
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_visible) return const SizedBox.shrink();

    final theme = context.hufTheme;
    final metrics = hufDrawerMetricsFor(theme, barrierColor: widget.barrierColor);
    final barrierDismissible = !widget.isFullWidth;

    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _progress,
        builder: (context, child) {
          return Stack(
            children: [
              Positioned.fill(
                child: Opacity(
                  opacity: _progress.value,
                  child: GestureDetector(
                    onTap: barrierDismissible ? _handleClose : null,
                    behavior: HitTestBehavior.opaque,
                    child: ColoredBox(color: metrics.barrierColor),
                  ),
                ),
              ),
              _buildPanel(_progress.value),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPanel(double progress) {
    final panel = FractionalTranslation(
      translation: hufDrawerSlideOffset(widget.openFrom, progress),
      child: HUFDrawerPanel(
        openFrom: widget.openFrom,
        content: widget.content,
        onClose: _handleClose,
        isFullWidth: widget.isFullWidth,
        width: widget.width,
        height: widget.height,
        showCloseButton: widget.isFullWidth,
      ),
    );

    return switch (widget.openFrom) {
      HUFDrawerOpenFrom.left => Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          child: panel,
        ),
      HUFDrawerOpenFrom.right => Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: panel,
        ),
      HUFDrawerOpenFrom.bottom => Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: panel,
        ),
    };
  }
}
