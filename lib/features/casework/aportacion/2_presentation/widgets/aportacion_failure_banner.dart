import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/features/casework/aportacion/0_entity/aportacion_failure.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// In-step banner used by the aportación wizard to surface domain
/// failures (STORY-37). Pure presentation — no Riverpod imports.
class AportacionFailureBanner extends StatelessWidget {
  const AportacionFailureBanner({required this.failure, super.key});

  final AportacionFailure failure;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final message = switch (failure) {
      AportacionFailure.invalidIdentification =>
        l10n.caseworkAportacionFailureInvalidIdentification,
      AportacionFailure.notFound => l10n.caseworkAportacionFailureNotFound,
      AportacionFailure.networkError =>
        l10n.caseworkAportacionFailureNetworkError,
    };
    return Container(
      padding: const EdgeInsets.all(AppDimensions.space12),
      decoration: BoxDecoration(
        color: AppColors.warningContainer,
        border: Border.all(color: AppColors.warning),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Icon(Icons.error_outline, color: AppColors.warning),
          const SizedBox(width: AppDimensions.space8),
          Expanded(
            child: Text(message, style: theme.textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
