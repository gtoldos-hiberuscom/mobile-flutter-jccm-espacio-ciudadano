import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/features/signature/0_entity/signature_document_status.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Visual chip representing a [SignatureDocumentStatus] (STORY-45).
class SignatureStatusChip extends StatelessWidget {
  const SignatureStatusChip({required this.status, super.key});

  final SignatureDocumentStatus status;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final color = _colorFor(theme, status);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space8,
        vertical: AppDimensions.space4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
      ),
      child: Text(
        labelFor(l10n, status),
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Resolves the localised label for [status].
  static String labelFor(final AppLocalizations l10n, final SignatureDocumentStatus status) {
    switch (status) {
      case SignatureDocumentStatus.pendiente:
        return l10n.signatureStatusPendiente;
      case SignatureDocumentStatus.firmado:
        return l10n.signatureStatusFirmado;
      case SignatureDocumentStatus.expirado:
        return l10n.signatureStatusExpirado;
      case SignatureDocumentStatus.error:
        return l10n.signatureStatusError;
      case SignatureDocumentStatus.unknown:
        return l10n.signatureStatusUnknown;
    }
  }

  Color _colorFor(final ThemeData theme, final SignatureDocumentStatus status) {
    switch (status) {
      case SignatureDocumentStatus.pendiente:
        return AppColors.warning;
      case SignatureDocumentStatus.firmado:
        return AppColors.success;
      case SignatureDocumentStatus.expirado:
        return theme.colorScheme.outline;
      case SignatureDocumentStatus.error:
        return AppColors.error;
      case SignatureDocumentStatus.unknown:
        return theme.colorScheme.outline;
    }
  }
}
