import 'package:flutter/material.dart';

import '../../layout/huf_shrink_wrap_width.dart';
import '../../theme/huf_theme.dart';
import '../accordion/huf_accordion.dart';
import '../accordion/huf_accordion_style.dart';
import '../avatar/huf_avatar.dart';
import '../avatar/huf_avatar_group.dart';
import '../avatar/huf_avatar_style.dart';
import '../box_item/huf_box_item.dart';
import '../box_item/huf_box_item_size.dart';
import '../box_item/huf_box_item_style.dart';
import '../box_list/huf_box_list.dart';
import '../box_list/huf_box_list_layout.dart';
import '../box_list/huf_box_list_layout_utils.dart';
import '../button/huf_button.dart';
import '../button/huf_button_style.dart';
import '../button_group/huf_button_group.dart';
import '../button_group/huf_button_group_item.dart';
import '../card/huf_card.dart';
import '../card/huf_card_style.dart';
import '../checkbox/huf_checkbox.dart';
import '../checkbox/huf_checkbox_size.dart';
import '../checkbox/huf_checkbox_style.dart';
import '../checkbox_card/huf_checkbox_card.dart';
import '../checkbox_card/huf_checkbox_card_group.dart';
import '../checkbox_group/huf_checkbox_group.dart';
import '../chip/huf_chip.dart';
import '../chip/huf_chip_style.dart';
import '../field/huf_field_style.dart';
import '../input/huf_input.dart';
import '../input/huf_input_type.dart';
import '../progress/huf_progress.dart';
import '../progress/huf_progress_style.dart';
import '../radio_button/huf_radio_button.dart';
import '../radio_button/huf_radio_button_size.dart';
import '../radio_button/huf_radio_button_style.dart';
import '../radio_button_card/huf_radio_button_card.dart';
import '../radio_button_card/huf_radio_button_card_group.dart';
import '../radio_button_group/huf_radio_button_group.dart';
import '../select/huf_select.dart';
import '../separator/huf_separator.dart';
import '../separator/huf_separator_orientation.dart';
import '../separator/huf_separator_style.dart';
import '../slider/huf_range_slider.dart';
import '../slider/huf_slider.dart';
import '../slider/huf_slider_style.dart';
import '../switch/huf_switch.dart';
import '../switch/huf_switch_size.dart';
import '../switch/huf_switch_style.dart';
import '../switch_card/huf_switch_card.dart';
import '../switch_card/huf_switch_card_group.dart';
import '../switch_group/huf_switch_group.dart';
import '../tabs/huf_tabs.dart';
import '../tabs/huf_tabs_style.dart';
import 'huf_skeleton_block.dart';
import 'huf_skeleton_style.dart';

/// Trasforma un albero di widget Hero UI in placeholder skeleton.
class HUFSkeletonMapper {
  const HUFSkeletonMapper._();

  static Widget map(BuildContext context, Widget widget) {
    final theme = context.hufTheme;
    final mapped = _mapWidget(context, widget, theme);
    return mapped ?? widget;
  }

  static Widget? _mapWidget(
    BuildContext context,
    Widget widget,
    HUFTheme theme,
  ) {
    if (widget is HUFShrinkWrapWidth) {
      final child = _mapWidget(context, widget.child, theme);
      if (child == null) return null;
      return HUFShrinkWrapWidth(
        key: widget.key,
        alignment: widget.alignment,
        child: child,
      );
    }

    if (widget is HUFButton) {
      return _mapButton(context, widget, theme);
    }
    if (widget is HUFChip) {
      return _mapChip(context, widget, theme);
    }
    if (widget is HUFAvatar) {
      return _mapAvatar(context, widget, theme);
    }
    if (widget is HUFAvatarGroup) {
      return _mapAvatarGroup(context, widget, theme);
    }
    if (widget is HUFProgress) {
      return _mapProgress(context, widget, theme);
    }
    if (widget is HUFInput) {
      return _mapInput(context, widget, theme);
    }
    if (widget is HUFSelect) {
      return _mapSelect(context, widget, theme);
    }
    if (widget is HUFCard) {
      return _mapCard(context, widget, theme);
    }
    if (widget is HUFCheckbox) {
      return _mapCheckbox(context, widget, theme);
    }
    if (widget is HUFSwitch) {
      return _mapSwitch(context, widget, theme);
    }
    if (widget is HUFRadioButton) {
      return _mapRadioButton(context, widget, theme);
    }
    if (widget is HUFSeparator) {
      return _mapSeparator(widget);
    }
    if (widget is HUFTabs) {
      return _mapTabs(context, widget, theme);
    }
    if (widget is HUFSlider) {
      return _mapSlider(context, widget, theme);
    }
    if (widget is HUFRangeSlider) {
      return _mapRangeSlider(context, widget, theme);
    }
    if (widget is HUFAccordionItem) {
      return _mapAccordionItem(context, widget, theme);
    }
    if (widget is HUFAccordion) {
      return _mapAccordion(context, widget, theme);
    }
    if (widget is HUFBoxItem) {
      return _mapBoxItem(context, widget, theme);
    }
    if (widget is HUFButtonGroup) {
      return _mapButtonGroup(context, widget, theme);
    }
    if (widget is HUFCheckboxCard) {
      return _mapCheckboxCard(context, widget, theme);
    }
    if (widget is HUFRadioButtonCard) {
      return _mapRadioButtonCard(context, widget, theme);
    }
    if (widget is HUFSwitchCard) {
      return _mapSwitchCard(context, widget, theme);
    }
    if (widget is HUFCheckboxGroup) {
      return _mapCheckboxGroup(context, widget, theme);
    }
    if (widget is HUFRadioButtonGroup) {
      return _mapRadioButtonGroup(context, widget, theme);
    }
    if (widget is HUFSwitchGroup) {
      return _mapSwitchGroup(context, widget, theme);
    }
    if (widget is HUFCheckboxCardGroup) {
      return _mapCheckboxCardGroup(context, widget, theme);
    }
    if (widget is HUFRadioButtonCardGroup) {
      return _mapRadioButtonCardGroup(context, widget, theme);
    }
    if (widget is HUFSwitchCardGroup) {
      return _mapSwitchCardGroup(context, widget, theme);
    }
    if (widget is HUFBoxList) {
      return _mapBoxList(context, widget, theme);
    }

    if (widget is Text) {
      return _mapText(context, widget);
    }
    if (widget is Icon) {
      return _mapIcon(widget);
    }

    return _mapLayoutWidget(context, widget, theme);
  }

  static Widget? _mapText(BuildContext context, Text text) {
    final data = _plainTextFromText(text);
    if (data.isEmpty) {
      return null;
    }
    final style = text.style ?? DefaultTextStyle.of(context).style;
    final fontSize = style.fontSize ?? 14;
    final lineHeight = style.height ?? 1.2;
    return _line(
      context,
      data,
      fontSize,
      height: fontSize * lineHeight,
    );
  }

  static String _plainTextFromText(Text text) {
    if (text.data != null && text.data!.isNotEmpty) {
      return text.data!;
    }
    return text.textSpan?.toPlainText() ?? '';
  }

  static Widget _mapIcon(Icon icon) {
    final size = icon.size ?? 24;
    return HUFSkeletonBlock(
      width: size,
      height: size,
      borderRadius: size * 0.25,
    );
  }

  static Widget? _mapLayoutWidget(
    BuildContext context,
    Widget widget,
    HUFTheme theme,
  ) {
    if (widget is Column) {
      return Column(
        key: widget.key,
        mainAxisAlignment: widget.mainAxisAlignment,
        mainAxisSize: widget.mainAxisSize,
        crossAxisAlignment: widget.crossAxisAlignment,
        textDirection: widget.textDirection,
        verticalDirection: widget.verticalDirection,
        textBaseline: widget.textBaseline,
        spacing: widget.spacing,
        children: _mapChildren(context, widget.children, theme),
      );
    }
    if (widget is Row) {
      return Row(
        key: widget.key,
        mainAxisAlignment: widget.mainAxisAlignment,
        mainAxisSize: widget.mainAxisSize,
        crossAxisAlignment: widget.crossAxisAlignment,
        textDirection: widget.textDirection,
        verticalDirection: widget.verticalDirection,
        textBaseline: widget.textBaseline,
        spacing: widget.spacing,
        children: _mapChildren(context, widget.children, theme),
      );
    }
    if (widget is Wrap) {
      return Wrap(
        key: widget.key,
        direction: widget.direction,
        alignment: widget.alignment,
        spacing: widget.spacing,
        runAlignment: widget.runAlignment,
        runSpacing: widget.runSpacing,
        crossAxisAlignment: widget.crossAxisAlignment,
        textDirection: widget.textDirection,
        verticalDirection: widget.verticalDirection,
        children: _mapChildren(context, widget.children, theme),
      );
    }
    if (widget is Padding) {
      final child = widget.child;
      if (child == null) return widget;
      final mapped = _mapWidget(context, child, theme);
      return Padding(
        key: widget.key,
        padding: widget.padding,
        child: mapped ?? child,
      );
    }
    if (widget is SizedBox) {
      final child = widget.child;
      if (child == null) {
        if (widget.width != null || widget.height != null) {
          return SizedBox(
            key: widget.key,
            width: widget.width,
            height: widget.height,
          );
        }
        return null;
      }
      final mapped = _mapWidget(context, child, theme);
      return SizedBox(
        key: widget.key,
        width: widget.width,
        height: widget.height,
        child: mapped ?? child,
      );
    }
    if (widget is Center) {
      final child = widget.child;
      if (child == null) return widget;
      final mapped = _mapWidget(context, child, theme);
      return Center(
        key: widget.key,
        widthFactor: widget.widthFactor,
        heightFactor: widget.heightFactor,
        child: mapped ?? child,
      );
    }
    if (widget is Align) {
      final child = widget.child;
      if (child == null) return widget;
      final mapped = _mapWidget(context, child, theme);
      return Align(
        key: widget.key,
        alignment: widget.alignment,
        widthFactor: widget.widthFactor,
        heightFactor: widget.heightFactor,
        child: mapped ?? child,
      );
    }
    if (widget is Expanded) {
      final mapped = _mapWidget(context, widget.child, theme);
      return Expanded(
        key: widget.key,
        flex: widget.flex,
        child: mapped ?? widget.child,
      );
    }
    if (widget is Flexible) {
      final mapped = _mapWidget(context, widget.child, theme);
      return Flexible(
        key: widget.key,
        flex: widget.flex,
        fit: widget.fit,
        child: mapped ?? widget.child,
      );
    }
    if (widget is SingleChildScrollView) {
      final child = widget.child;
      if (child == null) return widget;
      final mapped = _mapWidget(context, child, theme);
      return SingleChildScrollView(
        key: widget.key,
        scrollDirection: widget.scrollDirection,
        reverse: widget.reverse,
        padding: widget.padding,
        primary: widget.primary,
        physics: widget.physics,
        child: mapped ?? child,
      );
    }
    if (widget is ConstrainedBox) {
      final child = widget.child;
      if (child == null) return widget;
      final mapped = _mapWidget(context, child, theme);
      return ConstrainedBox(
        key: widget.key,
        constraints: widget.constraints,
        child: mapped ?? child,
      );
    }
    if (widget is IntrinsicWidth) {
      final child = widget.child;
      if (child == null) return widget;
      final mapped = _mapWidget(context, child, theme);
      return IntrinsicWidth(
        key: widget.key,
        child: mapped ?? child,
      );
    }
    if (widget is IntrinsicHeight) {
      final child = widget.child;
      if (child == null) return widget;
      final mapped = _mapWidget(context, child, theme);
      return IntrinsicHeight(
        key: widget.key,
        child: mapped ?? child,
      );
    }
    if (widget is Spacer) {
      return widget;
    }

    return null;
  }

  static List<Widget> _mapChildren(
    BuildContext context,
    List<Widget> children,
    HUFTheme theme,
  ) {
    return [
      for (final child in children)
        _mapWidget(context, child, theme) ?? child,
    ];
  }

  static Widget _line(
    BuildContext context,
    String text,
    double fontSize, {
    double? width,
    double height = 14,
    double borderRadius = 6,
  }) {
    return Align(
      alignment: Alignment.centerLeft,
      child: HUFSkeletonBlock(
        width: width ?? hufSkeletonEstimatedTextWidth(text, fontSize),
        height: height,
        borderRadius: borderRadius,
      ),
    );
  }

  static Widget _mapButton(
    BuildContext context,
    HUFButton button,
    HUFTheme theme,
  ) {
    final metrics = hufButtonMetricsFor(
      button.size,
      button.isIconOnly,
      theme.borderRadius,
    );

    if (button.isIconOnly) {
      final block = HUFSkeletonBlock(
        width: metrics.iconOnlySize,
        height: metrics.iconOnlySize,
        borderRadius: metrics.borderRadius,
      );
      return button.isFullWidth
          ? SizedBox(width: double.infinity, child: block)
          : block;
    }

    final width = button.isFullWidth
        ? double.infinity
        : hufSkeletonEstimatedTextWidth(
            button.label,
            metrics.fontSize,
            minWidth: metrics.height * 1.6,
          ) +
            metrics.horizontalPadding * 2 +
            (button.icon != null ? metrics.iconSize + metrics.gap : 0);

    return HUFSkeletonBlock(
      width: width,
      height: metrics.height,
      borderRadius: metrics.borderRadius,
    );
  }

  static Widget _mapChip(
    BuildContext context,
    HUFChip chip,
    HUFTheme theme,
  ) {
    final metrics = hufChipMetricsFor(chip.size, theme.borderRadius);
    final width = hufSkeletonEstimatedTextWidth(chip.label, metrics.fontSize) +
        metrics.horizontalPadding * 2 +
        (chip.icon != null ? metrics.iconSize + metrics.gap : 0);

    return HUFSkeletonBlock(
      width: width,
      height: metrics.height,
      borderRadius: metrics.borderRadius,
    );
  }

  static Widget _mapAvatar(
    BuildContext context,
    HUFAvatar avatar,
    HUFTheme theme,
  ) {
    final metrics = hufAvatarMetricsFor(avatar.size, theme.borderRadius);
    return HUFSkeletonBlock(
      width: metrics.diameter,
      height: metrics.diameter,
      borderRadius: metrics.borderRadius,
    );
  }

  static Widget _mapAvatarGroup(
    BuildContext context,
    HUFAvatarGroup group,
    HUFTheme theme,
  ) {
    final count = group.children.length.clamp(1, 4);
    final size = group.size;
    final metrics = hufAvatarMetricsFor(size, theme.borderRadius);
    final overlap = group.overlap ?? metrics.defaultOverlap;
    final step = metrics.diameter - overlap;

    return SizedBox(
      width: metrics.diameter + step * (count - 1),
      height: metrics.diameter,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (var i = 0; i < count; i++)
            Positioned(
              left: step * i,
              child: HUFSkeletonBlock(
                width: metrics.diameter,
                height: metrics.diameter,
                borderRadius: metrics.borderRadius,
              ),
            ),
        ],
      ),
    );
  }

  static Widget _mapProgress(
    BuildContext context,
    HUFProgress progress,
    HUFTheme theme,
  ) {
    final metrics = hufProgressMetricsFor(progress.size, theme.borderRadius);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            _line(
              context,
              progress.label,
              metrics.labelFontSize,
              height: metrics.labelFontSize,
            ),
            if (progress.showValue && !progress.isLoading) ...[
              const Spacer(),
              HUFSkeletonBlock(
                width: 36,
                height: metrics.valueFontSize,
                borderRadius: 4,
              ),
            ],
          ],
        ),
        SizedBox(height: metrics.headerGap),
        HUFSkeletonBlock(
          width: double.infinity,
          height: metrics.trackHeight,
          borderRadius: metrics.borderRadius,
        ),
      ],
    );
  }

  static Widget _mapFieldShell({
    required BuildContext context,
    required HUFTheme theme,
    required String? label,
    required bool isFullWidth,
    String placeholder = 'Campo',
  }) {
    final metrics = hufFieldMetricsFor(theme.borderRadius);
    final field = HUFSkeletonBlock(
      width: isFullWidth ? double.infinity : 200,
      height: metrics.height,
      borderRadius: metrics.borderRadius,
    );

    if (label == null || label.isEmpty) {
      return isFullWidth
          ? SizedBox(width: double.infinity, child: field)
          : field;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _line(
          context,
          label,
          metrics.labelFontSize,
          height: metrics.labelFontSize,
        ),
        SizedBox(height: metrics.labelGap),
        if (isFullWidth) SizedBox(width: double.infinity, child: field) else field,
      ],
    );
  }

  static Widget _mapInput(
    BuildContext context,
    HUFInput input,
    HUFTheme theme,
  ) {
    if (input.type == HUFInputType.otp) {
      final cellWidth = 44.0;
      final gap = 8.0;
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < input.otpLength; i++) ...[
            if (i > 0) SizedBox(width: gap),
            HUFSkeletonBlock(
              width: cellWidth,
              height: cellWidth,
              borderRadius: theme.borderRadius.md,
            ),
          ],
        ],
      );
    }

    return _mapFieldShell(
      context: context,
      theme: theme,
      label: input.label,
      isFullWidth: input.isFullWidth,
      placeholder: input.hintText ?? 'Input',
    );
  }

  static Widget _mapSelect(
    BuildContext context,
    HUFSelect<dynamic> select,
    HUFTheme theme,
  ) {
    return _mapFieldShell(
      context: context,
      theme: theme,
      label: select.label,
      isFullWidth: select.isFullWidth,
      placeholder: select.placeholder,
    );
  }

  static Widget _mapCard(
    BuildContext context,
    HUFCard card,
    HUFTheme theme,
  ) {
    final metrics = hufCardMetricsFor(card.radiusSize, theme.borderRadius);
    final isHorizontal = card.orientation == HUFCardOrientation.horizontal;

    Widget? imageBlock;
    if (card.image != null) {
      imageBlock = _mapWidget(context, card.image!, theme) ??
          HUFSkeletonBlock(
            width: isHorizontal
                ? metrics.horizontalImageExtent
                : double.infinity,
            height: isHorizontal ? metrics.horizontalImageExtent : 140,
            borderRadius: metrics.borderRadius,
          );
    }

    final textColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (card.title != null)
          _line(
            context,
            card.title!,
            metrics.titleFontSize,
            height: metrics.titleFontSize,
            borderRadius: metrics.borderRadius * 0.5,
          ),
        if (card.title != null && card.subtitle != null)
          SizedBox(height: metrics.titleSubtitleGap),
        if (card.subtitle != null)
          _line(
            context,
            card.subtitle!,
            metrics.subtitleFontSize,
            height: metrics.subtitleFontSize,
            width: hufSkeletonEstimatedTextWidth(
                  card.subtitle!,
                  metrics.subtitleFontSize,
                ) *
                0.85,
          ),
        if (card.content != null) ...[
          SizedBox(height: metrics.sectionGap),
          _mapCardContent(context, card.content!, theme, metrics),
        ],
        if (card.actions.isNotEmpty) ...[
          SizedBox(height: metrics.sectionGap),
          _mapCardActions(context, card.actions, theme),
        ],
      ],
    );

    final body = isHorizontal
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imageBlock != null) ...[
                imageBlock,
                SizedBox(width: metrics.sectionGap),
              ],
              Expanded(child: textColumn),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (imageBlock != null) ...[
                imageBlock,
                SizedBox(height: metrics.sectionGap),
              ],
              textColumn,
            ],
          );

    // Solo contenuto skeleton: niente riempimento card che copre tutta la riga.
    if (card.style == HUFCardStyle.transparent) {
      return SizedBox(width: double.infinity, child: body);
    }

    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(metrics.borderRadius),
          border: Border.all(color: theme.colors.border),
        ),
        child: Padding(
          padding: metrics.padding,
          child: body,
        ),
      ),
    );
  }

  /// Mappa il [content] della card (testo, colonne, padding, …).
  static Widget _mapCardContent(
    BuildContext context,
    Widget content,
    HUFTheme theme,
    HUFCardMetrics metrics,
  ) {
    final mapped = _mapWidget(context, content, theme);
    if (mapped != null) {
      return mapped;
    }

    if (content is Padding) {
      final child = content.child;
      if (child == null) return content;
      return Padding(
        padding: content.padding,
        child: _mapCardContent(context, child, theme, metrics),
      );
    }
    if (content is Center) {
      final child = content.child;
      if (child == null) return content;
      return Center(child: _mapCardContent(context, child, theme, metrics));
    }
    if (content is Align) {
      final child = content.child;
      if (child == null) return content;
      return Align(
        alignment: content.alignment,
        child: _mapCardContent(context, child, theme, metrics),
      );
    }
    if (content is Column) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final child in content.children)
            _mapCardContent(context, child, theme, metrics),
        ],
      );
    }

    return _mapCardContentPlaceholder(context, metrics);
  }

  static Widget _mapCardContentPlaceholder(
    BuildContext context,
    HUFCardMetrics metrics,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _line(
          context,
          'Contenuto',
          metrics.subtitleFontSize,
          height: metrics.subtitleFontSize,
        ),
        const SizedBox(height: 8),
        _line(
          context,
          'Seconda riga',
          metrics.subtitleFontSize,
          height: metrics.subtitleFontSize,
          width: hufSkeletonEstimatedTextWidth(
            'Seconda riga',
            metrics.subtitleFontSize,
          ),
        ),
      ],
    );
  }

  static Widget _mapCardActions(
    BuildContext context,
    List<Widget> actions,
    HUFTheme theme,
  ) {
    final mapped = actions
        .map((action) => _mapWidget(context, action, theme) ?? action)
        .toList();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: mapped,
    );
  }

  static Widget _mapLabeledControl({
    required BuildContext context,
    required Widget control,
    required String? label,
    required double labelGap,
    required double labelFontSize,
  }) {
    if (label == null || label.isEmpty) {
      return control;
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        control,
        SizedBox(width: labelGap),
        _line(context, label, labelFontSize),
      ],
    );
  }

  static Widget _mapCheckbox(
    BuildContext context,
    HUFCheckbox checkbox,
    HUFTheme theme,
  ) {
    final metrics = hufCheckboxMetricsFor(checkbox.size, theme.borderRadius);
    return _mapLabeledControl(
      context: context,
      control: HUFSkeletonBlock(
        width: metrics.size,
        height: metrics.size,
        borderRadius: metrics.borderRadius,
      ),
      label: checkbox.label,
      labelGap: metrics.labelGap,
      labelFontSize: 14,
    );
  }

  static Widget _mapSwitch(
    BuildContext context,
    HUFSwitch switchWidget,
    HUFTheme theme,
  ) {
    final metrics = hufSwitchMetricsFor(switchWidget.size, theme.borderRadius);
    return _mapLabeledControl(
      context: context,
      control: HUFSkeletonBlock(
        width: metrics.trackWidth,
        height: metrics.trackHeight,
        borderRadius: metrics.trackHeight / 2,
      ),
      label: switchWidget.label,
      labelGap: metrics.labelGap,
      labelFontSize: 14,
    );
  }

  static Widget _mapRadioButton(
    BuildContext context,
    HUFRadioButton radio,
    HUFTheme theme,
  ) {
    final metrics =
        hufRadioButtonMetricsFor(radio.size);
    return _mapLabeledControl(
      context: context,
      control: HUFSkeletonBlock.circle(dimension: metrics.size),
      label: radio.label,
      labelGap: metrics.labelGap,
      labelFontSize: 14,
    );
  }

  static Widget _mapSeparator(HUFSeparator separator) {
    return switch (separator.orientation) {
      HUFSeparatorOrientation.horizontal => HUFSkeletonBlock(
          width: double.infinity,
          height: kHufSeparatorThickness,
          borderRadius: 0,
        ),
      HUFSeparatorOrientation.vertical => HUFSkeletonBlock(
          width: kHufSeparatorThickness,
          height: 48,
          borderRadius: 0,
        ),
    };
  }

  static Widget _mapTabs(
    BuildContext context,
    HUFTabs<dynamic> tabs,
    HUFTheme theme,
  ) {
    final metrics = kHufTabsMetrics;
    final tabHeight = hufTabsTabHeight(metrics);
    final chipRadius = hufTabsChipRadius(metrics);
    final isHorizontal = tabs.direction == HUFTabDirection.horizontal;
    final useFullWidth = isHorizontal && tabs.fullWidth;
    final containerRadius = isHorizontal
        ? BorderRadius.circular(hufTabsHorizontalContainerRadius(metrics))
        : hufTabsVerticalContainerBorderRadius(metrics);

    Widget tabSkeleton(String label, {bool expand = false}) {
      if (expand) {
        return HUFSkeletonBlock(
          width: double.infinity,
          height: tabHeight,
          borderRadius: chipRadius,
        );
      }
      return HUFSkeletonBlock(
        width: hufSkeletonEstimatedTextWidth(
              label,
              metrics.fontSize,
              minWidth: 48,
            ) +
            metrics.tabHorizontalPadding * 2,
        height: tabHeight,
        borderRadius: chipRadius,
      );
    }

    final tabCells = [
      for (final item in tabs.items)
        if (useFullWidth)
          Expanded(child: tabSkeleton(item.label, expand: true))
        else
          tabSkeleton(item.label),
    ];

    final tabStrip = isHorizontal
        ? Row(
            mainAxisSize:
                useFullWidth ? MainAxisSize.max : MainAxisSize.min,
            children: tabCells,
          )
        : IntrinsicWidth(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final item in tabs.items)
                  tabSkeleton(item.label, expand: true),
              ],
            ),
          );

    final container = DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colors.cardSecondary,
        borderRadius: containerRadius,
        border: Border.all(color: theme.colors.border),
      ),
      child: Padding(
        padding: EdgeInsets.all(metrics.containerPadding),
        child: tabStrip,
      ),
    );

    if (useFullWidth) {
      return SizedBox(width: double.infinity, child: container);
    }

    return HUFShrinkWrapWidth(child: container);
  }

  static Widget _mapSliderHeader(
    BuildContext context,
    String label,
    bool showValue,
    HUFSliderMetrics metrics,
  ) {
    return Row(
      children: [
        _line(
          context,
          label,
          metrics.labelFontSize,
          height: metrics.labelFontSize,
        ),
        if (showValue) ...[
          const Spacer(),
          HUFSkeletonBlock(
            width: 32,
            height: metrics.valueFontSize,
            borderRadius: 4,
          ),
        ],
      ],
    );
  }

  static Widget _mapSlider(
    BuildContext context,
    HUFSlider slider,
    HUFTheme theme,
  ) {
    final metrics = hufSliderMetricsFor(slider.size, theme.borderRadius);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _mapSliderHeader(
          context,
          slider.label,
          slider.showValue,
          metrics,
        ),
        SizedBox(height: metrics.headerGap),
        HUFSkeletonBlock(
          width: double.infinity,
          height: metrics.trackHeight,
          borderRadius: metrics.borderRadius,
        ),
      ],
    );
  }

  static Widget _mapRangeSlider(
    BuildContext context,
    HUFRangeSlider slider,
    HUFTheme theme,
  ) {
    final metrics = hufSliderMetricsFor(slider.size, theme.borderRadius);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _mapSliderHeader(
          context,
          slider.label,
          slider.showValue,
          metrics,
        ),
        SizedBox(height: metrics.headerGap),
        HUFSkeletonBlock(
          width: double.infinity,
          height: metrics.trackHeight,
          borderRadius: metrics.borderRadius,
        ),
      ],
    );
  }

  static Widget _mapAccordionItem(
    BuildContext context,
    HUFAccordionItem item,
    HUFTheme theme,
  ) {
    final metrics = hufAccordionMetricsFor(theme.borderRadius);
    final headerHeight = metrics.headerVerticalPadding * 2 +
        metrics.titleFontSize +
        4;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: headerHeight,
          child: Row(
            children: [
              if (item.leading != null) ...[
                HUFSkeletonBlock(
                  width: metrics.iconSize,
                  height: metrics.iconSize,
                  borderRadius: metrics.borderRadius * 0.5,
                ),
                SizedBox(width: metrics.leadingGap),
              ],
              Expanded(
                child: _line(
                  context,
                  item.title,
                  metrics.titleFontSize,
                  height: metrics.titleFontSize,
                ),
              ),
              HUFSkeletonBlock(
                width: metrics.iconSize,
                height: metrics.iconSize,
                borderRadius: metrics.borderRadius * 0.5,
              ),
            ],
          ),
        ),
        if (item.content != null && (item.isExpanded ?? false)) ...[
          SizedBox(height: metrics.contentTopGap),
          HUFSkeletonBlock(
            width: double.infinity,
            height: 56,
            borderRadius: metrics.borderRadius * 0.5,
          ),
        ],
      ],
    );
  }

  static Widget _mapAccordion(
    BuildContext context,
    HUFAccordion accordion,
    HUFTheme theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < accordion.children.length; i++) ...[
          if (i > 0) const SizedBox(height: 8),
          _mapAccordionItem(context, accordion.children[i], theme),
        ],
      ],
    );
  }

  static Widget _mapBoxItemContent({
    required BuildContext context,
    required HUFTheme theme,
    required String title,
    required String? subtitle,
    required Widget? icon,
    required Widget action,
    required HUFBoxItemMetrics metrics,
  }) {
    final mappedIcon = icon != null
        ? (_mapWidget(context, icon, theme) ??
            HUFSkeletonBlock(
              width: metrics.leadingIconSize,
              height: metrics.leadingIconSize,
              borderRadius: metrics.borderRadius * 0.5,
            ))
        : null;

    final mappedAction = _mapWidget(context, action, theme) ??
        HUFSkeletonBlock(
          width: 40,
          height: 24,
          borderRadius: 12,
        );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (mappedIcon != null) ...[
          mappedIcon,
          SizedBox(width: metrics.iconGap),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _line(
                context,
                title,
                metrics.titleFontSize,
                height: metrics.titleFontSize,
              ),
              if (subtitle != null) ...[
                SizedBox(height: metrics.titleSubtitleGap),
                _line(
                  context,
                  subtitle,
                  metrics.subtitleFontSize,
                  height: metrics.subtitleFontSize,
                  width: hufSkeletonEstimatedTextWidth(
                        subtitle,
                        metrics.subtitleFontSize,
                      ) *
                      0.9,
                ),
              ],
            ],
          ),
        ),
        SizedBox(width: metrics.actionGap),
        mappedAction,
      ],
    );
  }

  static Widget _mapBoxItem(
    BuildContext context,
    HUFBoxItem item,
    HUFTheme theme, {
    HUFBoxListLayout? listLayout,
    bool? isFirst,
    bool? isLast,
  }) {
    final metrics = hufBoxItemMetricsFor(item.size, theme.borderRadius);
    final content = _mapBoxItemContent(
      context: context,
      theme: theme,
      title: item.title,
      subtitle: item.subtitle,
      icon: item.icon,
      action: item.action,
      metrics: metrics,
    );

    final layout = listLayout ?? item.layout ?? HUFBoxListLayout.separated;
    final resolvedIsFirst = isFirst ?? item.isFirst ?? true;
    final resolvedIsLast = isLast ?? item.isLast ?? true;
    final itemColors = item.colors ??
        hufBoxItemColorsFor(
          theme.colors,
          item.highlighted,
          !item.enabled || item.onTap == null,
          activeColor: item.activeColor,
        );
    final background = item.highlighted
        ? itemColors.activeBackground
        : itemColors.inactiveBackground;
    final borderRadius = hufBoxItemBorderRadius(
      layout: layout,
      radius: metrics.borderRadius,
      isFirst: resolvedIsFirst,
      isLast: resolvedIsLast,
    );

    return Container(
      width: double.infinity,
      padding: metrics.padding,
      decoration: BoxDecoration(
        color: background,
        borderRadius: borderRadius,
      ),
      child: content,
    );
  }

  static Widget _mapButtonGroup(
    BuildContext context,
    HUFButtonGroup group,
    HUFTheme theme,
  ) {
    final metrics = hufButtonMetricsFor(
      group.size,
      false,
      theme.borderRadius,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < group.items.length; i++) ...[
          if (i > 0) const SizedBox(width: 1),
          _mapButtonGroupItem(context, group.items[i], metrics),
        ],
      ],
    );
  }

  static Widget _mapButtonGroupItem(
    BuildContext context,
    HUFButtonGroupItem item,
    HUFButtonMetrics metrics,
  ) {
    if (item.isIconOnly) {
      return HUFSkeletonBlock(
        width: metrics.iconOnlySize,
        height: metrics.height,
        borderRadius: metrics.borderRadius,
      );
    }
    final label = item.label ?? '';
    return HUFSkeletonBlock(
      width: hufSkeletonEstimatedTextWidth(label, metrics.fontSize) +
          metrics.horizontalPadding * 2,
      height: metrics.height,
      borderRadius: metrics.borderRadius,
    );
  }

  static Widget _mapControlCard({
    required BuildContext context,
    required HUFTheme theme,
    required String title,
    required String? subtitle,
    required Widget? icon,
    required Widget control,
    required HUFBoxItemSize size,
  }) {
    return _mapBoxItem(
      context,
      HUFBoxItem(
        title: title,
        subtitle: subtitle,
        icon: icon,
        action: control,
        size: size,
      ),
      theme,
    );
  }

  static Widget _mapCheckboxCard(
    BuildContext context,
    HUFCheckboxCard card,
    HUFTheme theme,
  ) {
    final metrics = hufCheckboxMetricsFor(card.size, theme.borderRadius);
    return _mapControlCard(
      context: context,
      theme: theme,
      title: card.title,
      subtitle: card.subtitle,
      icon: card.icon,
      control: HUFSkeletonBlock(
        width: metrics.size,
        height: metrics.size,
        borderRadius: metrics.borderRadius,
      ),
      size: _boxItemSizeFromCheckbox(card.size),
    );
  }

  static Widget _mapRadioButtonCard(
    BuildContext context,
    HUFRadioButtonCard card,
    HUFTheme theme,
  ) {
    final metrics =
        hufRadioButtonMetricsFor(card.size);
    return _mapControlCard(
      context: context,
      theme: theme,
      title: card.title,
      subtitle: card.subtitle,
      icon: card.icon,
      control: HUFSkeletonBlock.circle(dimension: metrics.size),
      size: _boxItemSizeFromRadio(card.size),
    );
  }

  static Widget _mapSwitchCard(
    BuildContext context,
    HUFSwitchCard card,
    HUFTheme theme,
  ) {
    final metrics = hufSwitchMetricsFor(card.size, theme.borderRadius);
    return _mapControlCard(
      context: context,
      theme: theme,
      title: card.title,
      subtitle: card.subtitle,
      icon: card.icon,
      control: HUFSkeletonBlock(
        width: metrics.trackWidth,
        height: metrics.trackHeight,
        borderRadius: metrics.trackHeight / 2,
      ),
      size: _boxItemSizeFromSwitch(card.size),
    );
  }

  static HUFBoxItemSize _boxItemSizeFromCheckbox(HUFCheckboxSize size) {
    return switch (size) {
      HUFCheckboxSize.small => HUFBoxItemSize.small,
      HUFCheckboxSize.medium => HUFBoxItemSize.medium,
      HUFCheckboxSize.large => HUFBoxItemSize.large,
    };
  }

  static HUFBoxItemSize _boxItemSizeFromRadio(HUFRadioButtonSize size) {
    return switch (size) {
      HUFRadioButtonSize.small => HUFBoxItemSize.small,
      HUFRadioButtonSize.medium => HUFBoxItemSize.medium,
      HUFRadioButtonSize.large => HUFBoxItemSize.large,
    };
  }

  static HUFBoxItemSize _boxItemSizeFromSwitch(HUFSwitchSize size) {
    return switch (size) {
      HUFSwitchSize.small => HUFBoxItemSize.small,
      HUFSwitchSize.medium => HUFBoxItemSize.medium,
      HUFSwitchSize.large => HUFBoxItemSize.large,
    };
  }

  static List<Widget> _intersperseList(List<Widget> items, double gap) {
    if (items.isEmpty) return items;
    final result = <Widget>[items.first];
    for (var i = 1; i < items.length; i++) {
      result.add(SizedBox(height: gap));
      result.add(items[i]);
    }
    return result;
  }

  static Widget _mapAxisGroup({
    required List<Widget> mapped,
    required double spacing,
    required double runSpacing,
    required Axis direction,
  }) {
    if (direction == Axis.vertical) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: _intersperseList(mapped, spacing),
      );
    }
    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      children: mapped,
    );
  }

  static Widget _mapCheckboxGroup(
    BuildContext context,
    HUFCheckboxGroup<dynamic> group,
    HUFTheme theme,
  ) {
    return _mapAxisGroup(
      mapped: group.children
          .map((c) => _mapCheckbox(context, c, theme))
          .toList(),
      spacing: group.spacing,
      runSpacing: group.runSpacing,
      direction: group.direction,
    );
  }

  static Widget _mapRadioButtonGroup(
    BuildContext context,
    HUFRadioButtonGroup<dynamic> group,
    HUFTheme theme,
  ) {
    return _mapAxisGroup(
      mapped: group.children
          .map((c) => _mapRadioButton(context, c, theme))
          .toList(),
      spacing: group.spacing,
      runSpacing: group.runSpacing,
      direction: group.direction,
    );
  }

  static Widget _mapSwitchGroup(
    BuildContext context,
    HUFSwitchGroup<dynamic> group,
    HUFTheme theme,
  ) {
    return _mapAxisGroup(
      mapped:
          group.children.map((c) => _mapSwitch(context, c, theme)).toList(),
      spacing: group.spacing,
      runSpacing: group.runSpacing,
      direction: group.direction,
    );
  }

  static Widget _mapCheckboxCardGroup(
    BuildContext context,
    HUFCheckboxCardGroup<dynamic> group,
    HUFTheme theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: _intersperseList(
        group.children
            .map((c) => _mapCheckboxCard(context, c, theme))
            .toList(),
        8,
      ),
    );
  }

  static Widget _mapRadioButtonCardGroup(
    BuildContext context,
    HUFRadioButtonCardGroup<dynamic> group,
    HUFTheme theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: _intersperseList(
        group.children
            .map((c) => _mapRadioButtonCard(context, c, theme))
            .toList(),
        8,
      ),
    );
  }

  static Widget _mapSwitchCardGroup(
    BuildContext context,
    HUFSwitchCardGroup<dynamic> group,
    HUFTheme theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: _intersperseList(
        group.children.map((c) => _mapSwitchCard(context, c, theme)).toList(),
        8,
      ),
    );
  }

  static Widget _mapBoxList(
    BuildContext context,
    HUFBoxList list,
    HUFTheme theme,
  ) {
    final mappedChildren = <Widget>[];
    for (var i = 0; i < list.children.length; i++) {
      final child = list.children[i];
      if (child is HUFBoxItem) {
        mappedChildren.add(
          _mapBoxItem(
            context,
            child,
            theme,
            listLayout: list.layout,
            isFirst: i == 0,
            isLast: i == list.children.length - 1,
          ),
        );
      } else {
        mappedChildren.add(_mapWidget(context, child, theme) ?? child);
      }
    }

    if (list.layout == HUFBoxListLayout.united) {
      final items = <Widget>[];
      for (var i = 0; i < mappedChildren.length; i++) {
        items.add(mappedChildren[i]);
        if (list.showSeparators && i < mappedChildren.length - 1) {
          items.add(
            hufBoxListUnitedSeparator(color: theme.colors.border),
          );
        }
      }

      return DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colors.card,
          borderRadius: BorderRadius.circular(theme.borderRadius.value),
          border: Border.all(color: theme.colors.border),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(theme.borderRadius.value),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: items,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: _intersperseList(mappedChildren, list.spacing),
    );
  }
}
