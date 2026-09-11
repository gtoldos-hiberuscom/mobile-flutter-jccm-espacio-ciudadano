import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Demanda sin datos disponibles por falta de autorización o fallo del servicio.
class MyDataEmploymentDisabledDemandCard extends StatelessWidget {
  const MyDataEmploymentDisabledDemandCard({super.key});

  @override
  Widget build(final BuildContext context) {
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
            AppLocalizations.of(context).myDataEmploymentDemandTitle,
            style: AppTypography.leadingBold.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: AppDimensions.space8),
          Text(
            '-',
            style: AppTypography.bodyRegular.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppDimensions.space8),
          const Divider(height: 1, thickness: 1, color: AppColors.neutral100),
        ],
      ),
    );
  }
}
