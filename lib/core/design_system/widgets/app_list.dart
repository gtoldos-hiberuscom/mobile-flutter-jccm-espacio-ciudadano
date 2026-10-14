import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart' show AppListItem;
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_icons.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_card_and_list.dart' show AppListItem;

// ═══════════════════════════════════════════════════════════════════════════════
// ENUMS
// ═══════════════════════════════════════════════════════════════════════════════

/// Visual variant for [AppList] container — mirrors Figma "Lists" node
/// (`61:2773`) type property.
enum AppListVariant {
  /// Plain list of [AppListItem] rows.
  basic,

  /// Single-select radio list — wraps [AppListOptionItem].
  dropDownList,

  /// Multi-select checkbox list — wraps [AppListCheckItem].
  checklist,

  /// Sections that expand/collapse — wraps [AppListExpandableItem].
  expandable,
}

// ═══════════════════════════════════════════════════════════════════════════════
// APP LIST — CONTAINER (Figma "Lists" 61:2773)
// ═══════════════════════════════════════════════════════════════════════════════

/// Design-system list container that groups items with an optional header.
///
/// Mirrors Figma "Lists" component (`61:2773`).
/// Renders a rounded card-like surface with dividers between children.
///
/// Example:
/// ```dart
/// AppList(
///   header: 'Opciones',
///   children: [
///     AppListOptionItem(title: 'Opción 1', ...),
///     AppListOptionItem(title: 'Opción 2', ...),
///   ],
/// )
/// ```
class AppList extends StatelessWidget {
  const AppList({
    required this.children,
    super.key,
    this.title,
    this.subtitle,
    this.header,
    this.variant = AppListVariant.basic,
    this.padding,
    this.headingLevel = 2,
    this.semanticsLabel,
  }) : assert(title == null || title != '', 'title must not be empty'),
       assert(subtitle == null || subtitle != '', 'subtitle must not be empty'),
       assert(header == null || header != '', 'header must not be empty'),
       assert(title == null || header == null, 'title and header cannot both be provided'),
       assert(
         headingLevel >= 1 && headingLevel <= 6,
         'headingLevel must be between 1 and 6',
       ),
       assert(
         semanticsLabel == null || semanticsLabel != '',
         'semanticsLabel must not be empty',
       );

  /// Optional H3 title displayed above the list container (Figma title block).
  final String? title;

  /// Optional bodyRegular subtitle below [title] (Figma title block).
  final String? subtitle;

  /// Optional section header displayed above the list (legacy, deprecated — prefer [title]).
  final String? header;

  /// Visual variant (informational — does not change layout).
  final AppListVariant variant;

  /// List items to render separated by dividers.
  final List<Widget> children;

  /// Override container padding. Defaults to zero (items handle their own).
  final EdgeInsetsGeometry? padding;

  /// Semantic level used by [title] or legacy [header].
  final int headingLevel;

  /// Optional accessible name for the list group.
  final String? semanticsLabel;

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null) ...[
          Padding(
            padding: const EdgeInsets.only(
              bottom: AppDimensions.space4,
            ),
            child: Semantics(
              header: true,
              headingLevel: headingLevel,
              child: Text(
                title!,
                style: AppTypography.h3.copyWith(color: AppColors.textPrimary),
              ),
            ),
          ),
        ] else if (header != null)
          Padding(
            padding: const EdgeInsets.only(
              left: AppDimensions.space16,
              bottom: AppDimensions.space8,
            ),
            child: Semantics(
              header: true,
              headingLevel: headingLevel,
              child: Text(
                header!,
                style: AppTypography.bodyBold.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
        if (subtitle != null)
          Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.space8),
            child: Text(
              subtitle!,
              style: AppTypography.bodyRegular.copyWith(color: AppColors.textPrimary),
            ),
          ),
        Semantics(
          container: true,
          explicitChildNodes: true,
          role: SemanticsRole.list,
          label: semanticsLabel,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(
                variant == AppListVariant.dropDownList ? AppDimensions.radiusMedium : AppDimensions.radiusSmall,
              ),
              border: Border.all(color: AppColors.borderNeutralLight),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x29000000),
                  blurRadius: 6,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                variant == AppListVariant.dropDownList ? AppDimensions.radiusMedium : AppDimensions.radiusSmall,
              ),
              child: Padding(
                padding: padding ?? const EdgeInsets.all(AppDimensions.space16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _interleaveWithDividers(children),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _interleaveWithDividers(final List<Widget> items) {
    if (items.isEmpty) {
      return items;
    }
    final result = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      result.add(
        Semantics(
          container: true,
          explicitChildNodes: true,
          role: SemanticsRole.listItem,
          child: items[i],
        ),
      );
      if (i < items.length - 1) {
        result.add(
          const ExcludeSemantics(
            child: Divider(
              height: 1,
              thickness: 1,
              indent: AppDimensions.space16,
              endIndent: AppDimensions.space16,
              color: AppColors.dividerColor,
            ),
          ),
        );
      }
    }
    return result;
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// APP LIST OPTION ITEM — RADIO SELECT (Figma ListsBB "Option" 60:7248)
// ═══════════════════════════════════════════════════════════════════════════════

/// Single-select radio option item for [AppList] with [AppListVariant.dropDownList].
///
/// States: Default, Pressed (ink effect), Selected (radio filled).
///
/// Example:
/// ```dart
/// AppListOptionItem(
///   title: 'España',
///   isSelected: _selected == 'es',
///   onTap: () => setState(() => _selected = 'es'),
/// )
/// ```
class AppListOptionItem extends StatelessWidget {
  const AppListOptionItem({
    required this.title,
    super.key,
    this.subtitle,
    this.isSelected = false,
    this.isDisabled = false,
    this.onTap,
    this.leading,
    this.semanticsLabel,
  });

  final String title;
  final String? subtitle;
  final bool isSelected;
  final bool isDisabled;
  final VoidCallback? onTap;
  final Widget? leading;
  final String? semanticsLabel;

  @override
  Widget build(final BuildContext context) {
    final effectiveLabel = semanticsLabel ?? title;

    return Semantics(
      label: effectiveLabel,
      selected: isSelected,
      enabled: !isDisabled,
      inMutuallyExclusiveGroup: true,
      child: ExcludeSemantics(
        child: InkWell(
          onTap: isDisabled ? null : onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: AppDimensions.minTouchTarget),
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.space8),
              child: Row(
                children: [
                  if (leading != null) ...[
                    leading!,
                    const SizedBox(width: AppDimensions.space8),
                  ],
                  Expanded(
                    child: Text(
                      title,
                      style: AppTypography.bodyRegular.copyWith(
                        color: isDisabled ? AppColors.textDisabled : AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.space8),
                  AppIcon(
                    AppIcons.callMade,
                    color: isDisabled ? AppColors.textDisabled : AppColors.textPrimary,
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

// ═══════════════════════════════════════════════════════════════════════════════
// APP LIST CHECK ITEM — CHECKBOX SELECT (Figma ListsBB "Check" 60:7248)
// ═══════════════════════════════════════════════════════════════════════════════

/// Multi-select checkbox item for [AppList] with [AppListVariant.checklist].
///
/// States: Default, Pressed (ink effect), Selected (check filled).
///
/// Example:
/// ```dart
/// AppListCheckItem(
///   title: 'Recibir notificaciones',
///   isChecked: _notif,
///   onChanged: (v) => setState(() => _notif = v),
/// )
/// ```
class AppListCheckItem extends StatelessWidget {
  const AppListCheckItem({
    required this.title,
    super.key,
    this.subtitle,
    this.isChecked = false,
    this.isDisabled = false,
    this.onChanged,
    this.leading,
    this.semanticsLabel,
  });

  final String title;
  final String? subtitle;
  final bool isChecked;
  final bool isDisabled;
  final ValueChanged<bool>? onChanged;
  final Widget? leading;
  final String? semanticsLabel;

  @override
  Widget build(final BuildContext context) {
    final effectiveLabel = semanticsLabel ?? title;

    Widget row = Padding(
      padding: const EdgeInsets.all(AppDimensions.space8),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: AppDimensions.minTouchTarget),
        child: Row(
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: AppDimensions.space8),
            ],
            Expanded(
              child: Text(
                title,
                style: AppTypography.bodyRegular.copyWith(
                  color: isDisabled ? AppColors.textDisabled : AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.space8),
            _CheckIndicator(isChecked: isChecked, isDisabled: isDisabled),
          ],
        ),
      ),
    );

    // Selected state: green background + 2dp bottom border
    if (isChecked && !isDisabled) {
      row = DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.successLight,
          border: Border(
            bottom: BorderSide(color: AppColors.borderSuccess, width: 2),
          ),
        ),
        child: row,
      );
    }

    return Semantics(
      label: effectiveLabel,
      checked: isChecked,
      enabled: !isDisabled,
      child: ExcludeSemantics(
        child: InkWell(
          onTap: isDisabled ? null : () => onChanged?.call(!isChecked),
          child: row,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// APP LIST EXPANDABLE ITEM — COLLAPSIBLE (Figma ListsBB "Expandible" 60:7248)
// ═══════════════════════════════════════════════════════════════════════════════

/// Expandable/collapsible list item with animated content reveal.
///
/// States: Default (collapsed), Expanded.
/// Accessibility: Rule 3.14 — `Semantics.expanded` indicates state.
///
/// Example:
/// ```dart
/// AppListExpandableItem(
///   title: 'Detalles adicionales',
///   children: [
///     Text('Contenido expandible'),
///   ],
/// )
/// ```
class AppListExpandableItem extends StatefulWidget {
  const AppListExpandableItem({
    required this.title,
    required this.children,
    super.key,
    this.subtitle,
    this.leading,
    this.initiallyExpanded = false,
    this.isDisabled = false,
    this.headerPadding,
    this.semanticsLabel,
    this.onExpansionChanged,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget> children;
  final bool initiallyExpanded;
  final bool isDisabled;
  final EdgeInsetsGeometry? headerPadding;
  final String? semanticsLabel;
  final ValueChanged<bool>? onExpansionChanged;

  @override
  State<AppListExpandableItem> createState() => _AppListExpandableItemState();
}

class _AppListExpandableItemState extends State<AppListExpandableItem> with SingleTickerProviderStateMixin {
  late bool _isExpanded;
  late final AnimationController _controller;
  late final Animation<double> _heightFactor;

  static const _duration = Duration(milliseconds: 200);

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _controller = AnimationController(
      duration: _duration,
      vsync: this,
      value: _isExpanded ? 1.0 : 0.0,
    );
    _heightFactor = _controller.drive(CurveTween(curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    if (widget.isDisabled) {
      return;
    }
    setState(() {
      _isExpanded = !_isExpanded;
    });
    if (_isExpanded) {
      unawaited(_controller.forward());
    } else {
      unawaited(_controller.reverse());
    }
    widget.onExpansionChanged?.call(_isExpanded);
  }

  @override
  Widget build(final BuildContext context) {
    final effectiveLabel = widget.semanticsLabel ?? widget.title;

    return Semantics(
      label: effectiveLabel,
      button: true,
      expanded: _isExpanded,
      enabled: !widget.isDisabled,
      child: ExcludeSemantics(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              onTap: _toggle,
              child: Padding(
                padding: widget.headerPadding ?? const EdgeInsets.all(AppDimensions.space8),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: AppDimensions.minTouchTarget),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.leading != null) ...[
                        widget.leading!,
                        const SizedBox(width: AppDimensions.space8),
                      ],
                      Expanded(
                        child: Text(
                          widget.title,
                          softWrap: true,
                          style: AppTypography.bodyBold.copyWith(
                            color: widget.isDisabled ? AppColors.textDisabled : AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppDimensions.space8),
                      Padding(
                        padding: const EdgeInsets.only(top: AppDimensions.space2),
                        child: AppIcon(
                          _isExpanded ? AppIcons.remove : AppIcons.add,
                          color: widget.isDisabled ? AppColors.textDisabled : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ClipRect(
              child: AnimatedBuilder(
                animation: _heightFactor,
                builder: (final context, final child) => Align(
                  alignment: Alignment.topCenter,
                  heightFactor: _heightFactor.value,
                  child: child,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: AppDimensions.space16,
                    right: AppDimensions.space16,
                    bottom: AppDimensions.space12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: widget.children,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// INTERNAL BUILDING BLOCKS
// ═══════════════════════════════════════════════════════════════════════════════

/// Checkbox indicator for [AppListCheckItem].
class _CheckIndicator extends StatelessWidget {
  const _CheckIndicator({
    required this.isChecked,
    required this.isDisabled,
  });

  final bool isChecked;
  final bool isDisabled;

  @override
  Widget build(final BuildContext context) {
    final fillColor = isDisabled
        ? AppColors.disabled
        : isChecked
        ? AppColors.primary
        : Colors.transparent;
    final borderColor = isDisabled
        ? AppColors.disabled
        : isChecked
        ? AppColors.primary
        : AppColors.outline;
    final checkColor = isDisabled ? AppColors.surface : AppColors.onPrimary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: AppDimensions.iconMedium,
      height: AppDimensions.iconMedium,
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
        border: Border.all(color: borderColor, width: 2),
      ),
      child: isChecked ? Icon(Icons.check_rounded, size: 16, color: checkColor) : null,
    );
  }
}
