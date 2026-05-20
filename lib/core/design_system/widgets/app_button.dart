import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';

/// Hierarchy variants for [AppButton] — mirrors Figma "Button Label" node
/// (`9:1794`) hierarchy property.
enum AppButtonHierarchy {
  /// High-emphasis filled button (primary action).
  primary,

  /// Medium-emphasis outlined button.
  secondary,

  /// Low-emphasis transparent button with border.
  ghost,

  /// Minimal text-only button.
  tertiary,

  /// Visually disabled regardless of [onPressed].
  disabled,
}

/// Size variants for [AppButton].
enum AppButtonSize {
  /// Standard 48 dp height.
  medium,

  /// Compact 36 dp height.
  small,
}

/// Design-system button that enforces a minimum 48 dp touch target (WCAG 2.1).
///
/// Wraps any primary, secondary, ghost, or tertiary action and guarantees:
/// - Correct hierarchy colours from Figma tokens.
/// - Accessible minimum tap area (48 dp for [AppButtonSize.medium]).
/// - [Semantics] label for screen readers.
///
/// Example:
/// ```dart
/// AppButton(
///   label: 'Acceder',
///   onPressed: _login,
///   hierarchy: AppButtonHierarchy.primary,
///   size: AppButtonSize.medium,
/// )
/// ```
class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.hierarchy = AppButtonHierarchy.primary,
    this.size = AppButtonSize.medium,
    this.semanticsLabel,
    this.icon,
    this.isLoading = false,
    // Legacy variant param — mapped to hierarchy for backwards compat.
    @Deprecated('Use hierarchy instead') AppButtonVariant? variant,
  }) : _legacyVariant = variant;

  final AppButtonHierarchy hierarchy;
  final AppButtonSize size;
  final String label;
  final VoidCallback? onPressed;
  final String? semanticsLabel;
  final Widget? icon;
  final bool isLoading;
  // ignore: deprecated_member_use_from_same_package
  final AppButtonVariant? _legacyVariant;

  double get _height => switch (size) {
    AppButtonSize.medium => AppDimensions.minTouchTarget,
    AppButtonSize.small => 36,
  };

  TextStyle get _textStyle => switch (size) {
    AppButtonSize.medium => AppTypography.bodyBold,
    AppButtonSize.small => AppTypography.bodyBase.copyWith(
        fontWeight: FontWeight.w600,
      ),
  };

  AppButtonHierarchy get _effectiveHierarchy {
    // ignore: deprecated_member_use_from_same_package
    final legacy = _legacyVariant;
    if (legacy != null) {
      // ignore: deprecated_member_use_from_same_package
      return switch (legacy) {
        AppButtonVariant.primary => AppButtonHierarchy.primary,
        AppButtonVariant.outlined => AppButtonHierarchy.secondary,
        AppButtonVariant.text => AppButtonHierarchy.tertiary,
      };
    }
    return hierarchy;
  }

  @override
  Widget build(final BuildContext context) {
    final effectiveHierarchy = _effectiveHierarchy;
    final isDisabled =
        onPressed == null || effectiveHierarchy == AppButtonHierarchy.disabled;
    final effectiveSemantics = semanticsLabel ?? label;

    final Widget content = isLoading
        ? SizedBox(
            width: AppDimensions.iconSmall,
            height: AppDimensions.iconSmall,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                _foregroundColor(effectiveHierarchy, isDisabled),
              ),
            ),
          )
        : icon != null
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon!,
              const SizedBox(width: AppDimensions.space8),
              Text(label, style: _textStyle),
            ],
          )
        : Text(label, style: _textStyle);

    final button = switch (effectiveHierarchy) {
      AppButtonHierarchy.primary => _buildPrimary(content, isDisabled),
      AppButtonHierarchy.secondary => _buildSecondary(content, isDisabled),
      AppButtonHierarchy.ghost => _buildGhost(content, isDisabled),
      AppButtonHierarchy.tertiary => _buildTertiary(content, isDisabled),
      AppButtonHierarchy.disabled => _buildPrimary(content, true),
    };

    return Semantics(
      label: effectiveSemantics,
      button: true,
      enabled: !isDisabled && !isLoading,
      child: button,
    );
  }

  Widget _buildPrimary(Widget content, bool isDisabled) => ElevatedButton(
    onPressed: isLoading || isDisabled ? null : onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor:
          isDisabled ? AppColors.disabledContainer : AppColors.primary,
      foregroundColor:
          isDisabled ? AppColors.textDisabled : AppColors.textOnPrimary,
      minimumSize: Size(AppDimensions.minTouchTarget, _height),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(AppDimensions.radiusXs),
        ),
      ),
      elevation: isDisabled ? 0 : AppDimensions.elevationLow,
      disabledBackgroundColor: AppColors.disabledContainer,
      disabledForegroundColor: AppColors.textDisabled,
    ),
    child: content,
  );

  Widget _buildSecondary(Widget content, bool isDisabled) => OutlinedButton(
    onPressed: isLoading || isDisabled ? null : onPressed,
    style: OutlinedButton.styleFrom(
      foregroundColor: isDisabled ? AppColors.textDisabled : AppColors.primary,
      minimumSize: Size(AppDimensions.minTouchTarget, _height),
      side: BorderSide(
        color: isDisabled ? AppColors.disabled : AppColors.primary,
        width: 1.5,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(AppDimensions.radiusXs),
        ),
      ),
    ),
    child: content,
  );

  Widget _buildGhost(Widget content, bool isDisabled) => OutlinedButton(
    onPressed: isLoading || isDisabled ? null : onPressed,
    style: OutlinedButton.styleFrom(
      foregroundColor: isDisabled ? AppColors.textDisabled : AppColors.primary,
      minimumSize: Size(AppDimensions.minTouchTarget, _height),
      backgroundColor: Colors.transparent,
      side: BorderSide(
        color: isDisabled ? AppColors.disabled : AppColors.outline,
        width: 1,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(AppDimensions.radiusXs),
        ),
      ),
    ),
    child: content,
  );

  Widget _buildTertiary(Widget content, bool isDisabled) => TextButton(
    onPressed: isLoading || isDisabled ? null : onPressed,
    style: TextButton.styleFrom(
      foregroundColor: isDisabled ? AppColors.textDisabled : AppColors.primary,
      backgroundColor:
          isDisabled ? null : AppColors.secondaryLight100,
      minimumSize: Size(AppDimensions.minTouchTarget, _height),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(AppDimensions.radiusXs),
        ),
      ),
    ),
    child: content,
  );

  static Color _foregroundColor(
    AppButtonHierarchy hierarchy,
    bool isDisabled,
  ) {
    if (isDisabled) return AppColors.textDisabled;
    return switch (hierarchy) {
      AppButtonHierarchy.primary => AppColors.textOnPrimary,
      AppButtonHierarchy.secondary ||
      AppButtonHierarchy.ghost ||
      AppButtonHierarchy.tertiary => AppColors.primary,
      AppButtonHierarchy.disabled => AppColors.textDisabled,
    };
  }
}

/// Deprecated variant enum — use [AppButtonHierarchy] instead.
@Deprecated('Use AppButtonHierarchy')
enum AppButtonVariant {
  primary,
  outlined,
  text,
}
