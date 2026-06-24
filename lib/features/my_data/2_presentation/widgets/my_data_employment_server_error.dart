import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_employment_demand_skeleton_card.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_employment_offers_card.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

class MyDataEmploymentServerError extends StatelessWidget {
  const MyDataEmploymentServerError({
    required this.showBanner,
    required this.onDismiss,
    required this.onRetry,
    required this.onOpenSettings,
    super.key,
  });

  final bool showBanner;
  final VoidCallback onDismiss;
  final VoidCallback onRetry;
  final VoidCallback onOpenSettings;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showBanner) ...[
          AppAlertBanner(
            title: l10n.myDataEmploymentServiceUnavailableTitle,
            message: l10n.myDataEmploymentServiceUnavailableMessage,
            onDismiss: onDismiss,
            action: AppButton(
              label: l10n.myDataEmploymentServiceUnavailableReload,
              onPressed: onRetry,
              hierarchy: AppButtonHierarchy.tertiary,
              size: AppButtonSize.small,
            ),
          ),
          const SizedBox(height: AppDimensions.space24),
        ],
        const MyDataEmploymentDemandSkeletonCard(),
        const SizedBox(height: AppDimensions.space24),
        MyDataEmploymentDisabledOffersBlock(
          onRetry: onRetry,
          onOpenSettings: onOpenSettings,
        ),
      ],
    );
  }
}
