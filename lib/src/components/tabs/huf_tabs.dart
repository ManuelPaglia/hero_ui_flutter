import 'package:flutter/material.dart';

import '../../layout/huf_shrink_wrap_width.dart';
import '../../theme/huf_theme.dart';
import 'huf_tab_direction.dart';
import 'huf_tab_item.dart';
import 'huf_tab_variant.dart';
import 'huf_tabs_style.dart';

export 'huf_tab_direction.dart';
export 'huf_tab_item.dart';
export 'huf_tab_variant.dart';

/// Navigazione a tab del design system Hero UI Flutter.
///
/// Supporta layout [direction] orizzontale (default) o verticale e le varianti
/// [HUFTabVariant.primary] (pill con sfondo scorrevole) e
/// [HUFTabVariant.secondary] (track con indicatore spesso).
///
/// In modalità non controllata usa [initialValue]; in modalità controllata
/// passa [value] e aggiorna lo stato dal parent tramite [onChanged].
///
/// I colori derivano da [HUFTheme]; ogni token è sovrascrivibile con le prop
/// dedicate (`containerColor`, `indicatorColor`, …).
class HUFTabs<T> extends StatefulWidget {
  const HUFTabs({
    super.key,
    required this.items,
    this.value,
    this.initialValue,
    this.onChanged,
    this.direction = HUFTabDirection.horizontal,
    this.variant = HUFTabVariant.primary,
    this.containerColor,
    this.containerBorderColor,
    this.indicatorColor,
    this.activeTextColor,
    this.inactiveTextColor,
    this.disabledTextColor,
    this.trackColor,
  }) : assert(
          items.length > 0,
          'HUFTabs richiede almeno una voce.',
        );

  final List<HUFTabItem<T>> items;
  final T? value;
  final T? initialValue;
  final ValueChanged<T>? onChanged;
  final HUFTabDirection direction;
  final HUFTabVariant variant;
  final Color? containerColor;
  final Color? containerBorderColor;
  final Color? indicatorColor;
  final Color? activeTextColor;
  final Color? inactiveTextColor;
  final Color? disabledTextColor;
  final Color? trackColor;

  static const Duration indicatorAnimationDuration =
      Duration(milliseconds: 180);

  /// Partenza rapida, decelerazione in chiusura.
  static const Curve indicatorAnimationCurve = Curves.easeOutCubic;

  @override
  State<HUFTabs<T>> createState() => _HUFTabsState<T>();
}

class _HUFTabsState<T> extends State<HUFTabs<T>> {
  late T? _selected;
  final GlobalKey _measureKey = GlobalKey();
  final List<GlobalKey> _tabKeys = [];
  _IndicatorGeometry _indicator = _IndicatorGeometry.zero;
  Size _contentSize = Size.zero;

  bool get _isControlled => widget.value != null;

  bool get _isHorizontal => widget.direction == HUFTabDirection.horizontal;

  int get _selectedIndex {
    final selected = _isControlled ? widget.value : _selected;
    if (selected == null) return 0;
    final index = widget.items.indexWhere((item) => item.value == selected);
    return index < 0 ? 0 : index;
  }

  @override
  void initState() {
    super.initState();
    _selected = widget.value ??
        widget.initialValue ??
        _firstEnabledValue();
    _syncTabKeys();
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureIndicator());
  }

  @override
  void didUpdateWidget(HUFTabs<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items.length != oldWidget.items.length) {
      _syncTabKeys();
    }
    if (_isControlled && widget.value != oldWidget.value) {
      _selected = widget.value;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureIndicator());
  }

  T? _firstEnabledValue() {
    for (final item in widget.items) {
      if (item.enabled) return item.value;
    }
    return widget.items.first.value;
  }

  void _syncTabKeys() {
    _tabKeys
      ..clear()
      ..addAll(List.generate(widget.items.length, (_) => GlobalKey()));
  }

  void _measureIndicator() {
    if (!mounted) return;

    final measureContext = _measureKey.currentContext;
    final selectedKey = _tabKeys[_selectedIndex].currentContext;
    if (measureContext == null || selectedKey == null) return;

    final measureBox = measureContext.findRenderObject() as RenderBox?;
    final tabBox = selectedKey.findRenderObject() as RenderBox?;
    if (measureBox == null ||
        tabBox == null ||
        !measureBox.hasSize ||
        !tabBox.hasSize) {
      return;
    }

    final offset = tabBox.localToGlobal(Offset.zero, ancestor: measureBox);
    final contentSize = measureBox.size;
    final next = _IndicatorGeometry(
      left: offset.dx,
      top: offset.dy,
      width: tabBox.size.width,
      height: tabBox.size.height,
    );

    final shouldUpdate =
        next != _indicator || contentSize != _contentSize;
    if (!shouldUpdate) return;

    setState(() {
      _indicator = next;
      _contentSize = contentSize;
    });
  }

  void _handleTap(HUFTabItem<T> item) {
    if (!item.enabled) return;

    if (_isControlled) {
      widget.onChanged?.call(item.value);
      return;
    }

    if (_selected == item.value) return;
    setState(() => _selected = item.value);
    widget.onChanged?.call(item.value);
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureIndicator());
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.hufTheme;
    final metrics = kHufTabsMetrics;
    final colors = hufTabsColorsFor(
      theme.colors,
      widget.variant,
      containerColor: widget.containerColor,
      containerBorderColor: widget.containerBorderColor,
      indicatorColor: widget.indicatorColor,
      activeTextColor: widget.activeTextColor,
      inactiveTextColor: widget.inactiveTextColor,
      disabledTextColor: widget.disabledTextColor,
      trackColor: widget.trackColor,
    );

    final selectedIndex = _selectedIndex;

    final tabs = <Widget>[];
    for (var i = 0; i < widget.items.length; i++) {
      final item = widget.items[i];
      tabs.add(
        _HufTabCell(
          key: _tabKeys[i],
          label: item.label,
          isSelected: i == selectedIndex,
          enabled: item.enabled,
          metrics: metrics,
          colors: colors,
          onTap: () => _handleTap(item),
        ),
      );
    }

    final tabStrip = _isHorizontal
        ? Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: tabs,
          )
        : IntrinsicWidth(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: tabs,
            ),
          );

    if (widget.variant == HUFTabVariant.primary &&
        (_indicator.width == 0 || _indicator.height == 0)) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _measureIndicator());
    }

    final content = switch (widget.variant) {
      HUFTabVariant.primary => _buildPrimary(
          metrics: metrics,
          colors: colors,
          tabStrip: tabStrip,
        ),
      HUFTabVariant.secondary => _buildSecondary(
          metrics: metrics,
          colors: colors,
          tabStrip: tabStrip,
        ),
    };

    return HUFShrinkWrapWidth(child: content);
  }

  Widget _buildPrimary({
    required HUFTabsMetrics metrics,
    required HUFTabsColors colors,
    required Widget tabStrip,
  }) {
    final border = colors.containerBorder;
    final measuredTabHeight =
        _indicator.height > 0 ? _indicator.height : null;
    final chipRadius = hufTabsChipRadius(metrics, measuredTabHeight);
    final containerBorderRadius = _isHorizontal
        ? BorderRadius.circular(
            hufTabsHorizontalContainerRadius(metrics, measuredTabHeight),
          )
        : hufTabsVerticalContainerBorderRadius(metrics, measuredTabHeight);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.containerColor,
        borderRadius: containerBorderRadius,
        border: border == null ? null : Border.fromBorderSide(border),
      ),
      child: ClipRRect(
        borderRadius: containerBorderRadius,
        child: Padding(
          padding: EdgeInsets.all(metrics.containerPadding),
          child: Stack(
            key: _measureKey,
            clipBehavior: Clip.hardEdge,
            alignment: Alignment.center,
            children: [
              _buildPrimaryIndicator(metrics, colors, chipRadius),
              tabStrip,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecondary({
    required HUFTabsMetrics metrics,
    required HUFTabsColors colors,
    required Widget tabStrip,
  }) {
    if (_isHorizontal) {
      return Column(
        key: _measureKey,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          tabStrip,
          SizedBox(height: metrics.trackGap),
          SizedBox(
            width: _contentSize.width > 0 ? _contentSize.width : null,
            height: metrics.indicatorThickness,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.centerLeft,
              children: [
                SizedBox(
                  width: _contentSize.width > 0 ? _contentSize.width : null,
                  height: metrics.trackThickness,
                  child: ColoredBox(color: colors.trackColor),
                ),
                _buildSecondaryHorizontalIndicator(metrics, colors),
              ],
            ),
          ),
        ],
      );
    }

    return IntrinsicHeight(
      key: _measureKey,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: metrics.indicatorThickness,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                SizedBox(
                  width: metrics.trackThickness,
                  height: _contentSize.height > 0 ? _contentSize.height : null,
                  child: ColoredBox(color: colors.trackColor),
                ),
                _buildSecondaryVerticalIndicator(metrics, colors),
              ],
            ),
          ),
          SizedBox(width: metrics.trackGap),
          tabStrip,
        ],
      ),
    );
  }

  Widget _buildPrimaryIndicator(
    HUFTabsMetrics metrics,
    HUFTabsColors colors,
    double chipRadius,
  ) {
    return AnimatedPositioned(
      duration: HUFTabs.indicatorAnimationDuration,
      curve: HUFTabs.indicatorAnimationCurve,
      left: _indicator.left,
      top: _indicator.top,
      width: _indicator.width,
      height: _indicator.height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.indicatorColor,
          borderRadius: BorderRadius.circular(chipRadius),
        ),
      ),
    );
  }

  Widget _buildSecondaryHorizontalIndicator(
    HUFTabsMetrics metrics,
    HUFTabsColors colors,
  ) {
    return AnimatedPositioned(
      duration: HUFTabs.indicatorAnimationDuration,
      curve: HUFTabs.indicatorAnimationCurve,
      left: _indicator.left,
      width: _indicator.width,
      bottom: 0,
      height: metrics.indicatorThickness,
      child: ColoredBox(color: colors.indicatorColor),
    );
  }

  Widget _buildSecondaryVerticalIndicator(
    HUFTabsMetrics metrics,
    HUFTabsColors colors,
  ) {
    return AnimatedPositioned(
      duration: HUFTabs.indicatorAnimationDuration,
      curve: HUFTabs.indicatorAnimationCurve,
      top: _indicator.top,
      height: _indicator.height,
      left: 0,
      width: metrics.indicatorThickness,
      child: ColoredBox(color: colors.indicatorColor),
    );
  }
}

@immutable
class _IndicatorGeometry {
  const _IndicatorGeometry({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
  });

  static const zero = _IndicatorGeometry(
    left: 0,
    top: 0,
    width: 0,
    height: 0,
  );

  final double left;
  final double top;
  final double width;
  final double height;

  @override
  bool operator ==(Object other) {
    return other is _IndicatorGeometry &&
        other.left == left &&
        other.top == top &&
        other.width == width &&
        other.height == height;
  }

  @override
  int get hashCode => Object.hash(left, top, width, height);
}

class _HufTabCell extends StatelessWidget {
  const _HufTabCell({
    super.key,
    required this.label,
    required this.isSelected,
    required this.enabled,
    required this.metrics,
    required this.colors,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final bool enabled;
  final HUFTabsMetrics metrics;
  final HUFTabsColors colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textColor = !enabled
        ? colors.disabledTextColor
        : isSelected
            ? colors.activeTextColor
            : colors.inactiveTextColor;

    final fontWeight =
        isSelected && enabled ? FontWeight.w600 : FontWeight.w500;

    return GestureDetector(
      onTap: enabled ? onTap : null,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: metrics.tabHorizontalPadding,
          vertical: metrics.tabVerticalPadding,
        ),
        child: AnimatedDefaultTextStyle(
          duration: HUFTabs.indicatorAnimationDuration,
          curve: HUFTabs.indicatorAnimationCurve,
          style: TextStyle(
            color: textColor,
            fontSize: metrics.fontSize,
            fontWeight: fontWeight,
            height: 1.2,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
