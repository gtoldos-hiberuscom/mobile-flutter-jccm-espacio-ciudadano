import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Demanda sin datos disponibles por falta de autorización o fallo del servicio.
class MyDataEmploymentDisabledDemandCard extends StatelessWidget {
  const MyDataEmploymentDisabledDemandCard({super.key});

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppInfoCard(
      leadingBorderWidth: AppDimensions.space4,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space24,
        vertical: AppDimensions.space12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.myDataEmploymentDemandTitle,
            style: AppTypography.leadingBold.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: AppDimensions.space8),
          Text(
            l10n.myDataEmploymentDemandUnavailableStatus.toUpperCase(),
            style: AppTypography.captionUppercase.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppDimensions.space8),
          const Divider(height: 1, thickness: 1, color: AppColors.neutral100),
          const SizedBox(height: AppDimensions.space8),
          Text(
            l10n.myDataEmploymentRegistrationDateLabel.toUpperCase(),
            style: AppTypography.captionUppercase.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: AppDimensions.space4),
          Text(
            '-',
            style: AppTypography.smallRegular.copyWith(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
