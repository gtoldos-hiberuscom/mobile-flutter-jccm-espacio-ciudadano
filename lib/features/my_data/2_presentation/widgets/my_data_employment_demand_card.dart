import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/employment_demand.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

class MyDataEmploymentDemandCard extends StatelessWidget {
  const MyDataEmploymentDemandCard({required this.demand, super.key});

  final EmploymentDemand demand;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isNotRegistered = _isNotRegistered(demand.status);

    return AppInfoCard(
      leadingBorderWidth: AppDimensions.space4,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: isNotRegistered ? AppDimensions.space64 : 110),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
                child: Text(
                  _display(demand.status).toUpperCase(),
                  style: AppTypography.captionUppercase.copyWith(color: AppColors.borderBlueMutedBase),
                ),
              ),
              Text(
                l10n.myDataEmploymentDemandTitle,
                style: AppTypography.leadingBold.copyWith(color: AppColors.primary),
              ),
              if (!isNotRegistered) ...[
                const SizedBox(height: AppDimensions.space8),
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
    return AppInfoCard(
      leadingBorderWidth: AppDimensions.space4,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Text(
          l10n.myDataEmploymentDemandEmpty,
          style: AppTypography.bodyRegular.copyWith(color: AppColors.textPrimary),
        ),
      ),
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

bool _isNotRegistered(final String? value) {
  final normalized = value?.trim().toLowerCase();
  return normalized == 'no inscrito' || normalized == 'no activa';
}

String _formatDate(final BuildContext context, final DateTime? date) {
  if (date == null) {
    return '-';
  }
  final months = AppLocalizations.of(context).localeName.toLowerCase().startsWith('en') ? const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'] : const ['ene', 'feb', 'mar', 'abr', 'may', 'jun', 'jul', 'ago', 'sep', 'oct', 'nov', 'dic'];
  return '${date.day} ${months[date.month - 1]} ${date.year}';
}
