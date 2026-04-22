import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_button.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Displays an authentication error and a retry option.
///
/// Shown by [LoginPage] when the Cl@ve login initiation fails.
/// The retry callback is supplied by the parent so this widget stays stateless
/// and is trivially testable.
class SessionErrorWidget extends StatelessWidget {
  const SessionErrorWidget({
    required this.message,
    required this.onRetry,
    super.key,
  });

  /// Localised error message to display. Must not contain PII.
  final String message;

  /// Called when the user taps the retry button.
  final VoidCallback onRetry;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      liveRegion: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Error icon
          Semantics(
            excludeSemantics: true,
            child: const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
          ),
          const SizedBox(height: AppDimensions.space16),

          // Error message
          Text(
            l10n.loginPageError,
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.error,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.space8),

          // Detail message
          Text(
            message,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.space24),

          // Retry CTA
          AppButton(
            label: l10n.loginRetryButton,
            semanticsLabel: l10n.loginRetryButton,
            onPressed: onRetry,
          ),
        ],
      ),
    );
  }
}
