import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_service_unavailable.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

class MyDataEmploymentOffersLoadError extends StatelessWidget {
  const MyDataEmploymentOffersLoadError({
    required this.onRetry,
    super.key,
  });

  final VoidCallback onRetry;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return MyDataServiceUnavailable(
      message: l10n.myDataEmploymentOffersServiceUnavailableMessage,
      actionLabel: l10n.myDataServiceUnavailableUpdate,
      onRetry: onRetry,
    );
  }
}
