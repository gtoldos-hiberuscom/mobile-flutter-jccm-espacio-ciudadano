import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_no_data.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

class MyDataEmploymentOffersEmpty extends StatelessWidget {
  const MyDataEmploymentOffersEmpty({super.key});

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return MyDataNoData(
      message: l10n.myDataEmploymentOffersNoDataMessage,
      actionLabel: l10n.myDataEmploymentOffersPortalLink,
      contactUrl: 'https://empleo.castillalamancha.es/',
      scrollable: false,
    );
  }
}
