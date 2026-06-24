import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.myDataEmploymentOffersLoadError,
              textAlign: TextAlign.center,
              style: AppTypography.bodyRegular.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: AppDimensions.space16),
            AppButton(
              label: l10n.errorStateRetry,
              onPressed: onRetry,
              hierarchy: AppButtonHierarchy.secondary,
            ),
          ],
        ),
      ),
    );
  }
}
