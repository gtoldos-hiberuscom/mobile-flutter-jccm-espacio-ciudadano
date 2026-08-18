import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_button.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// A centred error state with a message, optional detail, and retry button.
class ErrorStateWidget extends StatelessWidget {
  const ErrorStateWidget({
    required this.message,
    super.key,
    this.detail,
    this.onRetry,
    this.retryLabel,
    this.semanticsLabel,
    this.announce = true,
  }) : assert(message.length > 0, 'message must not be empty'),
       assert(detail == null || detail.length > 0, 'detail must not be empty'),
       assert(retryLabel == null || retryLabel.length > 0, 'retryLabel must not be empty'),
       assert(semanticsLabel == null || semanticsLabel.length > 0, 'semanticsLabel must not be empty');

  final String message;
  final String? detail;

  /// If provided, renders a retry [AppButton].
  final VoidCallback? onRetry;

  /// Override for the retry button label.
  final String? retryLabel;

  /// Override for the error announcement.
  final String? semanticsLabel;

  /// Whether this dynamically inserted state should be a live region.
  final bool announce;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final errorLabel = semanticsLabel ?? [l10n.a11yErrorState(message), if (detail != null) detail].join('. ');

    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Semantics(
                container: true,
                label: errorLabel,
                liveRegion: announce,
                child: const SizedBox(width: 1, height: 1),
              ),
              const ExcludeSemantics(
                child: Icon(Icons.error_outline, size: 48, color: AppColors.error),
              ),
              const SizedBox(height: 16),
              Semantics(
                header: true,
                headingLevel: 2,
                child: Text(
                  message,
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              if (detail != null) ...[
                const SizedBox(height: 8),
                ExcludeSemantics(
                  child: Text(
                    detail!,
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
              if (onRetry != null) ...[
                const SizedBox(height: 24),
                AppButton(
                  onPressed: onRetry,
                  label: retryLabel ?? l10n.errorStateRetry,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
