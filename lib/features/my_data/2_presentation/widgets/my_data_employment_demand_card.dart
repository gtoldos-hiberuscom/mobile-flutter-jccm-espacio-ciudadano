import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/employment_demand.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_no_data.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

class MyDataEmploymentDemandCard extends StatelessWidget {
  const MyDataEmploymentDemandCard({required this.demand, super.key});

  final EmploymentDemand demand;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isActive = demand.status?.trim().toLowerCase() == 'activa';

    return AppInfoCard(
      leadingBorderWidth: AppDimensions.space4,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 110),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.myDataEmploymentDemandTitle,
                style: AppTypography.leadingBold.copyWith(color: AppColors.primary),
              ),
              const SizedBox(height: AppDimensions.space8),
              Text(
                _display(demand.status).toUpperCase(),
                style: AppTypography.captionUppercase.copyWith(color: AppColors.textSecondary),
              ),
              if (isActive) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppDimensions.space8),
                  child: Divider(height: 1, thickness: 1, color: AppColors.neutral100),
                ),
                Text(
                  l10n.myDataEmploymentRegistrationDateLabel.toUpperCase(),
                  style: AppTypography.captionUppercase.copyWith(color: AppColors.primary),
                ),
                const SizedBox(height: AppDimensions.space4),
                Text(
                  _formatDate(context, demand.uninterruptedRegistrationDate),
                  style: AppTypography.smallRegular.copyWith(color: AppColors.primary),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class MyDataEmploymentDemandEmpty extends StatelessWidget {
  const MyDataEmploymentDemandEmpty({super.key});

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return MyDataNoData(
      message: l10n.myDataEmploymentDemandNoDataMessage,
      contactLinkText: l10n.myDataEmploymentDemandContactLink,
      contactUrl: 'https://www.sepe.es/HomeSepe',
      scrollable: false,
    );
  }
}

String _display(final String? value) {
  final normalized = value?.trim();
  if (normalized == null || normalized.isEmpty) {
    return '-';
  }
  return normalized;
}

String _formatDate(final BuildContext context, final DateTime? date) {
  if (date == null) {
    return '-';
  }
  final months = AppLocalizations.of(context).localeName.toLowerCase().startsWith('en') ? const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'] : const ['ene', 'feb', 'mar', 'abr', 'may', 'jun', 'jul', 'ago', 'sep', 'oct', 'nov', 'dic'];
  return '${date.day} ${months[date.month - 1]} ${date.year}';
}
