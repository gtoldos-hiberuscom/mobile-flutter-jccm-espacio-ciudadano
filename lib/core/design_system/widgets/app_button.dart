import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
/// - Rule 3.4: content wrapped in [ExcludeSemantics] — label announced as one node.
/// - Rule 3.10: loading state announces "Cargando" / "Contenido cargado" via
///   [SemanticsService] and uses [liveRegion] on the spinner.
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
class AppButton extends StatefulWidget {
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
    @Deprecated('Use hierarchy instead') final AppButtonVariant? variant,
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

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _wasLoading = false;

  @override
  void didUpdateWidget(covariant AppButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Rule 3.10 — announce loading start and end (WCAG 4.1.3)
    if (!_wasLoading && widget.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) SemanticsService.announce('Cargando', TextDirection.ltr);
      });
    } else if (_wasLoading && !widget.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) SemanticsService.announce('Contenido cargado', TextDirection.ltr);
      });
    }
    _wasLoading = widget.isLoading;
  }

  double get _height => switch (widget.size) {
    AppButtonSize.medium => AppDimensions.minTouchTarget,
    AppButtonSize.small => 36,
  };

  TextStyle get _textStyle => switch (widget.size) {
    AppButtonSize.medium => AppTypography.bodyBase,
    AppButtonSize.small => AppTypography.bodyBase.copyWith(
      fontWeight: FontWeight.w600,
    ),
  };

  AppButtonHierarchy get _effectiveHierarchy {
    // ignore: deprecated_member_use_from_same_package
    final legacy = widget._legacyVariant;
    if (legacy != null) {
      // ignore: deprecated_member_use_from_same_package
      return switch (legacy) {
        AppButtonVariant.primary => AppButtonHierarchy.primary,
        AppButtonVariant.outlined => AppButtonHierarchy.secondary,
        AppButtonVariant.text => AppButtonHierarchy.tertiary,
      };
    }
    return widget.hierarchy;
  }

  @override
  Widget build(final BuildContext context) {
    final effectiveHierarchy = _effectiveHierarchy;
    final isDisabled = widget.onPressed == null || effectiveHierarchy == AppButtonHierarchy.disabled;
    final effectiveSemantics = widget.semanticsLabel ?? widget.label;

    // Rule 3.10 — spinner with liveRegion so SR announces loading state
    final Widget content = widget.isLoading
        ? Semantics(
            liveRegion: true,
            label: 'Cargando',
            focusable: false,
            child: ExcludeSemantics(
              child: SizedBox(
                width: AppDimensions.iconSmall,
                height: AppDimensions.iconSmall,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _AppButtonUtils.foregroundColor(effectiveHierarchy, isDisabled),
                  ),
                ),
              ),
            ),
          )
        : widget.icon != null
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.icon!,
              const SizedBox(width: AppDimensions.space8),
              Text(widget.label, style: _textStyle),
            ],
          )
        : Text(widget.label, style: _textStyle);

    final button = switch (effectiveHierarchy) {
      AppButtonHierarchy.primary => _buildPrimary(content, isDisabled),
      AppButtonHierarchy.secondary => _buildSecondary(content, isDisabled),
      AppButtonHierarchy.ghost => _buildGhost(content, isDisabled),
      AppButtonHierarchy.tertiary => _buildTertiary(content, isDisabled),
      AppButtonHierarchy.disabled => _buildPrimary(content, true),
    };

    // Rule 3.4 — unified Semantics node + ExcludeSemantics on visual content
    return Semantics(
      label: effectiveSemantics,
      button: true,
      enabled: !isDisabled && !widget.isLoading,
      child: ExcludeSemantics(child: button),
    );
  }

  Widget _buildPrimary(final Widget content, final bool isDisabled) => ElevatedButton(
    onPressed: widget.isLoading || isDisabled ? null : widget.onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: isDisabled ? AppColors.disabledContainer : AppColors.primary,
      foregroundColor: isDisabled ? AppColors.textDisabled : AppColors.textOnPrimary,
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

  Widget _buildSecondary(final Widget content, final bool isDisabled) => OutlinedButton(
    onPressed: widget.isLoading || isDisabled ? null : widget.onPressed,
    style: OutlinedButton.styleFrom(
      foregroundColor: isDisabled ? AppColors.textDisabled : Colors.black,
      minimumSize: Size(AppDimensions.minTouchTarget, _height),
      side: BorderSide(
        color: isDisabled ? AppColors.disabled : AppColors.primary,
        width: 2,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(AppDimensions.radiusXs),
        ),
      ),
    ),
    child: content,
  );

  Widget _buildGhost(final Widget content, final bool isDisabled) => TextButton(
    onPressed: widget.isLoading || isDisabled ? null : widget.onPressed,
    style: TextButton.styleFrom(
      foregroundColor: isDisabled ? AppColors.textDisabled : Colors.black,
      minimumSize: Size(AppDimensions.minTouchTarget, _height),
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(AppDimensions.radiusXs),
        ),
      ),
    ),
    child: content,
  );

  Widget _buildTertiary(final Widget content, final bool isDisabled) => TextButton(
    onPressed: widget.isLoading || isDisabled ? null : widget.onPressed,
    style: TextButton.styleFrom(
      foregroundColor: isDisabled ? AppColors.textDisabled : AppColors.primary,
      backgroundColor: isDisabled ? null : AppColors.secondaryLight100,
      minimumSize: Size(AppDimensions.minTouchTarget, _height),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(AppDimensions.radiusXs),
        ),
      ),
    ),
    child: content,
  );
}

/// Internal color helper extracted from instance methods (needed after StatefulWidget split).
abstract final class _AppButtonUtils {
  static Color foregroundColor(
    final AppButtonHierarchy hierarchy,
    final bool isDisabled,
  ) {
    if (isDisabled) return AppColors.textDisabled;
    return switch (hierarchy) {
      AppButtonHierarchy.primary => AppColors.textOnPrimary,
      AppButtonHierarchy.secondary => Colors.black,
      AppButtonHierarchy.tertiary => AppColors.primary,
      AppButtonHierarchy.ghost => Colors.black,
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
