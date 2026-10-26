import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_employment_disabled_demand_card.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_employment_retry_icon_button.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

class MyDataEmploymentServerError extends StatelessWidget {
  const MyDataEmploymentServerError({
    required this.onRetry,
    super.key,
  });

  final VoidCallback onRetry;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const MyDataEmploymentDisabledDemandCard(showUnavailableDetails: false),
        const SizedBox(height: AppDimensions.space24),
        AppAlertContextual(
          message: l10n.myDataEmploymentServiceUnavailableMessage,
          size: AppAlertContextualSize.small,
          horizontal: true,
          action: MyDataEmploymentRetryIconButton(onPressed: onRetry),
        ),
      ],
    );
  }
}
