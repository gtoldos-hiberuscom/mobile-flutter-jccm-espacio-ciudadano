import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/employment_offer_registration.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_employment_offer_registration_card.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_employment_offers_empty.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

class MyDataEmploymentOffersContent extends StatelessWidget {
  const MyDataEmploymentOffersContent({
    required this.offers,
    super.key,
  });

  final List<EmploymentOfferRegistration> offers;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: appPagePadding(context, top: AppDimensions.space16, bottom: AppDimensions.space64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.myDataEmploymentOffersPageTitle,
            style: AppTypography.h2.copyWith(color: AppColors.primary),
          ),
          if (offers.isEmpty) ...[
            const SizedBox(height: AppDimensions.space16),
            const Divider(color: AppColors.neutral100, thickness: 1),
            const SizedBox(height: AppDimensions.space16),
            const MyDataEmploymentOffersEmpty(),
          ] else ...[
            const SizedBox(height: AppDimensions.space24),
            ...offers.map(
              (final offer) => Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.space16),
                child: MyDataEmploymentOfferRegistrationCard(offer: offer),
              ),
            ),
            const Divider(color: AppColors.neutral100, thickness: 1),
          ],
        ],
      ),
    );
  }
}
