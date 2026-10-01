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
    final fields = [
      (l10n.myDataEmploymentOfferPublicationDateLabel, _formatDate(context, offer.publicationDate)),
      (l10n.myDataEmploymentOfferRegistrationDateLabel, _formatDate(context, offer.registrationDate)),
      (l10n.myDataEmploymentOfferSelectionEndDateLabel, _formatDate(context, offer.selectionEndDate)),
    ];
    // Una oferta, un nodo: nombre, estado y cada fecha con su etiqueta, en
    // orden de lectura (WCAG 1.3.1). Las etiquetas van sin mayúsculas para
    // que el lector no las deletree.
    final semanticLabel = [
      _display(offer.title),
      _display(offer.applicationStatus),
      for (final (label, value) in fields) '$label: $value',
    ].join('. ');

    return Semantics(
      container: true,
      label: semanticLabel,
      child: ExcludeSemantics(
        child: AppInfoCard(
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
                Text(
                  _display(offer.applicationStatus).toUpperCase(),
                  style: AppTypography.captionUppercase.copyWith(color: AppColors.textSecondary),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppDimensions.space8),
                  child: Divider(height: 1, thickness: 1, color: AppColors.neutral100),
                ),
                for (final (label, value) in fields) MyDataEmploymentOfferFieldRow(label: label, value: value),
              ],
            ),
          ),
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
