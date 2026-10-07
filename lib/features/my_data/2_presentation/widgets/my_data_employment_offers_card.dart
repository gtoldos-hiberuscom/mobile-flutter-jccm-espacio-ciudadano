import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_authorization_contextual_helper.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_employment_disabled_offers_card.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_employment_retry_icon_button.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

class MyDataEmploymentOffersCard extends StatelessWidget {
  const MyDataEmploymentOffersCard({
    required this.onTap,
    super.key,
  });

  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppNavigationCard(
      title: l10n.myDataEmploymentOffersTitle,
      description: l10n.myDataEmploymentOffersDescription,
      onTap: onTap,
    );
  }
}

class MyDataEmploymentDisabledOffersBlock extends StatelessWidget {
  const MyDataEmploymentDisabledOffersBlock({
    required this.onRetry,
    required this.onOpenSettings,
    super.key,
  });

  final VoidCallback onRetry;
  final VoidCallback onOpenSettings;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const MyDataEmploymentDisabledOffersCard(),
        MyDataAuthorizationContextualHelper(
          message: l10n.myDataEmploymentOffersAuthorizationRequiredMessage,
          semanticsLabel: l10n.myDataJccmAuthorizationRequiredCta,
          showTextAction: true,
          onOpenSettings: onOpenSettings,
        ),
        const SizedBox(height: AppDimensions.space8),
        AppAlertContextual(
          message: l10n.myDataEmploymentOffersServiceUnavailableMessage,
          size: AppAlertContextualSize.small,
          horizontal: true,
          action: MyDataEmploymentRetryIconButton(onPressed: onRetry),
        ),
      ],
    );
  }
}
