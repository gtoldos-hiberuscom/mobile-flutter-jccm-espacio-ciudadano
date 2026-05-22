import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';

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
  });

  /// The bullet text content.
  final String text;

  /// Optional override for the text style.
  final TextStyle? textStyle;

  static const _teal = AppColors.secondaryLight400;

  @override
  Widget build(final BuildContext context) {
    return Semantics(
      label: text,
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
