import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';

/// Accessible unordered list using the design-system double-dot marker.
class AppBulletList extends StatelessWidget {
  const AppBulletList({
    required this.items,
    super.key,
    this.textStyle,
    this.spacing = AppDimensions.space8,
    this.semanticsLabel,
  }) : assert(spacing >= 0, 'spacing must not be negative'),
       assert(semanticsLabel == null || semanticsLabel.length > 0, 'semanticsLabel must not be empty');

  final List<String> items;
  final TextStyle? textStyle;
  final double spacing;
  final String? semanticsLabel;

  @override
  Widget build(final BuildContext context) {
    assert(items.isNotEmpty, 'items must not be empty');

    return Semantics(
      container: true,
      explicitChildNodes: true,
      role: SemanticsRole.list,
      label: semanticsLabel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var index = 0; index < items.length; index++) ...[
            AppBulletItem._(
              text: items[index],
              textStyle: textStyle,
              isListItem: true,
            ),
            if (index < items.length - 1) SizedBox(height: spacing),
          ],
        ],
      ),
    );
  }
}

/// Two-dot bullet list item — mirrors the Figma "Bullet Item" pattern with a
/// teal + navy double-dot indicator.
///
/// **Accessibility:**
/// - Wrapped in [Semantics] with `label` so SR reads the full text.
/// - Dots are decorative and excluded from semantics.
///
/// Usage:
/// ```dart
/// AppBulletItem(text: 'Tu información personal.')
/// ```
class AppBulletItem extends StatelessWidget {
  const AppBulletItem({
    required this.text,
    super.key,
    this.textStyle,
    this.semanticsLabel,
  }) : _isListItem = false,
       assert(text.length > 0, 'text must not be empty'),
       assert(semanticsLabel == null || semanticsLabel.length > 0, 'semanticsLabel must not be empty');

  const AppBulletItem._({
    required this.text,
    required final bool isListItem,
    this.textStyle,
    this.semanticsLabel,
  }) : _isListItem = isListItem,
       assert(text.length > 0, 'text must not be empty'),
       assert(semanticsLabel == null || semanticsLabel.length > 0, 'semanticsLabel must not be empty');

  /// The bullet text content.
  final String text;

  /// Optional override for the text style.
  final TextStyle? textStyle;
  final String? semanticsLabel;
  final bool _isListItem;

  static const _teal = AppColors.secondaryLight400;

  @override
  Widget build(final BuildContext context) {
    return Semantics(
      container: true,
      label: semanticsLabel ?? text,
      role: _isListItem ? SemanticsRole.listItem : SemanticsRole.none,
      child: ExcludeSemantics(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 3),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: _teal,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppDimensions.space12),
            Expanded(
              child: Text(
                text,
                style:
                    textStyle ??
                    AppTypography.bodyRegular.copyWith(
                      color: AppColors.primary,
                      height: 1.4,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
