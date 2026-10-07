import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Demanda sin datos disponibles por falta de autorización o fallo del servicio.
class MyDataEmploymentDisabledDemandCard extends StatelessWidget {
  const MyDataEmploymentDisabledDemandCard({super.key, this.showUnavailableDetails = true});

  /// La falta de autorizacion impide conocer el estado de la demanda, por lo
  /// que la tarjeta se mantiene con un guion como valor desconocido, sin
  /// afirmar un estado ni mostrar la etiqueta de fecha.
  final bool showUnavailableDetails;

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
          if (showUnavailableDetails) ...[
            const SizedBox(height: AppDimensions.space8),
            Text(
              l10n.myDataEmploymentDemandUnavailableStatus.toUpperCase(),
              style: AppTypography.captionUppercase.copyWith(color: AppColors.textSecondary),
            ),
          ] else ...[
            const SizedBox(height: AppDimensions.space8),
            Text(
              '-',
              style: AppTypography.smallRegular.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppDimensions.space8),
            const Divider(height: 1, thickness: 1, color: AppColors.neutral100),
          ],
        ],
      ),
    );
  }
}
