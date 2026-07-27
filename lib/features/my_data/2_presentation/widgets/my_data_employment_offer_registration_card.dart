import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/employment_offer_registration.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_employment_offer_field_row.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

class MyDataEmploymentOfferRegistrationCard extends StatelessWidget {
  const MyDataEmploymentOfferRegistrationCard({
    required this.offer,
    super.key,
  });

  final EmploymentOfferRegistration offer;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppInfoCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _display(offer.title),
              style: AppTypography.leadingBold.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: AppDimensions.space8),
            MyDataEmploymentOfferFieldRow(
              label: l10n.myDataEmploymentOfferPublicationDateLabel,
              value: _formatDate(context, offer.publicationDate),
            ),
            MyDataEmploymentOfferFieldRow(
              label: l10n.myDataEmploymentOfferRegistrationDateLabel,
              value: _formatDate(context, offer.registrationDate),
            ),
            if (offer.selectionEndDate != null)
              MyDataEmploymentOfferFieldRow(
                label: l10n.myDataEmploymentOfferSelectionEndDateLabel,
                value: _formatDate(context, offer.selectionEndDate),
              ),
            MyDataEmploymentOfferFieldRow(
              label: l10n.myDataEmploymentOfferApplicationStatusLabel,
              value: _display(offer.applicationStatus),
            ),
          ],
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

String _formatDate(final BuildContext context, final DateTime? date) {
  if (date == null) {
    return '-';
  }
  final months = AppLocalizations.of(context).localeName.toLowerCase().startsWith('en') ? const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'] : const ['ene', 'feb', 'mar', 'abr', 'may', 'jun', 'jul', 'ago', 'sep', 'oct', 'nov', 'dic'];
  return '${date.day} ${months[date.month - 1]} ${date.year}';
}
