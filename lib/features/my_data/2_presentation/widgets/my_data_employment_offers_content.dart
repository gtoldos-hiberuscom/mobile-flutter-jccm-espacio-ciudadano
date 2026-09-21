import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/employment_offer_registration.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_employment_offer_registration_card.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_employment_offers_empty.dart';

class MyDataEmploymentOffersContent extends StatelessWidget {
  const MyDataEmploymentOffersContent({
    required this.offers,
    super.key,
  });

  final List<EmploymentOfferRegistration> offers;

  @override
  Widget build(final BuildContext context) {
    return SingleChildScrollView(
      padding: appPagePadding(context, top: AppDimensions.space16, bottom: AppDimensions.space64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (offers.isEmpty) ...[
            const MyDataEmploymentOffersEmpty(),
          ] else ...[
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
