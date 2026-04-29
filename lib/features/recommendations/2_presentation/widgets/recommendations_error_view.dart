import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/error_state_widget.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Standard error state for the recommendations list — re-uses the
/// shared [ErrorStateWidget] with feature-specific copy.
class RecommendationsErrorView extends StatelessWidget {
  const RecommendationsErrorView({required this.onRetry, super.key, this.detail});

  final VoidCallback onRetry;
  final String? detail;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ErrorStateWidget(
      message: l10n.recommendationsLoadingError,
      detail: detail,
      onRetry: onRetry,
      retryLabel: l10n.recommendationsLoadingErrorRetry,
    );
  }
}
