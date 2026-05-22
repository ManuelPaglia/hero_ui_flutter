import 'package:flutter/material.dart';

import '../../theme/huf_theme.dart';
import '../input/huf_input.dart';
import '../separator/huf_separator.dart';
import 'huf_select_item.dart';
import 'huf_select_placement.dart';
import 'huf_select_style.dart';

/// Builder personalizzato per una voce del menu [HUFSelect].
typedef HUFSelectItemBuilder<T> = Widget Function(
  BuildContext context,
  HUFSelectItem<T> item,
  bool isSelected,
  VoidCallback? onTap,
);

/// Select del design system Hero UI Flutter.
///
/// Supporta selezione singola o multipla, sezioni con intestazione e separatori,
/// voci con avatar o contenuto custom tramite [itemBuilder].
///
/// Border radius, colori e glow seguono [HUFTheme] (token [HUFBorderRadius.value]
/// su trigger, menu e highlight delle voci).
///
/// Per default ha larghezza intrinseca ([isFullWidth] è `false`, modalità content).
/// Imposta [isFullWidth] a `true` per campi che occupano tutta la riga del genitore
/// (form, [ListView] su web, …).
///
/// ```dart
/// HUFSelect<String>(
///   label: 'State',
///   placeholder: 'Select one',
///   items: states,
///   value: selected,
///   onChanged: (v) => setState(() => selected = v),
/// )
/// ```
class HUFSelect<T> extends StatefulWidget {
  const HUFSelect({
    super.key,
    this.label,
    this.hintText,
    this.placeholder = 'Select one',
    this.search = false,
    this.items,
    this.sections,
    this.value,
    this.values,
    this.onChanged,
    this.onMultiChanged,
    this.multiSelect = false,
    this.isFullWidth = false,
    this.enabled = true,
    this.placement = HUFSelectPlacement.bottom,
    this.isOpen,
    this.onOpenChanged,
    this.initialOpen = false,
    bool? closeOnSelect,
    this.itemBuilder,
    this.displayStringForValue,
    this.multiValueSeparator = ', ',
    this.multiValueLastSeparator = ' e ',
    this.menuOffset,
  })  : assert(
          items != null || sections != null,
          'Fornire items o sections.',
        ),
        assert(
          !multiSelect || (value == null && onChanged == null),
          'In multiSelect usare values e onMultiChanged, non value/onChanged.',
        ),
        assert(
          multiSelect || (values == null && onMultiChanged == null),
          'In selezione singola usare value e onChanged.',
        ),
        closeOnSelect = closeOnSelect ?? !multiSelect;

  final String? label;

  /// Testo suggerito nel campo quando non c'è selezione.
  final String? hintText;

  /// Alias di [hintText] per retrocompatibilità.
  final String placeholder;

  /// Se `true`, con il menu aperto il trigger diventa un campo di ricerca
  /// che filtra le voci per label e subtitle.
  final bool search;

  /// Elenco piatto di opzioni (alternativa a [sections]).
  final List<HUFSelectItem<T>>? items;

  /// Sezioni raggruppate con intestazione (alternativa a [items]).
  final List<HUFSelectSection<T>>? sections;

  /// Valore selezionato (singola).
  final T? value;

  /// Valori selezionati (multipla).
  final Set<T>? values;

  /// Callback selezione singola.
  final ValueChanged<T?>? onChanged;

  /// Callback selezione multipla.
  final ValueChanged<Set<T>>? onMultiChanged;

  final bool multiSelect;

  /// `false` (default): larghezza del contenuto ([HUFShrinkWrapWidth]).
  /// `true`: occupa tutta la larghezza disponibile del genitore.
  final bool isFullWidth;

  final bool enabled;

  /// Posizione preferita del menu; se non c'è spazio si capovolge automaticamente.
  final HUFSelectPlacement placement;

  /// Stato aperto controllato dall'esterno.
  final bool? isOpen;

  final ValueChanged<bool>? onOpenChanged;
  final bool initialOpen;

  /// Chiude il menu dopo la selezione (default `true`; in multiSelect usare `false`).
  final bool closeOnSelect;

  /// Layout custom della voce; se null usa il layout predefinito del design system.
  final HUFSelectItemBuilder<T>? itemBuilder;

  /// Testo mostrato nel trigger per un valore (singola o multipla).
  final String Function(T value)? displayStringForValue;

  /// Separatore tra valori multipli (tranne l'ultimo).
  final String multiValueSeparator;

  /// Separatore prima dell'ultimo valore in multi-select (es. « e »).
  final String multiValueLastSeparator;

  /// Gap tra trigger e menu; se null usa [HUFSelectMetrics.menuGap].
  final double? menuOffset;

  @override
  State<HUFSelect<T>> createState() => _HUFSelectState<T>();
}

class _HUFSelectState<T> extends State<HUFSelect<T>> {
  final _triggerKey = GlobalKey();
  final _fieldController = TextEditingController();
  final _fieldFocusNode = FocusNode();
  final Object _tapRegionGroup = Object();
  OverlayEntry? _overlayEntry;
  int _overlayGeneration = 0;

  late bool _isOpen;
  String _searchQuery = '';

  /// Selezione locale mentre il menu è aperto (aggiornamento immediato del popup).
  Set<T>? _menuSelectedValues;

  String get _effectiveHintText => widget.hintText ?? widget.placeholder;

  bool get _isControlled => widget.isOpen != null;
  bool get _open => _isControlled ? widget.isOpen! : _isOpen;
  bool get _isDisabled => !widget.enabled;

  List<HUFSelectItem<T>> get _allItems {
    if (widget.items != null) return widget.items!;
    return widget.sections!
        .expand((section) => section.items)
        .toList(growable: false);
  }

  bool _matchesSearch(HUFSelectItem<T> item) {
    if (!widget.search || _searchQuery.isEmpty) return true;
    final query = _searchQuery.toLowerCase();
    if (item.label.toLowerCase().contains(query)) return true;
    final subtitle = item.subtitle;
    if (subtitle != null && subtitle.toLowerCase().contains(query)) {
      return true;
    }
    return false;
  }

  List<HUFSelectItem<T>> get _filteredItems {
    return _allItems.where(_matchesSearch).toList(growable: false);
  }

  List<HUFSelectSection<T>>? get _filteredSections {
    if (widget.sections == null) return null;
    final result = <HUFSelectSection<T>>[];
    for (final section in widget.sections!) {
      final items =
          section.items.where(_matchesSearch).toList(growable: false);
      if (items.isEmpty) continue;
      result.add(
        HUFSelectSection<T>(
          header: section.header,
          items: items,
          showSeparatorBefore: section.showSeparatorBefore,
        ),
      );
    }
    return result;
  }

  HUFSelectItem<T>? _itemForValue(T value) {
    for (final item in _allItems) {
      if (item.value == value) return item;
    }
    return null;
  }

  String _labelForValue(T value) {
    return widget.displayStringForValue?.call(value) ??
        _itemForValue(value)?.label ??
        value.toString();
  }

  Set<T> get _effectiveSelectedValues =>
      _menuSelectedValues ?? widget.values ?? {};

  String? _triggerLabel() {
    if (widget.multiSelect) {
      final selected = _effectiveSelectedValues;
      if (selected.isEmpty) return null;
      final labels = selected.map(_labelForValue).toList();
      if (labels.length == 1) return labels.first;
      if (labels.length == 2) {
        return '${labels[0]}${widget.multiValueLastSeparator}${labels[1]}';
      }
      final head = labels.sublist(0, labels.length - 1).join(widget.multiValueSeparator);
      return '$head${widget.multiValueLastSeparator}${labels.last}';
    }
    final value = widget.value;
    if (value == null) return null;
    return _labelForValue(value);
  }

  bool _isSelected(T value) {
    if (widget.multiSelect) {
      return _effectiveSelectedValues.contains(value);
    }
    return widget.value == value;
  }

  void _syncMenuSelectionFromWidget() {
    if (widget.multiSelect) {
      _menuSelectedValues = Set<T>.from(widget.values ?? {});
    }
  }

  void _refreshOpenMenu() {
    if (!_open || _overlayEntry == null) return;
    _overlayEntry!.markNeedsBuild();
  }

  void _scheduleRefreshOpenMenu() {
    if (!_open || _overlayEntry == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _open) _overlayEntry?.markNeedsBuild();
    });
  }

  @override
  void initState() {
    super.initState();
    _isOpen = widget.isOpen ?? widget.initialOpen;
    _syncFieldFocusPolicy();
    _syncFieldDisplayText();
    if (_isOpen) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _open) _showOverlay();
      });
    }
  }

  @override
  void didUpdateWidget(HUFSelect<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isControlled && widget.isOpen != oldWidget.isOpen) {
      _setOpen(widget.isOpen!, notify: false);
    }
    if (widget.search != oldWidget.search || widget.enabled != oldWidget.enabled) {
      _syncFieldFocusPolicy();
    }
    if (widget.placement != oldWidget.placement && _open) {
      _scheduleRefreshOpenMenu();
    }
    if (_open && widget.multiSelect && widget.values != oldWidget.values) {
      _syncMenuSelectionFromWidget();
      _scheduleRefreshOpenMenu();
    }
    if (_open &&
        !widget.multiSelect &&
        widget.value != oldWidget.value) {
      _scheduleRefreshOpenMenu();
    }
    if (!_open) {
      if (widget.value != oldWidget.value ||
          widget.values != oldWidget.values ||
          widget.hintText != oldWidget.hintText ||
          widget.placeholder != oldWidget.placeholder) {
        _syncFieldDisplayText();
      }
    }
  }

  @override
  void dispose() {
    _overlayGeneration++;
    _removeOverlay();
    _fieldController.dispose();
    _fieldFocusNode.dispose();
    super.dispose();
  }

  void _syncFieldDisplayText() {
    if (_open && widget.search) return;
    final label = _triggerLabel();
    if (label == null) {
      if (_fieldController.text.isNotEmpty) {
        _fieldController.clear();
      }
      return;
    }
    if (_fieldController.text != label) {
      _fieldController.value = TextEditingValue(
        text: label,
        selection: TextSelection.collapsed(offset: label.length),
      );
    }
  }

  void _beginSearchSession() {
    _searchQuery = '';
    _fieldController.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _open && widget.search) {
        _fieldFocusNode.requestFocus();
      }
    });
  }

  void _endSearchSession() {
    _searchQuery = '';
    _syncFieldDisplayText();
  }

  /// Solo in modalità [HUFSelect.search] con menu aperto il trigger può ricevere focus.
  void _syncFieldFocusPolicy() {
    final allowFocus = widget.enabled && widget.search && _open;
    if (_fieldFocusNode.canRequestFocus != allowFocus) {
      _fieldFocusNode.canRequestFocus = allowFocus;
    }
    if (!allowFocus && _fieldFocusNode.hasFocus) {
      _fieldFocusNode.unfocus();
    }
  }

  void _onSearchChanged(String query) {
    setState(() => _searchQuery = query);
    _refreshOpenMenu();
  }

  void _toggle() {
    if (_isDisabled) return;
    final current = _isControlled ? widget.isOpen! : _isOpen;
    _setOpen(!current);
  }

  void _close() {
    _menuSelectedValues = null;
    _setOpen(false);
  }

  void _setOpen(bool open, {bool notify = true}) {
    final current = _isControlled ? widget.isOpen! : _isOpen;
    if (current == open) return;

    if (!_isControlled) {
      setState(() => _isOpen = open);
    }

    _syncFieldFocusPolicy();

    if (open) {
      if (widget.search) {
        _beginSearchSession();
      }
      _showOverlay();
    } else {
      if (widget.search) {
        _endSearchSession();
      } else {
        _syncFieldDisplayText();
      }
      _removeOverlay();
      _syncFieldFocusPolicy();
    }

    if (notify) {
      widget.onOpenChanged?.call(open);
    }
  }

  void _showOverlay() {
    if (!mounted) return;

    _syncMenuSelectionFromWidget();
    _removeOverlay();
    final generation = ++_overlayGeneration;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_open || generation != _overlayGeneration) return;

      final triggerBox =
          _triggerKey.currentContext?.findRenderObject() as RenderBox?;
      if (triggerBox != null && triggerBox.hasSize) {
        _triggerWidth = triggerBox.size.width;
      }

      final overlay = Overlay.maybeOf(context, rootOverlay: true);
      if (overlay == null) return;

      final gap = _menuGapFor(context);
      Offset? initialPosition;
      final overlayBox =
          overlay.context.findRenderObject() as RenderBox?;
      if (triggerBox != null &&
          triggerBox.hasSize &&
          overlayBox != null &&
          overlayBox.hasSize) {
        final mediaQuery = MediaQuery.of(context);
        final viewport = Rect.fromLTWH(
          mediaQuery.padding.left,
          mediaQuery.padding.top,
          mediaQuery.size.width - mediaQuery.padding.horizontal,
          mediaQuery.size.height - mediaQuery.padding.vertical,
        );
        final triggerRect =
            triggerBox.localToGlobal(Offset.zero) & triggerBox.size;
        final globalTopLeft = _menuTopLeftFor(
          triggerRect: triggerRect,
          menuSize: Size(triggerRect.width, 0),
          placement: widget.placement,
          gap: gap,
          viewport: viewport,
        );
        initialPosition = overlayBox.globalToLocal(globalTopLeft);
      }

      _overlayEntry = OverlayEntry(
        builder: (overlayContext) => _HUFSelectOverlay<T>(
          triggerKey: _triggerKey,
          tapRegionGroup: _tapRegionGroup,
          requestedPlacement: widget.placement,
          gap: gap,
          initialPosition: initialPosition,
          onClose: _close,
          triggerWidth: _triggerWidth,
          child: _buildMenu(overlayContext),
        ),
      );
      overlay.insert(_overlayEntry!);
    });
  }

  double? _triggerWidth;

  void _removeOverlay() {
    _overlayGeneration++;
    final entry = _overlayEntry;
    _overlayEntry = null;
    entry?.remove();
  }

  double _menuGapFor(BuildContext context) {
    final metrics = hufSelectMetricsFor(context.hufTheme.borderRadius);
    return widget.menuOffset ?? metrics.menuGap;
  }

  void _handleSelect(T value) {
    if (widget.multiSelect) {
      final current = Set<T>.from(_effectiveSelectedValues);
      if (current.contains(value)) {
        current.remove(value);
      } else {
        current.add(value);
      }
      _menuSelectedValues = current;
      setState(() {});
      _refreshOpenMenu();
      widget.onMultiChanged?.call(Set<T>.unmodifiable(current));
      if (widget.closeOnSelect) _close();
      return;
    }

    widget.onChanged?.call(value);
    if (widget.closeOnSelect) {
      _close();
    } else {
      _syncFieldDisplayText();
    }
  }

  Widget _buildMenu(BuildContext context) {
    final theme = context.hufTheme;
    final metrics = hufSelectMetricsFor(theme.borderRadius);
    final colors = hufSelectColorsFor(theme.colors);

    final sections = _filteredSections;
    if (sections != null) {
      if (sections.isEmpty) {
        return _HUFSelectMenuPanel(
          metrics: metrics,
          colors: colors,
          child: _HUFSelectEmptyResults(metrics: metrics, colors: colors),
        );
      }

      return _HUFSelectMenuPanel(
        metrics: metrics,
        colors: colors,
        child: DefaultTextStyle(
          style: hufSelectTextStyle(
            fontSize: metrics.itemFontSize,
            color: colors.itemForeground,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < sections.length; i++)
                _buildSection(context, sections[i], i > 0),
            ],
          ),
        ),
      );
    }

    final items = _filteredItems;
    if (items.isEmpty) {
      return _HUFSelectMenuPanel(
        metrics: metrics,
        colors: colors,
        child: _HUFSelectEmptyResults(metrics: metrics, colors: colors),
      );
    }

    return _HUFSelectMenuPanel(
      metrics: metrics,
      colors: colors,
      child: DefaultTextStyle(
        style: hufSelectTextStyle(
          fontSize: metrics.itemFontSize,
          color: colors.itemForeground,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final item in items) _buildItem(context, item),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    HUFSelectSection<T> section,
    bool previousSectionExists,
  ) {
    final children = <Widget>[];

    if (section.showSeparatorBefore &&
        (previousSectionExists || section.header != null)) {
      children.add(const Padding(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: HUFSeparator(),
      ));
    }

    if (section.header != null) {
      children.add(_HUFSelectSectionHeader(label: section.header!));
    }

    for (final item in section.items) {
      children.add(_buildItem(context, item));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }

  Widget _buildItem(BuildContext context, HUFSelectItem<T> item) {
    final isSelected = _isSelected(item.value);
    final onTap = _isDisabled || !item.enabled
        ? null
        : () => _handleSelect(item.value);

    if (widget.itemBuilder != null) {
      return widget.itemBuilder!(context, item, isSelected, onTap);
    }

    return _HUFSelectDefaultItem<T>(
      item: item,
      isSelected: isSelected,
      multiSelect: widget.multiSelect,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchActive = widget.search && _open;

    return KeyedSubtree(
      key: _triggerKey,
      child: TapRegion(
        groupId: _tapRegionGroup,
        child: HUFInput(
          label: widget.label,
          hintText: _effectiveHintText,
          controller: _fieldController,
          focusNode: _fieldFocusNode,
          enabled: widget.enabled,
          isFullWidth: widget.isFullWidth,
          readOnly: !searchActive,
          autofocus: searchActive,
          onChanged: searchActive ? _onSearchChanged : null,
          onTap: searchActive ? null : _toggle,
          suffix: Icon(
            _open
                ? Icons.keyboard_arrow_up_rounded
                : Icons.keyboard_arrow_down_rounded,
          ),
        ),
      ),
    );
  }
}

class _HUFSelectEmptyResults extends StatelessWidget {
  const _HUFSelectEmptyResults({
    required this.metrics,
    required this.colors,
  });

  final HUFSelectMetrics metrics;
  final HUFSelectColors colors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: metrics.itemVerticalPadding,
        horizontal: metrics.itemHorizontalPadding,
      ),
      child: Text(
        'Nessun risultato',
        style: hufSelectTextStyle(
          fontSize: metrics.itemFontSize,
          color: colors.itemSubtitle,
        ),
      ),
    );
  }
}

class _HUFSelectMenuPanel extends StatelessWidget {
  const _HUFSelectMenuPanel({
    required this.metrics,
    required this.colors,
    required this.child,
  });

  final HUFSelectMetrics metrics;
  final HUFSelectColors colors;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.menuBackground,
        borderRadius: BorderRadius.circular(metrics.borderRadius),
        border: Border.all(color: colors.menuBorder),
        boxShadow: metrics.shadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(metrics.borderRadius),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: metrics.menuMaxHeight),
          child: SingleChildScrollView(
            padding: metrics.menuPadding,
            child: child,
          ),
        ),
      ),
    );
  }
}

class _HUFSelectSectionHeader extends StatelessWidget {
  const _HUFSelectSectionHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = context.hufTheme;
    final metrics = hufSelectMetricsFor(theme.borderRadius);
    final colors = hufSelectColorsFor(theme.colors);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        metrics.itemHorizontalPadding,
        metrics.sectionHeaderVerticalPadding,
        metrics.itemHorizontalPadding,
        metrics.sectionHeaderVerticalPadding / 2,
      ),
      child: Text(
        label,
        style: hufSelectTextStyle(
          fontSize: metrics.sectionHeaderFontSize,
          fontWeight: FontWeight.w500,
          color: colors.sectionHeader,
        ),
      ),
    );
  }
}

class _HUFSelectDefaultItem<T> extends StatefulWidget {
  const _HUFSelectDefaultItem({
    required this.item,
    required this.isSelected,
    required this.multiSelect,
    required this.onTap,
  });

  final HUFSelectItem<T> item;
  final bool isSelected;
  final bool multiSelect;
  final VoidCallback? onTap;

  @override
  State<_HUFSelectDefaultItem<T>> createState() => _HUFSelectDefaultItemState<T>();
}

class _HUFSelectDefaultItemState<T> extends State<_HUFSelectDefaultItem<T>> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.hufTheme;
    final metrics = hufSelectMetricsFor(theme.borderRadius);
    final colors = hufSelectColorsFor(theme.colors);
    final radius = BorderRadius.circular(metrics.borderRadius);
    final highlight = widget.isSelected || _pressed;

    final enabled = widget.onTap != null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          onHighlightChanged: enabled
              ? (value) => setState(() => _pressed = value)
              : null,
          borderRadius: radius,
          child: Ink(
            decoration: BoxDecoration(
              color: highlight ? colors.itemHighlight : null,
              borderRadius: radius,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: metrics.itemVerticalPadding,
                horizontal: metrics.itemHorizontalPadding,
              ),
              child: Row(
                children: [
                  if (widget.item.leading != null) ...[
                    widget.item.leading!,
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: widget.item.subtitle == null
                        ? Text(
                            widget.item.label,
                            style: hufSelectTextStyle(
                              fontSize: metrics.itemFontSize,
                              fontWeight: FontWeight.w500,
                              color: enabled
                                  ? colors.itemForeground
                                  : colors.disabledForeground,
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.item.label,
                                style: hufSelectTextStyle(
                                  fontSize: metrics.itemFontSize,
                                  fontWeight: FontWeight.w600,
                                  color: enabled
                                      ? colors.itemForeground
                                      : colors.disabledForeground,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                widget.item.subtitle!,
                                style: hufSelectTextStyle(
                                  fontSize: metrics.itemSubtitleFontSize,
                                  color: enabled
                                      ? colors.itemSubtitle
                                      : colors.disabledForeground,
                                ),
                              ),
                            ],
                          ),
                  ),
                  if (widget.multiSelect && widget.isSelected)
                    Icon(
                      Icons.check_rounded,
                      size: metrics.checkIconSize,
                      color: colors.checkIcon,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HUFSelectOverlay<T> extends StatefulWidget {
  const _HUFSelectOverlay({
    required this.triggerKey,
    required this.tapRegionGroup,
    required this.requestedPlacement,
    required this.gap,
    required this.initialPosition,
    required this.onClose,
    required this.triggerWidth,
    required this.child,
  });

  final GlobalKey triggerKey;
  final Object tapRegionGroup;
  final HUFSelectPlacement requestedPlacement;
  final double gap;
  final Offset? initialPosition;
  final VoidCallback onClose;
  final double? triggerWidth;
  final Widget child;

  @override
  State<_HUFSelectOverlay<T>> createState() => _HUFSelectOverlayState<T>();
}

class _HUFSelectOverlayState<T> extends State<_HUFSelectOverlay<T>>
    with SingleTickerProviderStateMixin {
  final _menuKey = GlobalKey();
  Offset? _position;
  HUFSelectPlacement? _resolvedPlacement;
  int _layoutAttempts = 0;
  bool _positionFinalized = false;

  static const _maxLayoutAttempts = 30;
  static const _menuEntranceDuration = Duration(milliseconds: 160);

  late final AnimationController _entranceController;
  late final Animation<double> _entranceAnimation;

  @override
  void initState() {
    super.initState();
    _position = widget.initialPosition;
    _entranceController = AnimationController(
      vsync: this,
      duration: _menuEntranceDuration,
    );
    _entranceAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _updatePosition());
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_HUFSelectOverlay<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.requestedPlacement != widget.requestedPlacement) {
      _resolvedPlacement = null;
      _position = null;
      _positionFinalized = false;
      _layoutAttempts = 0;
      _entranceController.reset();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _updatePosition());
  }

  Alignment _scaleAlignmentFor(HUFSelectPlacement placement) {
    return switch (placement) {
      HUFSelectPlacement.bottom => Alignment.topCenter,
      HUFSelectPlacement.top => Alignment.bottomCenter,
    };
  }

  void _scheduleLayoutRetry() {
    if (_layoutAttempts++ < _maxLayoutAttempts) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _updatePosition());
    }
  }

  void _updatePosition() {
    if (!mounted) return;

    final overlayBox = context.findRenderObject() as RenderBox?;
    final triggerBox =
        widget.triggerKey.currentContext?.findRenderObject() as RenderBox?;
    final menuBox = _menuKey.currentContext?.findRenderObject() as RenderBox?;

    if (overlayBox == null ||
        !overlayBox.hasSize ||
        triggerBox == null ||
        !triggerBox.hasSize) {
      _scheduleLayoutRetry();
      return;
    }

    final mediaQuery = MediaQuery.of(context);
    final viewport = Rect.fromLTWH(
      mediaQuery.padding.left,
      mediaQuery.padding.top,
      mediaQuery.size.width - mediaQuery.padding.horizontal,
      mediaQuery.size.height - mediaQuery.padding.vertical,
    );

    final triggerGlobal = triggerBox.localToGlobal(Offset.zero);
    final triggerRect = triggerGlobal & triggerBox.size;
    final placement = _resolvedPlacement ?? widget.requestedPlacement;

    if (menuBox == null || !menuBox.hasSize) {
      final provisionalGlobal = _menuTopLeftFor(
        triggerRect: triggerRect,
        menuSize: Size(triggerRect.width, 0),
        placement: placement,
        gap: widget.gap,
        viewport: viewport,
      );
      final local = overlayBox.globalToLocal(provisionalGlobal);
      if (_position != local) {
        setState(() => _position = local);
      }
      _scheduleLayoutRetry();
      return;
    }

    _layoutAttempts = 0;

    final menuSize = menuBox.size;
    final resolved = _resolvePlacementFor(
      requested: widget.requestedPlacement,
      triggerRect: triggerRect,
      menuSize: menuSize,
      viewport: viewport,
      gap: widget.gap,
    );

    final globalTopLeft = _menuTopLeftFor(
      triggerRect: triggerRect,
      menuSize: menuSize,
      placement: resolved,
      gap: widget.gap,
      viewport: viewport,
    );

    final localTopLeft = overlayBox.globalToLocal(globalTopLeft);
    final shouldAnimate = !_positionFinalized;

    if (resolved != _resolvedPlacement ||
        _position != localTopLeft ||
        shouldAnimate) {
      setState(() {
        _resolvedPlacement = resolved;
        _position = localTopLeft;
        _positionFinalized = true;
      });
      if (shouldAnimate) {
        _entranceController.forward(from: 0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = widget.triggerWidth;
    final placement = _resolvedPlacement ?? widget.requestedPlacement;

    final menu = KeyedSubtree(
      key: _menuKey,
      child: width != null
          ? SizedBox(width: width, child: widget.child)
          : widget.child,
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        if (_position != null)
          Positioned(
            left: _position!.dx,
            top: _position!.dy,
            child: TapRegion(
              groupId: widget.tapRegionGroup,
              onTapOutside: (_) => widget.onClose(),
              child: FadeTransition(
                opacity: _entranceAnimation,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.96, end: 1).animate(
                    _entranceAnimation,
                  ),
                  alignment: _scaleAlignmentFor(placement),
                  child: menu,
                ),
              ),
            ),
          )
        else
          Positioned.fill(
            child: IgnorePointer(
              child: Opacity(opacity: 0, child: menu),
            ),
          ),
      ],
    );
  }
}

Offset _menuTopLeftFor({
  required Rect triggerRect,
  required Size menuSize,
  required HUFSelectPlacement placement,
  required double gap,
  required Rect viewport,
}) {
  final raw = switch (placement) {
    HUFSelectPlacement.bottom => Offset(
        triggerRect.left,
        triggerRect.bottom + gap,
      ),
    HUFSelectPlacement.top => Offset(
        triggerRect.left,
        triggerRect.top - gap - menuSize.height,
      ),
  };

  return Offset(
    raw.dx.clamp(
      viewport.left,
      viewport.right - menuSize.width,
    ),
    raw.dy.clamp(
      viewport.top,
      viewport.bottom - menuSize.height,
    ),
  );
}

Rect _menuRectFor({
  required Rect triggerRect,
  required Size menuSize,
  required HUFSelectPlacement placement,
  required double gap,
}) {
  final topLeft = _menuTopLeftFor(
    triggerRect: triggerRect,
    menuSize: menuSize,
    placement: placement,
    gap: gap,
    viewport: const Rect.fromLTWH(0, 0, double.infinity, double.infinity),
  );
  return topLeft & menuSize;
}

bool _fitsInViewport(Rect rect, Rect viewport) {
  return rect.left >= viewport.left &&
      rect.top >= viewport.top &&
      rect.right <= viewport.right &&
      rect.bottom <= viewport.bottom;
}

HUFSelectPlacement _resolvePlacementFor({
  required HUFSelectPlacement requested,
  required Rect triggerRect,
  required Size menuSize,
  required Rect viewport,
  required double gap,
}) {
  final primary = _menuRectFor(
    triggerRect: triggerRect,
    menuSize: menuSize,
    placement: requested,
    gap: gap,
  );

  if (_fitsInViewport(primary, viewport)) {
    return requested;
  }

  final flipped = hufSelectFlipPlacement(requested);
  final fallback = _menuRectFor(
    triggerRect: triggerRect,
    menuSize: menuSize,
    placement: flipped,
    gap: gap,
  );

  if (_fitsInViewport(fallback, viewport)) {
    return flipped;
  }

  return requested;
}
