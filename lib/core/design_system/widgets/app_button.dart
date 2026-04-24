import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';

/// Variant of the application button widget.
enum AppButtonVariant {
  /// Elevated primary action button.
  primary,

  /// Outlined secondary action button.
  outlined,

  /// Text-only tertiary action button.
  text,
}

/// Design-system button that enforces a minimum 48 dp touch target (WCAG 2.1).
///
/// Wrap any primary, secondary, or text action in [AppButton] to guarantee:
/// - Correct variant colours from [Theme].
/// - Accessible minimum tap area.
/// - [Semantics] label for screen readers.
///
/// Example:
/// ```dart
/// AppButton(
///   label: context.l10n.retry,
///   onPressed: _retry,
/// )
/// ```
class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.variant = AppButtonVariant.primary,
    this.semanticsLabel,
    this.icon,
    this.isLoading = false,
  });

  /// The visible button label.
  final String label;

  /// Called when the button is tapped. Pass `null` to disable the button.
  final VoidCallback? onPressed;

  /// Visual variant — defaults to [AppButtonVariant.primary].
  final AppButtonVariant variant;

  /// Optional override for the screen-reader label. Defaults to [label].
  final String? semanticsLabel;

  /// Optional leading icon.
  final Widget? icon;

  /// When `true`, shows a [CircularProgressIndicator] instead of the label.
  final bool isLoading;

  @override
  Widget build(final BuildContext context) {
    final effectiveSemantics = semanticsLabel ?? label;
    final Widget child = isLoading
        ? const SizedBox(
            width: AppDimensions.iconSmall,
            height: AppDimensions.iconSmall,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : icon != null
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon!,
              const SizedBox(width: AppDimensions.space8),
              Text(label),
            ],
          )
        : Text(label);

    final Widget button = switch (variant) {
      AppButtonVariant.primary => ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(
            AppDimensions.minTouchTarget,
            AppDimensions.minTouchTarget,
          ),
        ),
        child: child,
      ),
      AppButtonVariant.outlined => OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(
            AppDimensions.minTouchTarget,
            AppDimensions.minTouchTarget,
          ),
        ),
        child: child,
      ),
      AppButtonVariant.text => TextButton(
        onPressed: isLoading ? null : onPressed,
        style: TextButton.styleFrom(
          minimumSize: const Size(
            AppDimensions.minTouchTarget,
            AppDimensions.minTouchTarget,
          ),
        ),
        child: child,
      ),
    };

    return Semantics(
      label: effectiveSemantics,
      button: true,
      enabled: onPressed != null && !isLoading,
      child: button,
    );
  }
}
