import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../layout/huf_shrink_wrap_width.dart';
import '../../theme/huf_theme.dart';
import '../field/huf_field_style.dart';
import 'huf_input_formatters.dart';
import 'huf_input_type.dart';

/// Campo di testo del design system Hero UI Flutter.
///
/// Supporta [HUFInputType] (`text`, `email`, `password`, `otp`, `tel`),
/// icona leading ([icon]), pulsante clear ([clear]) e perdita focus al tap esterno.
///
/// Usato anche come shell del trigger di [HUFSelect] (anche in modalità ricerca).
class HUFInput extends StatefulWidget {
  const HUFInput({
    super.key,
    this.label,
    this.hintText,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.autofocus = false,
    this.isFullWidth = false,
    this.type = HUFInputType.text,
    this.icon = false,
    this.clear = false,
    this.otpLength = 4,
    this.telPrefix = '+39',
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.suffix,
    this.inputFormatters,
  }) : assert(otpLength > 0, 'otpLength deve essere maggiore di zero');

  /// Label opzionale sopra il campo.
  final String? label;

  /// Testo suggerito quando il campo è vuoto.
  final String? hintText;

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;

  final bool enabled;
  final bool readOnly;
  final bool obscureText;
  final bool autofocus;

  /// `false` (default): larghezza del contenuto.
  /// `true`: occupa tutta la larghezza del genitore.
  /// Ignorato quando [type] è [HUFInputType.otp].
  final bool isFullWidth;

  /// Tipo di input (default [HUFInputType.text]).
  final HUFInputType type;

  /// Icona a sinistra: `false` (default) nessuna icona; `true` icona predefinita
  /// per il [type]; [Widget] o [IconData] per un'icona custom.
  final Object? icon;

  /// Mostra l'icona × a destra per svuotare il valore quando non è vuoto.
  final bool clear;

  /// Numero di celle OTP (solo [HUFInputType.otp]).
  final int otpLength;

  /// Prefisso telefonico fisso a sinistra (solo [HUFInputType.tel]).
  final String telPrefix;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int maxLines;
  final Widget? suffix;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<HUFInput> createState() => _HUFInputState();
}

class _HUFInputState extends State<HUFInput> {
  late FocusNode _focusNode;
  bool _ownsFocusNode = false;
  bool _focused = false;
  bool _passwordVisible = false;
  late TextEditingController _textController;
  bool _ownsTextController = false;

  @override
  void initState() {
    super.initState();
    _initFocusNode();
    _initTextController();
    if (widget.type == HUFInputType.otp) {
      return;
    }
    _textController.addListener(_handleTextChange);
  }

  void _initFocusNode() {
    _ownsFocusNode = widget.focusNode == null;
    _focusNode = widget.focusNode ?? FocusNode();
    _focused = _focusNode.hasFocus;
    _focusNode.addListener(_handleFocusChange);
  }

  void _initTextController() {
    if (widget.type == HUFInputType.otp) {
      return;
    }
    _ownsTextController = widget.controller == null;
    _textController = widget.controller ?? TextEditingController();
  }

  @override
  void didUpdateWidget(HUFInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      _focusNode.removeListener(_handleFocusChange);
      if (_ownsFocusNode) {
        _focusNode.dispose();
      }
      _initFocusNode();
    }
    if (widget.type != oldWidget.type) {
      if (oldWidget.type != HUFInputType.otp &&
          widget.type != HUFInputType.otp) {
        // nessun cambio strutturale
      } else {
        setState(() {});
      }
    }
    if (widget.controller != oldWidget.controller &&
        widget.type != HUFInputType.otp) {
      _textController.removeListener(_handleTextChange);
      if (_ownsTextController) {
        _textController.dispose();
      }
      _initTextController();
      _textController.addListener(_handleTextChange);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    if (_ownsFocusNode) {
      _focusNode.dispose();
    }
    if (widget.type != HUFInputType.otp) {
      _textController.removeListener(_handleTextChange);
      if (_ownsTextController) {
        _textController.dispose();
      }
    }
    super.dispose();
  }

  void _handleFocusChange() {
    final focused = _focusNode.hasFocus;
    if (focused != _focused) {
      setState(() => _focused = focused);
    }
  }

  void _handleTextChange() {
    if (widget.clear || widget.type == HUFInputType.password) {
      setState(() {});
    }
  }

  void _unfocus() {
    if (_focusNode.hasFocus) {
      _focusNode.unfocus();
    }
    FocusManager.instance.primaryFocus?.unfocus();
  }

  bool get _effectiveFullWidth =>
      widget.type == HUFInputType.otp ? false : widget.isFullWidth;

  @override
  Widget build(BuildContext context) {
    if (widget.type == HUFInputType.otp) {
      return _buildOtp(context);
    }

    return _buildStandardField(context);
  }

  Widget _buildStandardField(BuildContext context) {
    final theme = context.hufTheme;
    final metrics = hufFieldMetricsFor(theme.borderRadius);
    final colors = hufFieldColorsFor(theme.colors);
    final isDisabled = !widget.enabled;
    final radius = BorderRadius.circular(metrics.borderRadius);
    final borderColor = _focused ? colors.focusBorder : colors.border;

    final textColor = isDisabled
        ? colors.disabledForeground
        : colors.foreground;

    final field = TapRegion(
      onTapOutside: (_) => _unfocus(),
      child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isDisabled
            ? null
            : widget.readOnly
                ? widget.onTap
                : null,
        borderRadius: radius,
        child: AnimatedContainer(
          duration: kHufFieldBorderAnimationDuration,
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: isDisabled
                ? colors.background.withValues(alpha: 0.6)
                : colors.background,
            borderRadius: radius,
            border: Border.all(
              color: borderColor,
              width: metrics.focusBorderWidth,
            ),
          ),
          child: SizedBox(
            width: _effectiveFullWidth ? double.infinity : null,
            height: metrics.height,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: metrics.horizontalPadding,
              ),
              child: _buildFieldRow(textColor, metrics, colors),
            ),
          ),
        ),
      ),
      ),
    );

    return _wrapWithLabel(field, metrics, colors);
  }

  Widget _wrapWithLabel(
    Widget field,
    HUFFieldMetrics metrics,
    HUFFieldColors colors,
  ) {
    Widget content;
    if (widget.label == null) {
      content = field;
    } else {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.label!,
            style: hufFieldTextStyle(
              fontSize: metrics.labelFontSize,
              fontWeight: FontWeight.w500,
              color: colors.label,
            ),
          ),
          SizedBox(height: metrics.labelGap),
          field,
        ],
      );
    }

    if (_effectiveFullWidth) {
      return SizedBox(width: double.infinity, child: content);
    }

    return HUFShrinkWrapWidth(child: content);
  }

  Widget _buildFieldRow(
    Color textColor,
    HUFFieldMetrics metrics,
    HUFFieldColors colors,
  ) {
    final leading = _resolveLeadingIcon(metrics, colors);
    final trailing = _buildTrailingActions(metrics, colors);

    final row = Row(
      mainAxisSize:
          _effectiveFullWidth ? MainAxisSize.max : MainAxisSize.min,
      children: [
        if (leading != null) ...[
          leading,
          SizedBox(width: metrics.horizontalPadding / 2),
        ],
        if (widget.type == HUFInputType.tel) ...[
          Text(
            widget.telPrefix,
            style: hufFieldTextStyle(
              fontSize: metrics.fontSize,
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: metrics.horizontalPadding / 2),
        ],
        if (_effectiveFullWidth)
          Expanded(child: _buildTextField(textColor, metrics, colors))
        else
          Flexible(
            fit: FlexFit.loose,
            child: _buildTextField(textColor, metrics, colors),
          ),
        ...trailing,
        if (widget.suffix != null) ...[
          const SizedBox(width: 8),
          IconTheme(
            data: IconThemeData(
              color: !widget.enabled
                  ? colors.disabledForeground
                  : colors.foreground,
              size: metrics.iconSize,
            ),
            child: widget.suffix!,
          ),
        ],
      ],
    );

    if (_effectiveFullWidth) return row;
    return IntrinsicWidth(child: row);
  }

  Widget? _resolveLeadingIcon(
    HUFFieldMetrics metrics,
    HUFFieldColors colors,
  ) {
    final icon = widget.icon;
    if (icon == false || icon == null) {
      return null;
    }

    final IconData iconData;
    if (icon == true) {
      iconData = _defaultIconForType(widget.type);
    } else if (icon is IconData) {
      iconData = icon;
    } else if (icon is Widget) {
      return IconTheme(
        data: IconThemeData(
          color: !widget.enabled
              ? colors.disabledForeground
              : colors.foreground,
          size: metrics.iconSize,
        ),
        child: icon,
      );
    } else {
      return null;
    }

    return Icon(
      iconData,
      size: metrics.iconSize,
      color: !widget.enabled
          ? colors.disabledForeground
          : colors.foreground,
    );
  }

  IconData _defaultIconForType(HUFInputType type) {
    return switch (type) {
      HUFInputType.text => Icons.short_text_rounded,
      HUFInputType.email => Icons.email_outlined,
      HUFInputType.password => Icons.lock_outline_rounded,
      HUFInputType.tel => Icons.phone_outlined,
      HUFInputType.otp => Icons.pin_outlined,
    };
  }

  List<Widget> _buildTrailingActions(
    HUFFieldMetrics metrics,
    HUFFieldColors colors,
  ) {
    final actions = <Widget>[];
    final canInteract = widget.enabled && !widget.readOnly;
    final hasText = _textController.text.isNotEmpty;

    if (widget.clear && canInteract && hasText) {
      actions.add(
        _InputIconButton(
          icon: Icons.close_rounded,
          metrics: metrics,
          colors: colors,
          enabled: widget.enabled,
          onPressed: _clearValue,
        ),
      );
    }

    if (widget.type == HUFInputType.password && canInteract) {
      if (actions.isNotEmpty) {
        actions.add(const SizedBox(width: 4));
      }
      actions.add(
        _InputIconButton(
          icon: _passwordVisible
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          metrics: metrics,
          colors: colors,
          enabled: widget.enabled,
          onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
        ),
      );
    }

    if (actions.isEmpty) {
      return actions;
    }

    return [
      const SizedBox(width: 8),
      ...actions,
    ];
  }

  void _clearValue() {
    _textController.clear();
    widget.onChanged?.call('');
    setState(() {});
  }

  Widget _buildTextField(
    Color textColor,
    HUFFieldMetrics metrics,
    HUFFieldColors colors,
  ) {
    final obscure = widget.type == HUFInputType.password
        ? !_passwordVisible
        : widget.obscureText;

    return TextField(
      controller: _textController,
      focusNode: _focusNode,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      obscureText: obscure,
      autofocus: widget.autofocus,
      keyboardType: widget.keyboardType ?? _keyboardTypeFor(widget.type),
      textInputAction: widget.textInputAction,
      maxLines: widget.maxLines,
      inputFormatters: [
        ...?_formattersFor(widget.type),
        ...?widget.inputFormatters,
      ],
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      onTap: widget.readOnly ? widget.onTap : null,
      style: hufFieldTextStyle(
        fontSize: metrics.fontSize,
        color: textColor,
      ),
      cursorColor: colors.foreground,
      decoration: InputDecoration(
        isDense: true,
        border: InputBorder.none,
        hintText: widget.hintText,
        hintStyle: hufFieldTextStyle(
          fontSize: metrics.fontSize,
          color: colors.hint,
        ),
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  TextInputType? _keyboardTypeFor(HUFInputType type) {
    return switch (type) {
      HUFInputType.email => TextInputType.emailAddress,
      HUFInputType.tel => TextInputType.phone,
      HUFInputType.password => TextInputType.visiblePassword,
      _ => TextInputType.text,
    };
  }

  List<TextInputFormatter>? _formattersFor(HUFInputType type) {
    return switch (type) {
      HUFInputType.email => [HUFEmailInputFormatter()],
      HUFInputType.tel => [HUFDigitsOnlyInputFormatter()],
      _ => null,
    };
  }

  Widget _buildOtp(BuildContext context) {
    final theme = context.hufTheme;
    final metrics = hufFieldMetricsFor(theme.borderRadius);
    final colors = hufFieldColorsFor(theme.colors);

    final row = _HUFInputOtpRow(
      length: widget.otpLength,
      controller: widget.controller,
      focusNode: widget.focusNode,
      enabled: widget.enabled,
      autofocus: widget.autofocus,
      hintText: widget.hintText,
      icon: widget.icon,
      clear: widget.clear,
      metrics: metrics,
      colors: colors,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
    );

    return _wrapWithLabel(row, metrics, colors);
  }
}

class _InputIconButton extends StatelessWidget {
  const _InputIconButton({
    required this.icon,
    required this.metrics,
    required this.colors,
    required this.enabled,
    required this.onPressed,
  });

  final IconData icon;
  final HUFFieldMetrics metrics;
  final HUFFieldColors colors;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: enabled ? onPressed : null,
      icon: Icon(icon),
      iconSize: metrics.iconSize,
      color: enabled ? colors.foreground : colors.disabledForeground,
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(
        minWidth: metrics.iconSize,
        minHeight: metrics.iconSize,
      ),
      visualDensity: VisualDensity.compact,
      splashRadius: metrics.iconSize,
    );
  }
}

class _HUFInputOtpRow extends StatefulWidget {
  const _HUFInputOtpRow({
    required this.length,
    required this.controller,
    required this.focusNode,
    required this.enabled,
    required this.autofocus,
    required this.hintText,
    required this.icon,
    required this.clear,
    required this.metrics,
    required this.colors,
    required this.onChanged,
    required this.onSubmitted,
  });

  final int length;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool enabled;
  final bool autofocus;
  final String? hintText;
  final Object? icon;
  final bool clear;
  final HUFFieldMetrics metrics;
  final HUFFieldColors colors;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  State<_HUFInputOtpRow> createState() => _HUFInputOtpRowState();
}

class _HUFInputOtpRowState extends State<_HUFInputOtpRow> {
  late List<TextEditingController> _cellControllers;
  late List<FocusNode> _cellFocusNodes;
  late List<bool> _ownsCellControllers;
  late List<bool> _ownsCellFocusNodes;
  late List<VoidCallback> _cellFocusListeners;
  int _focusedIndex = -1;

  @override
  void initState() {
    super.initState();
    _initCells();
    _syncFromExternalController();
    widget.controller?.addListener(_syncFromExternalController);
    _cellFocusListeners = List.generate(widget.length, (i) {
      return () => _onCellFocusChange(i);
    });
    for (var i = 0; i < widget.length; i++) {
      _cellFocusNodes[i].addListener(_cellFocusListeners[i]);
      _cellControllers[i].addListener(_emitValue);
    }
    if (widget.autofocus && widget.enabled) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _cellFocusNodes.first.requestFocus();
        }
      });
    }
  }

  void _initCells() {
    _cellControllers = List.generate(widget.length, (_) => TextEditingController());
    _cellFocusNodes = List.generate(widget.length, (_) => FocusNode());
    _ownsCellControllers = List.filled(widget.length, true);
    _ownsCellFocusNodes = List.filled(widget.length, true);

    if (widget.focusNode != null) {
      _ownsCellFocusNodes[0] = false;
      _cellFocusNodes[0] = widget.focusNode!;
    }
  }

  @override
  void didUpdateWidget(_HUFInputOtpRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_syncFromExternalController);
      widget.controller?.addListener(_syncFromExternalController);
      _syncFromExternalController();
    }
    if (widget.length != oldWidget.length) {
      _disposeCells();
      _initCells();
      _cellFocusListeners = List.generate(widget.length, (i) {
        return () => _onCellFocusChange(i);
      });
      for (var i = 0; i < widget.length; i++) {
        _cellFocusNodes[i].addListener(_cellFocusListeners[i]);
        _cellControllers[i].addListener(_emitValue);
      }
      _syncFromExternalController();
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_syncFromExternalController);
    _disposeCells();
    super.dispose();
  }

  void _disposeCells() {
    for (var i = 0; i < _cellControllers.length; i++) {
      _cellFocusNodes[i].removeListener(_cellFocusListeners[i]);
      _cellControllers[i].removeListener(_emitValue);
      if (_ownsCellControllers[i]) {
        _cellControllers[i].dispose();
      }
      if (_ownsCellFocusNodes[i]) {
        _cellFocusNodes[i].dispose();
      }
    }
  }

  void _syncFromExternalController() {
    final text = widget.controller?.text ?? '';
    for (var i = 0; i < widget.length; i++) {
      final char = i < text.length ? text[i] : '';
      if (_cellControllers[i].text != char) {
        _cellControllers[i].text = char;
        _cellControllers[i].selection = TextSelection.collapsed(
          offset: char.length,
        );
      }
    }
  }

  void _onCellFocusChange(int index) {
    final focused = _cellFocusNodes[index].hasFocus;
    if (focused) {
      setState(() => _focusedIndex = index);
    } else if (_focusedIndex == index) {
      setState(() => _focusedIndex = -1);
    }
  }

  String get _combinedValue {
    return _cellControllers.map((c) => c.text).join();
  }

  void _emitValue() {
    final value = _combinedValue;
    if (widget.controller != null && widget.controller!.text != value) {
      widget.controller!.text = value;
      widget.controller!.selection = TextSelection.collapsed(
        offset: value.length,
      );
    }
    widget.onChanged?.call(value);
    setState(() {});
  }

  void _onCellChanged(int index, String value) {
    if (value.length > 1) {
      _fillFromPaste(index, value);
      return;
    }

    final char = value.isEmpty ? '' : value[value.length - 1];
    _cellControllers[index].text = char;
    _cellControllers[index].selection = TextSelection.collapsed(
      offset: char.length,
    );

    if (char.isNotEmpty && index < widget.length - 1) {
      _cellFocusNodes[index + 1].requestFocus();
    }

    _emitValue();

    if (_combinedValue.length == widget.length) {
      widget.onSubmitted?.call(_combinedValue);
    }
  }

  void _fillFromPaste(int startIndex, String raw) {
    final chars = raw.replaceAll(RegExp(r'\D'), '').split('');
    var index = startIndex;
    for (final char in chars) {
      if (index >= widget.length) break;
      _cellControllers[index].text = char;
      index++;
    }
    if (index < widget.length) {
      _cellFocusNodes[index].requestFocus();
    } else {
      _cellFocusNodes.last.unfocus();
      widget.onSubmitted?.call(_combinedValue);
    }
    _emitValue();
  }

  KeyEventResult _onCellKey(int index, KeyEvent event) {
    if (event is! KeyDownEvent) {
      return KeyEventResult.ignored;
    }
    if (event.logicalKey == LogicalKeyboardKey.backspace &&
        _cellControllers[index].text.isEmpty &&
        index > 0) {
      _cellFocusNodes[index - 1].requestFocus();
      _cellControllers[index - 1].clear();
      _emitValue();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  Widget? _resolveLeadingIcon() {
    final icon = widget.icon;
    if (icon == false || icon == null) {
      return null;
    }

    final IconData iconData;
    if (icon == true) {
      iconData = Icons.pin_outlined;
    } else if (icon is IconData) {
      iconData = icon;
    } else if (icon is Widget) {
      return IconTheme(
        data: IconThemeData(
          color: widget.enabled
              ? widget.colors.foreground
              : widget.colors.disabledForeground,
          size: widget.metrics.iconSize,
        ),
        child: icon,
      );
    } else {
      return null;
    }

    return Icon(
      iconData,
      size: widget.metrics.iconSize,
      color: widget.enabled
          ? widget.colors.foreground
          : widget.colors.disabledForeground,
    );
  }

  void _clearOtp() {
    for (final controller in _cellControllers) {
      controller.clear();
    }
    _cellFocusNodes.first.requestFocus();
    _emitValue();
  }

  @override
  Widget build(BuildContext context) {
    const gap = 8.0;
    final cellSize = widget.metrics.height;
    final leading = _resolveLeadingIcon();
    final showClear =
        widget.clear && widget.enabled && _combinedValue.isNotEmpty;

    return TapRegion(
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (leading != null) ...[
          leading,
          SizedBox(width: widget.metrics.horizontalPadding / 2),
        ],
        for (var i = 0; i < widget.length; i++) ...[
          if (i > 0) const SizedBox(width: gap),
          _OtpCell(
            controller: _cellControllers[i],
            focusNode: _cellFocusNodes[i],
            enabled: widget.enabled,
            focused: _focusedIndex == i,
            hintText: widget.hintText,
            metrics: widget.metrics,
            colors: widget.colors,
            size: cellSize,
            onChanged: (value) => _onCellChanged(i, value),
            onKeyEvent: (event) => _onCellKey(i, event),
          ),
        ],
        if (showClear) ...[
          const SizedBox(width: 8),
          _InputIconButton(
            icon: Icons.close_rounded,
            metrics: widget.metrics,
            colors: widget.colors,
            enabled: widget.enabled,
            onPressed: _clearOtp,
          ),
        ],
      ],
      ),
    );
  }
}

class _OtpCell extends StatelessWidget {
  const _OtpCell({
    required this.controller,
    required this.focusNode,
    required this.enabled,
    required this.focused,
    required this.hintText,
    required this.metrics,
    required this.colors,
    required this.size,
    required this.onChanged,
    required this.onKeyEvent,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool enabled;
  final bool focused;
  final String? hintText;
  final HUFFieldMetrics metrics;
  final HUFFieldColors colors;
  final double size;
  final ValueChanged<String> onChanged;
  final KeyEventResult Function(KeyEvent event) onKeyEvent;

  @override
  Widget build(BuildContext context) {
    final borderColor = focused ? colors.focusBorder : colors.border;
    final textColor =
        enabled ? colors.foreground : colors.disabledForeground;

    return AnimatedContainer(
      duration: kHufFieldBorderAnimationDuration,
      curve: Curves.easeOut,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: enabled
            ? colors.background
            : colors.background.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(metrics.borderRadius),
        border: Border.all(
          color: borderColor,
          width: metrics.focusBorderWidth,
        ),
      ),
      alignment: Alignment.center,
      child: Focus(
        onKeyEvent: (node, event) => onKeyEvent(event),
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          enabled: enabled,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          style: hufFieldTextStyle(
            fontSize: metrics.fontSize,
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
          cursorColor: colors.foreground,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(1),
          ],
          onChanged: onChanged,
          decoration: InputDecoration(
            isDense: true,
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: hufFieldTextStyle(
              fontSize: metrics.fontSize,
              color: colors.hint,
            ),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }
}
