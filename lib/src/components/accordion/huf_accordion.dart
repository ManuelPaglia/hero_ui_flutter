import 'package:flutter/material.dart';

import '../../theme/huf_theme.dart';
import 'huf_accordion_style.dart';
import 'huf_accordion_variant.dart';

/// Singolo item espandibile di [HUFAccordion].
///
/// **Uso singolo:** passa [isExpanded] e [onExpansionChanged].
///
/// **Uso in [HUFAccordion]:** passa solo [optionValue] (e titolo, contenuto, icone);
/// il gruppo fornisce [isExpanded] e [onExpansionChanged].
class HUFAccordionItem extends StatelessWidget {
  const HUFAccordionItem({
    super.key,
    required this.title,
    this.content,
    this.leading,
    this.expandIcon,
    this.collapseIcon,
    this.titleColor,
    this.iconColor,
    this.isExpanded,
    this.onExpansionChanged,
    this.optionValue,
    this.enabled = true,
  }) : assert(
          optionValue != null ||
              (isExpanded != null && onExpansionChanged != null),
          'Con optionValue l\'item è gestito da HUFAccordion: '
          'non passare isExpanded né onExpansionChanged. '
          'In uso singolo servono isExpanded e onExpansionChanged.',
        );

  /// Collegamento interno da [HUFAccordion] (non usare direttamente).
  const HUFAccordionItem.wired({
    super.key,
    required this.title,
    required this.isExpanded,
    required this.onExpansionChanged,
    this.content,
    this.leading,
    this.expandIcon,
    this.collapseIcon,
    this.titleColor,
    this.iconColor,
    this.optionValue,
    this.enabled = true,
  });

  final String title;
  final Widget? content;

  /// Icona opzionale a sinistra del titolo.
  final Widget? leading;

  /// Icona mostrata quando l'item è chiuso.
  final Widget? expandIcon;

  /// Icona mostrata quando l'item è aperto.
  final Widget? collapseIcon;

  final Color? titleColor;
  final Color? iconColor;

  /// Stato espanso (uso singolo o wiring interno).
  final bool? isExpanded;
  final ValueChanged<bool>? onExpansionChanged;

  /// Identificativo quando il widget è figlio di [HUFAccordion].
  final Object? optionValue;

  final bool enabled;

  HUFAccordionItem copyWith({
    bool? isExpanded,
    ValueChanged<bool>? onExpansionChanged,
    bool? enabled,
    Widget? expandIcon,
    Widget? collapseIcon,
    Color? titleColor,
    Color? iconColor,
  }) {
    return HUFAccordionItem.wired(
      key: key,
      title: title,
      content: content,
      leading: leading,
      expandIcon: expandIcon ?? this.expandIcon,
      collapseIcon: collapseIcon ?? this.collapseIcon,
      titleColor: titleColor ?? this.titleColor,
      iconColor: iconColor ?? this.iconColor,
      optionValue: optionValue,
      isExpanded: isExpanded ?? this.isExpanded!,
      onExpansionChanged: onExpansionChanged ?? this.onExpansionChanged,
      enabled: enabled ?? this.enabled,
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(
      isExpanded != null,
      'HUFAccordionItem richiede isExpanded (uso singolo) o optionValue (uso in gruppo).',
    );

    final theme = context.hufTheme;
    final metrics = hufAccordionMetricsFor(theme.borderRadius);
    final colors = hufAccordionColorsFor(
      theme.colors,
      HUFAccordionVariant.ghost,
      titleColor: titleColor,
      iconColor: iconColor,
    );

    final expanded = isExpanded!;
    final toggleIcon = expanded
        ? (collapseIcon ?? const Icon(Icons.keyboard_arrow_up))
        : (expandIcon ?? const Icon(Icons.keyboard_arrow_down));

    final leadingWidth = leading != null ? metrics.iconSize + metrics.leadingGap : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: theme.colors.transparent,
          child: InkWell(
            onTap: enabled && onExpansionChanged != null
                ? () => onExpansionChanged!(!expanded)
                : null,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: metrics.headerHorizontalPadding,
                vertical: metrics.headerVerticalPadding,
              ),
              child: Row(
                children: [
                  if (leading != null) ...[
                    IconTheme(
                      data: IconThemeData(
                        color: colors.iconColor,
                        size: metrics.iconSize,
                      ),
                      child: leading!,
                    ),
                    SizedBox(width: metrics.leadingGap),
                  ],
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: metrics.titleFontSize,
                        fontWeight: FontWeight.w600,
                        color: colors.titleColor,
                        height: 1.3,
                      ),
                    ),
                  ),
                  SizedBox(width: metrics.trailingGap),
                  IconTheme(
                    data: IconThemeData(
                      color: colors.iconColor,
                      size: metrics.iconSize,
                    ),
                    child: toggleIcon,
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          alignment: Alignment.topCenter,
          child: expanded && content != null
              ? Padding(
                  padding: EdgeInsets.only(
                    left: metrics.headerHorizontalPadding + leadingWidth,
                    right: metrics.headerHorizontalPadding,
                    top: metrics.contentTopGap,
                    bottom: metrics.contentBottomPadding,
                  ),
                  child: DefaultTextStyle(
                    style: TextStyle(
                      fontSize: metrics.contentFontSize,
                      fontWeight: FontWeight.w400,
                      color: colors.contentColor,
                      height: 1.45,
                    ),
                    child: content!,
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

/// Gruppo di [HUFAccordionItem] con gestione condivisa dell'espansione.
///
/// Ogni figlio deve avere [HUFAccordionItem.optionValue] e non deve passare
/// [HUFAccordionItem.isExpanded] né [HUFAccordionItem.onExpansionChanged].
///
/// Con [allowMultiple] `true` (default) più item possono restare aperti.
/// Con [allowMultiple] `false` aprirne uno chiude gli altri dello stesso gruppo.
class HUFAccordion<T> extends StatefulWidget {
  const HUFAccordion({
    super.key,
    required this.children,
    this.variant = HUFAccordionVariant.card,
    this.showSeparators = true,
    this.allowMultiple = true,
    this.initialExpanded,
    this.expanded,
    this.onExpansionChanged,
    this.expandIcon,
    this.collapseIcon,
    this.titleColor,
    this.iconColor,
  }) : assert(
          children.length > 0,
          'HUFAccordion richiede almeno un HUFAccordionItem.',
        );

  final List<HUFAccordionItem> children;
  final HUFAccordionVariant variant;
  final bool showSeparators;
  final bool allowMultiple;

  /// Valori inizialmente espansi (modalità non controllata).
  final Set<T>? initialExpanded;

  /// Valori attualmente espansi (modalità controllata).
  final Set<T>? expanded;

  final ValueChanged<Set<T>>? onExpansionChanged;

  /// Icona di default per tutti gli item chiusi.
  final Widget? expandIcon;

  /// Icona di default per tutti gli item aperti.
  final Widget? collapseIcon;

  final Color? titleColor;
  final Color? iconColor;

  @override
  State<HUFAccordion<T>> createState() => _HUFAccordionState<T>();
}

class _HUFAccordionState<T> extends State<HUFAccordion<T>> {
  late Set<T> _expanded;

  bool get _isControlled => widget.expanded != null;

  @override
  void initState() {
    super.initState();
    _expanded = Set<T>.from(widget.expanded ?? widget.initialExpanded ?? {});
    _assertChildren();
  }

  @override
  void didUpdateWidget(HUFAccordion<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.children != oldWidget.children) {
      _assertChildren();
    }
    if (_isControlled && widget.expanded != oldWidget.expanded) {
      _expanded = Set<T>.from(widget.expanded!);
    }
  }

  void _assertChildren() {
    assert(
      widget.children.every((child) => child.optionValue != null),
      'Ogni HUFAccordionItem in HUFAccordion deve avere optionValue.',
    );
    assert(
      widget.children.every(
        (child) => child.isExpanded == null && child.onExpansionChanged == null,
      ),
      'I figli di HUFAccordion non devono avere isExpanded né onExpansionChanged.',
    );
  }

  void _notifyChange([Set<T>? values]) {
    widget.onExpansionChanged?.call(
      Set<T>.unmodifiable(values ?? _expanded),
    );
  }

  void _handleItemChanged(T value, bool expand) {
    final next = Set<T>.from(_expanded);

    if (widget.allowMultiple) {
      if (expand) {
        next.add(value);
      } else {
        next.remove(value);
      }
    } else if (expand) {
      next
        ..clear()
        ..add(value);
    } else {
      next.remove(value);
    }

    if (_isControlled) {
      _notifyChange(next);
      return;
    }

    setState(() => _expanded = next);
    _notifyChange();
  }

  Widget _buildSeparator(HUFAccordionMetrics metrics, HUFAccordionColors colors) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: metrics.separatorInset),
      child: Divider(
        height: 1,
        thickness: 1,
        color: colors.separatorColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.hufTheme;
    final metrics = hufAccordionMetricsFor(theme.borderRadius);
    final colors = hufAccordionColorsFor(
      theme.colors,
      widget.variant,
      titleColor: widget.titleColor,
      iconColor: widget.iconColor,
    );

    final expandedSet = _isControlled ? widget.expanded! : _expanded;

    final wiredChildren = <Widget>[];
    for (var i = 0; i < widget.children.length; i++) {
      final child = widget.children[i];
      final optionValue = child.optionValue! as T;
      final isExpanded = expandedSet.contains(optionValue);

      wiredChildren.add(
        child.copyWith(
          isExpanded: isExpanded,
          onExpansionChanged: child.enabled
              ? (expand) => _handleItemChanged(optionValue, expand)
              : null,
          expandIcon: child.expandIcon ?? widget.expandIcon,
          collapseIcon: child.collapseIcon ?? widget.collapseIcon,
          titleColor: child.titleColor ?? widget.titleColor,
          iconColor: child.iconColor ?? widget.iconColor,
        ),
      );

      if (widget.showSeparators && i < widget.children.length - 1) {
        wiredChildren.add(_buildSeparator(metrics, colors));
      }
    }

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: wiredChildren,
    );

    if (widget.variant == HUFAccordionVariant.ghost) {
      return content;
    }

    final borderRadius = BorderRadius.circular(metrics.borderRadius);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: borderRadius,
        border: Border.all(color: theme.colors.border),
      ),
      child: Padding(
        padding: metrics.cardPadding,
        child: content,
      ),
    );
  }
}
