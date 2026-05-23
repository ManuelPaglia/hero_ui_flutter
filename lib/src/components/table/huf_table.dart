import 'package:flutter/material.dart';

import '../../theme/huf_theme.dart';
import '../checkbox/huf_checkbox.dart';
import '../checkbox/huf_checkbox_size.dart';
import '../scroll_shadow/huf_scroll_shadow.dart';
import 'huf_table_column.dart';
import 'huf_table_empty_state.dart';
import 'huf_table_selection_mode.dart';
import 'huf_table_sort_descriptor.dart';
import 'huf_table_style.dart';
import 'huf_table_variant.dart';

export 'huf_table_column.dart';
export 'huf_table_empty_state.dart';
export 'huf_table_pagination_footer.dart';
export 'huf_table_selection_mode.dart';
export 'huf_table_sort_descriptor.dart';
export 'huf_table_status_badge.dart';
export 'huf_table_variant.dart';

/// Riga visibile (piatta o in albero) per il rendering interno.
class _HUFTableVisibleRow<T> {
  const _HUFTableVisibleRow({
    required this.key,
    required this.data,
    required this.depth,
    this.hasChildren = false,
    this.isExpanded = false,
  });

  final Object key;
  final T data;
  final int depth;
  final bool hasChildren;
  final bool isExpanded;
}

/// Tabella dati del design system Hero UI Flutter.
///
/// Supporta varianti [HUFTableVariant], selezione righe, ordinamento colonne,
/// righe espandibili (albero), celle custom, stato vuoto, footer di
/// paginazione, zebra striping e corpo virtualizzato con [ListView.builder].
///
/// I colori derivano da [HUFTheme]; ogni token è sovrascrivibile con le prop
/// dedicate (`containerColor`, `headerBackgroundColor`, …).
class HUFTable<T> extends StatefulWidget {
  const HUFTable({
    super.key,
    required this.columns,
    required this.rows,
    required this.rowKey,
    this.variant = HUFTableVariant.primary,
    this.selectionMode = HUFTableSelectionMode.none,
    this.selectedKeys,
    this.onSelectionChanged,
    this.sortDescriptor,
    this.onSortChange,
    this.comparator,
    this.expandedKeys,
    this.onExpandedChange,
    this.childrenOf,
    this.striped = false,
    this.maxBodyHeight,
    this.footer,
    this.emptyState,
    this.showSelectionSummary = false,
    this.selectionSummaryBuilder,
    this.containerColor,
    this.containerBorderColor,
    this.headerBackgroundColor,
    this.headerTextColor,
    this.bodyTextColor,
    this.dividerColor,
    this.rowHoverColor,
    this.rowSelectedColor,
    this.stripedRowColor,
    this.bodyBackgroundColor,
    this.horizontalScroll = true,
  }) : assert(columns.length > 0, 'HUFTable richiede almeno una colonna.');

  final List<HUFTableColumn<T>> columns;
  final List<T> rows;
  final Object Function(T row) rowKey;

  final HUFTableVariant variant;
  final HUFTableSelectionMode selectionMode;

  /// Chiavi selezionate (modalità controllata).
  final Set<Object>? selectedKeys;
  final ValueChanged<Set<Object>>? onSelectionChanged;

  final HUFTableSortDescriptor? sortDescriptor;
  final ValueChanged<HUFTableSortDescriptor?>? onSortChange;

  /// Comparatore custom; se assente usa confronto tra [String] da [valueBuilder].
  final int Function(T a, T b, HUFTableSortDescriptor descriptor)? comparator;

  final Set<Object>? expandedKeys;
  final ValueChanged<Set<Object>>? onExpandedChange;

  /// Figli per riga (albero). Se null, le righe sono piatte.
  final List<T>? Function(T row)? childrenOf;

  /// Righe alternate con sfondo leggermente diverso.
  final bool striped;

  /// Altezza massima del corpo; abilita scroll virtualizzato.
  final double? maxBodyHeight;

  /// Widget sotto le righe (es. [HUFTablePaginationFooter]).
  final Widget? footer;

  /// Mostrato quando [rows] è vuoto dopo ordinamento.
  final Widget? emptyState;

  /// Testo sotto la tabella con conteggio selezione (es. "Selected: 2").
  final bool showSelectionSummary;
  final String Function(Set<Object> selectedKeys)? selectionSummaryBuilder;

  final Color? containerColor;
  final Color? containerBorderColor;
  final Color? headerBackgroundColor;
  final Color? headerTextColor;
  final Color? bodyTextColor;
  final Color? dividerColor;
  final Color? rowHoverColor;
  final Color? rowSelectedColor;
  final Color? stripedRowColor;
  final Color? bodyBackgroundColor;

  /// Se `true`, su viewport stretti la tabella scrolla in orizzontale
  /// mantenendo larghezze minime per colonna.
  final bool horizontalScroll;

  @override
  State<HUFTable<T>> createState() => _HUFTableState<T>();
}

class _HUFTableState<T> extends State<HUFTable<T>> {
  late Set<Object> _selectedKeys;
  late Set<Object> _expandedKeys;
  final ScrollController _horizontalScrollController = ScrollController();
  ScrollController? _verticalScrollController;
  Object? _hoveredKey;

  bool get _selectionControlled =>
      widget.selectedKeys != null && widget.onSelectionChanged != null;

  bool get _expansionControlled =>
      widget.expandedKeys != null && widget.onExpandedChange != null;

  bool get _hasSelectionColumn =>
      widget.selectionMode != HUFTableSelectionMode.none;

  HUFTableColumn<T>? get _treeColumn {
    for (final column in widget.columns) {
      if (column.isTreeColumn) return column;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _selectedKeys = Set<Object>.from(widget.selectedKeys ?? {});
    _expandedKeys = Set<Object>.from(widget.expandedKeys ?? {});
    if (widget.maxBodyHeight != null) {
      _verticalScrollController = ScrollController();
    }
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    _verticalScrollController?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(HUFTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.maxBodyHeight != null && _verticalScrollController == null) {
      _verticalScrollController = ScrollController();
    } else if (widget.maxBodyHeight == null && _verticalScrollController != null) {
      _verticalScrollController!.dispose();
      _verticalScrollController = null;
    }
    if (_selectionControlled && widget.selectedKeys != oldWidget.selectedKeys) {
      _selectedKeys = Set<Object>.from(widget.selectedKeys!);
    }
    if (_expansionControlled && widget.expandedKeys != oldWidget.expandedKeys) {
      _expandedKeys = Set<Object>.from(widget.expandedKeys!);
    }
  }

  Set<Object> get _effectiveSelected =>
      _selectionControlled ? widget.selectedKeys! : _selectedKeys;

  Set<Object> get _effectiveExpanded =>
      _expansionControlled ? widget.expandedKeys! : _expandedKeys;

  void _updateSelection(Set<Object> next) {
    if (_selectionControlled) {
      widget.onSelectionChanged!(next);
    } else {
      setState(() => _selectedKeys = next);
    }
  }

  void _updateExpanded(Set<Object> next) {
    if (_expansionControlled) {
      widget.onExpandedChange!(next);
    } else {
      setState(() => _expandedKeys = next);
    }
  }

  List<T> _sortedRows(List<T> source) {
    final descriptor = widget.sortDescriptor;
    if (descriptor == null) return source;

    final column = widget.columns
        .where((c) => c.key == descriptor.columnKey)
        .cast<HUFTableColumn<T>?>()
        .firstWhere((c) => c != null, orElse: () => null);
    if (column == null) return source;

    final sorted = List<T>.from(source);
    final compare = widget.comparator ??
        (a, b, d) {
          final av = column.valueBuilder?.call(a) ?? a.toString();
          final bv = column.valueBuilder?.call(b) ?? b.toString();
          return av.toLowerCase().compareTo(bv.toLowerCase());
        };

    sorted.sort((a, b) {
      final result = compare(a, b, descriptor);
      return descriptor.ascending ? result : -result;
    });
    return sorted;
  }

  List<_HUFTableVisibleRow<T>> _flattenRows(List<T> roots) {
    final result = <_HUFTableVisibleRow<T>>[];
    final childrenOf = widget.childrenOf;

    void visit(T row, int depth) {
      final key = widget.rowKey(row);
      final children = childrenOf?.call(row);
      final hasChildren = children != null && children.isNotEmpty;
      final isExpanded = hasChildren && _effectiveExpanded.contains(key);

      result.add(
        _HUFTableVisibleRow<T>(
          key: key,
          data: row,
          depth: depth,
          hasChildren: hasChildren,
          isExpanded: isExpanded,
        ),
      );

      if (hasChildren && isExpanded) {
        for (final child in children) {
          visit(child, depth + 1);
        }
      }
    }

    for (final row in roots) {
      visit(row, 0);
    }
    return result;
  }

  void _toggleSort(HUFTableColumn<T> column) {
    if (!column.allowsSorting || widget.onSortChange == null) return;

    final current = widget.sortDescriptor;
    HUFTableSortDescriptor? next;
    if (current?.columnKey == column.key) {
      if (current!.ascending) {
        next = current.toggle();
      } else {
        next = null;
      }
    } else {
      next = HUFTableSortDescriptor(columnKey: column.key);
    }
    widget.onSortChange!(next);
  }

  void _toggleRowSelection(Object key) {
    final current = Set<Object>.from(_effectiveSelected);
    if (widget.selectionMode == HUFTableSelectionMode.single) {
      if (current.contains(key)) {
        current.clear();
      } else {
        current
          ..clear()
          ..add(key);
      }
    } else {
      if (current.contains(key)) {
        current.remove(key);
      } else {
        current.add(key);
      }
    }
    _updateSelection(current);
  }

  void _toggleSelectAll(List<_HUFTableVisibleRow<T>> visibleRows) {
    if (widget.selectionMode != HUFTableSelectionMode.multiple) return;

    final allKeys = visibleRows.map((r) => r.key).toSet();
    final current = _effectiveSelected;
    if (current.length == allKeys.length && allKeys.every(current.contains)) {
      _updateSelection({});
    } else {
      _updateSelection(allKeys);
    }
  }

  void _toggleExpanded(Object key) {
    final next = Set<Object>.from(_effectiveExpanded);
    if (next.contains(key)) {
      next.remove(key);
    } else {
      next.add(key);
    }
    _updateExpanded(next);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.hufTheme;
    final metrics = hufTableMetricsFor(theme.borderRadius);
    final colors = hufTableColorsFor(
      theme.colors,
      containerColor: widget.containerColor,
      containerBorderColor: widget.containerBorderColor,
      headerBackgroundColor: widget.headerBackgroundColor,
      headerTextColor: widget.headerTextColor,
      bodyTextColor: widget.bodyTextColor,
      dividerColor: widget.dividerColor,
      rowHoverColor: widget.rowHoverColor,
      rowSelectedColor: widget.rowSelectedColor,
      stripedRowColor: widget.stripedRowColor,
      bodyBackgroundColor: widget.bodyBackgroundColor,
    );

    final sortedRoots = _sortedRows(widget.rows);
    final visibleRows = _flattenRows(sortedRoots);
    final isEmpty = visibleRows.isEmpty;
    final useInsetBody = widget.variant == HUFTableVariant.primary;
    final minContentWidth = hufTableMinContentWidthFor(
      columns: widget.columns,
      metrics: metrics,
      selectionMode: widget.selectionMode,
      variant: widget.variant,
    );
    final columnWidths = hufTableColumnWidthsFor(widget.columns, metrics);

    final tableContent = DecoratedBox(
      decoration: BoxDecoration(
        color: colors.containerColor,
        borderRadius: BorderRadius.circular(metrics.borderRadius),
        border: Border.all(color: colors.containerBorderColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(metrics.borderRadius),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final viewportWidth = constraints.maxWidth;
            final useHorizontalScroll = widget.horizontalScroll &&
                minContentWidth > viewportWidth + 0.5;
            final resolvedColumnWidths =
                useHorizontalScroll ? columnWidths : null;

            final bodyWidget = isEmpty
                ? widget.emptyState ?? const HUFTableEmptyState()
                : _buildBody(
                    context,
                    metrics,
                    colors,
                    visibleRows,
                    useInsetBody: useInsetBody,
                    columnWidths: resolvedColumnWidths,
                  );

            final inner = Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(
                  context,
                  metrics,
                  colors,
                  visibleRows,
                  useInsetBody: useInsetBody,
                  columnWidths: resolvedColumnWidths,
                ),
                _wrapBodySection(
                  metrics: metrics,
                  colors: colors,
                  useInsetBody: useInsetBody,
                  child: bodyWidget,
                ),
                if (widget.footer != null) ...[
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: colors.dividerColor,
                  ),
                  widget.footer!,
                ],
              ],
            );

            if (!useHorizontalScroll) return inner;

            return HUFScrollShadow(
              direction: Axis.horizontal,
              color: colors.containerColor,
              size: metrics.horizontalScrollShadowSize,
              child: SingleChildScrollView(
                controller: _horizontalScrollController,
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: minContentWidth,
                  child: inner,
                ),
              ),
            );
          },
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        tableContent,
        if (widget.showSelectionSummary && _hasSelectionColumn)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              widget.selectionSummaryBuilder?.call(_effectiveSelected) ??
                  _defaultSelectionSummary(_effectiveSelected),
              style: TextStyle(
                color: colors.footerTextColor,
                fontSize: metrics.selectionSummaryFontSize,
              ),
            ),
          ),
      ],
    );
  }

  String _defaultSelectionSummary(Set<Object> keys) {
    if (keys.isEmpty) return 'Selected: None';
    if (keys.length == 1) return 'Selected: 1 row';
    return 'Selected: ${keys.length} rows';
  }

  Widget _wrapBodySection({
    required HUFTableMetrics metrics,
    required HUFTableColors colors,
    required bool useInsetBody,
    required Widget child,
  }) {
    if (!useInsetBody) return child;

    final bodyRadius = hufTableBodyBorderRadius(
      metrics.borderRadius,
      metrics.bodyInset,
    );
    final bodyShape = bodyRadius > 0
        ? BorderRadius.circular(bodyRadius)
        : BorderRadius.zero;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        metrics.bodyInset,
        metrics.headerBodyGap,
        metrics.bodyInset,
        metrics.bodyInset,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.bodyBackgroundColor,
          borderRadius: bodyShape,
        ),
        child: bodyRadius > 0
            ? ClipRRect(borderRadius: bodyShape, child: child)
            : child,
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    HUFTableMetrics metrics,
    HUFTableColors colors,
    List<_HUFTableVisibleRow<T>> visibleRows, {
    required bool useInsetBody,
    List<double>? columnWidths,
  }) {
    final isSecondary = widget.variant == HUFTableVariant.secondary;
    final horizontalPadding = useInsetBody
        ? metrics.bodyInset + metrics.cellPaddingHorizontal
        : metrics.cellPaddingHorizontal;
    final headerPadding = EdgeInsets.fromLTRB(
      horizontalPadding,
      isSecondary ? 12 : metrics.cellPaddingVertical,
      horizontalPadding,
      isSecondary ? 8 : 0,
    );

    final row = _TableRowLayout(
      metrics: metrics,
      selectionMode: widget.selectionMode,
      columns: widget.columns,
      columnWidths: columnWidths,
      leading: _hasSelectionColumn
          ? _SelectionHeaderCell(
              mode: widget.selectionMode,
              allSelected: visibleRows.isNotEmpty &&
                  visibleRows.every((r) => _effectiveSelected.contains(r.key)),
              someSelected: visibleRows.any(
                (r) => _effectiveSelected.contains(r.key),
              ),
              onToggle: () => _toggleSelectAll(visibleRows),
            )
          : null,
      cells: widget.columns
          .map(
            (column) => _HeaderCell(
              column: column,
              metrics: metrics,
              colors: colors,
              sortDescriptor: widget.sortDescriptor,
              onSortTap: column.allowsSorting && widget.onSortChange != null
                  ? () => _toggleSort(column)
                  : null,
            ),
          )
          .toList(),
    );

    if (isSecondary) {
      return Padding(
        padding: headerPadding.copyWith(bottom: 8),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.headerBackgroundColor,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: metrics.cellPaddingHorizontal / 2,
              vertical: metrics.cellPaddingVertical / 2,
            ),
            child: row,
          ),
        ),
      );
    }

    return Padding(padding: headerPadding, child: row);
  }

  Widget _buildBody(
    BuildContext context,
    HUFTableMetrics metrics,
    HUFTableColors colors,
    List<_HUFTableVisibleRow<T>> visibleRows, {
    required bool useInsetBody,
    List<double>? columnWidths,
  }) {
    Widget buildRow(int index) {
      final visible = visibleRows[index];
      final isSelected = _effectiveSelected.contains(visible.key);
      final isHovered = _hoveredKey == visible.key;
      final background = _rowBackground(
        colors: colors,
        index: index,
        isSelected: isSelected,
        isHovered: isHovered,
      );

      return _DataRow<T>(
        visible: visible,
        metrics: metrics,
        colors: colors,
        backgroundColor: background,
        columns: widget.columns,
        columnWidths: columnWidths,
        treeColumn: _treeColumn,
        selectionMode: widget.selectionMode,
        isSelected: isSelected,
        onHoverChanged: (hovered) {
          setState(() => _hoveredKey = hovered ? visible.key : null);
        },
        onSelectionToggle: () => _toggleRowSelection(visible.key),
        onExpandToggle: visible.hasChildren
            ? () => _toggleExpanded(visible.key)
            : null,
        showDivider: index < visibleRows.length - 1,
        useInsetBody: useInsetBody,
      );
    }

    if (widget.maxBodyHeight != null) {
      final verticalController = _verticalScrollController!;
      return SizedBox(
        height: widget.maxBodyHeight,
        child: HUFScrollShadow(
          direction: Axis.vertical,
          color: useInsetBody
              ? colors.bodyBackgroundColor
              : colors.containerColor,
          size: metrics.horizontalScrollShadowSize,
          child: ListView.builder(
            controller: verticalController,
            primary: false,
            itemCount: visibleRows.length,
            itemBuilder: (_, index) => buildRow(index),
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(visibleRows.length, buildRow),
    );
  }

  Color? _rowBackground({
    required HUFTableColors colors,
    required int index,
    required bool isSelected,
    required bool isHovered,
  }) {
    if (isSelected) return colors.rowSelectedColor;
    if (isHovered) return colors.rowHoverColor;
    if (widget.striped && index.isOdd) return colors.stripedRowColor;
    return null;
  }
}

class _TableRowLayout<T> extends StatelessWidget {
  const _TableRowLayout({
    required this.metrics,
    required this.selectionMode,
    required this.columns,
    required this.cells,
    this.columnWidths,
    this.leading,
  });

  final HUFTableMetrics metrics;
  final HUFTableSelectionMode selectionMode;
  final List<HUFTableColumn<T>> columns;
  final List<Widget> cells;
  final List<double>? columnWidths;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    assert(
      columnWidths == null || columnWidths!.length == columns.length,
      'columnWidths deve avere la stessa lunghezza di columns.',
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (leading != null) ...[
          SizedBox(
            width: metrics.selectionColumnWidth,
            child: Align(
              alignment: Alignment.centerLeft,
              child: leading,
            ),
          ),
        ],
        for (var i = 0; i < columns.length; i++)
          if (columnWidths != null)
            SizedBox(
              width: columnWidths![i],
              child: cells[i],
            )
          else
            Expanded(
              flex: columns[i].flex,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: columns[i].minWidth ?? 0,
                ),
                child: cells[i],
              ),
            ),
      ],
    );
  }
}

class _SelectionHeaderCell extends StatelessWidget {
  const _SelectionHeaderCell({
    required this.mode,
    required this.allSelected,
    required this.someSelected,
    required this.onToggle,
  });

  final HUFTableSelectionMode mode;
  final bool allSelected;
  final bool someSelected;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    if (mode != HUFTableSelectionMode.multiple) {
      return const SizedBox.shrink();
    }

    return HUFCheckbox(
      value: allSelected || someSelected,
      checkedIcon: allSelected
          ? const Icon(Icons.check_rounded)
          : const Icon(Icons.remove_rounded),
      onChanged: (_) => onToggle(),
      size: HUFCheckboxSize.small,
    );
  }
}

class _HeaderCell<T> extends StatelessWidget {
  const _HeaderCell({
    required this.column,
    required this.metrics,
    required this.colors,
    required this.sortDescriptor,
    this.onSortTap,
  });

  final HUFTableColumn<T> column;
  final HUFTableMetrics metrics;
  final HUFTableColors colors;
  final HUFTableSortDescriptor? sortDescriptor;
  final VoidCallback? onSortTap;

  @override
  Widget build(BuildContext context) {
    final content = column.headerBuilder?.call(context) ??
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                column.label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: colors.headerTextColor,
                  fontSize: metrics.headerFontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (sortDescriptor?.columnKey == column.key) ...[
              const SizedBox(width: 4),
              Icon(
                sortDescriptor!.ascending
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                size: 16,
                color: colors.sortIconColor,
              ),
            ],
          ],
        );

    final aligned = Align(
      alignment: column.alignment,
      child: content,
    );

    if (onSortTap == null) return aligned;

    return InkWell(
      onTap: onSortTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: aligned,
      ),
    );
  }
}

class _DataRow<T> extends StatelessWidget {
  const _DataRow({
    required this.visible,
    required this.metrics,
    required this.colors,
    required this.backgroundColor,
    required this.columns,
    required this.columnWidths,
    required this.treeColumn,
    required this.selectionMode,
    required this.isSelected,
    required this.onHoverChanged,
    required this.onSelectionToggle,
    required this.onExpandToggle,
    required this.showDivider,
    required this.useInsetBody,
  });

  final _HUFTableVisibleRow<T> visible;
  final HUFTableMetrics metrics;
  final HUFTableColors colors;
  final Color? backgroundColor;
  final List<HUFTableColumn<T>> columns;
  final List<double>? columnWidths;
  final HUFTableColumn<T>? treeColumn;
  final HUFTableSelectionMode selectionMode;
  final bool isSelected;
  final ValueChanged<bool> onHoverChanged;
  final VoidCallback onSelectionToggle;
  final VoidCallback? onExpandToggle;
  final bool showDivider;
  final bool useInsetBody;

  @override
  Widget build(BuildContext context) {
    final row = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: metrics.cellPaddingHorizontal,
        vertical: metrics.cellPaddingVertical / 2,
      ),
      child: _TableRowLayout(
        metrics: metrics,
        selectionMode: selectionMode,
        columns: columns,
        columnWidths: columnWidths,
        leading: selectionMode != HUFTableSelectionMode.none
            ? HUFCheckbox(
                value: isSelected,
                onChanged: (_) => onSelectionToggle(),
                size: HUFCheckboxSize.small,
              )
            : null,
        cells: columns.map((column) {
          if (column.isTreeColumn && treeColumn != null) {
            return _TreeCell(
              column: column,
              metrics: metrics,
              colors: colors,
              depth: visible.depth,
              hasChildren: visible.hasChildren,
              isExpanded: visible.isExpanded,
              onExpandToggle: onExpandToggle,
              child: _BodyCell(
                column: column,
                metrics: metrics,
                colors: colors,
                row: visible.data,
              ),
            );
          }
          return _BodyCell(
            column: column,
            metrics: metrics,
            colors: colors,
            row: visible.data,
          );
        }).toList(),
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MouseRegion(
          onEnter: (_) => onHoverChanged(true),
          onExit: (_) => onHoverChanged(false),
          child: useInsetBody
              ? ColoredBox(
                  color: backgroundColor ?? colors.bodyBackgroundColor,
                  child: row,
                )
              : DecoratedBox(
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius:
                        BorderRadius.circular(metrics.borderRadius / 2),
                  ),
                  child: row,
                ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            indent: useInsetBody || columnWidths != null
                ? 0
                : metrics.cellPaddingHorizontal,
            endIndent: useInsetBody || columnWidths != null
                ? 0
                : metrics.cellPaddingHorizontal,
            color: colors.dividerColor,
          ),
      ],
    );
  }
}

class _TreeCell<T> extends StatelessWidget {
  const _TreeCell({
    required this.column,
    required this.metrics,
    required this.colors,
    required this.depth,
    required this.hasChildren,
    required this.isExpanded,
    required this.child,
    this.onExpandToggle,
  });

  final HUFTableColumn<T> column;
  final HUFTableMetrics metrics;
  final HUFTableColors colors;
  final int depth;
  final bool hasChildren;
  final bool isExpanded;
  final VoidCallback? onExpandToggle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: column.alignment,
      child: Row(
        children: [
          SizedBox(width: depth * metrics.treeIndent),
          SizedBox(
            width: 28,
            child: hasChildren
                ? IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints.tightFor(
                      width: 28,
                      height: 28,
                    ),
                    onPressed: onExpandToggle,
                    icon: Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_right,
                      size: 20,
                      color: colors.bodyTextColor,
                    ),
                  )
                : const SizedBox(width: 28),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _BodyCell<T> extends StatelessWidget {
  const _BodyCell({
    required this.column,
    required this.metrics,
    required this.colors,
    required this.row,
  });

  final HUFTableColumn<T> column;
  final HUFTableMetrics metrics;
  final HUFTableColors colors;
  final T row;

  @override
  Widget build(BuildContext context) {
    final child = column.cellBuilder?.call(context, row) ??
        Text(
          column.valueBuilder?.call(row) ?? row.toString(),
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: colors.bodyTextColor,
            fontSize: metrics.bodyFontSize,
            fontWeight: FontWeight.w500,
          ),
        );

    return Align(
      alignment: column.alignment,
      child: child,
    );
  }
}
