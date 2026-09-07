import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

class MyDataEmploymentDisabledDemandCard extends StatelessWidget {
  const MyDataEmploymentDisabledDemandCard({super.key});

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final borderRadius = BorderRadius.circular(AppDimensions.radiusMedium);

    return Semantics(
      enabled: false,
      label: l10n.myDataEmploymentDemandTitle,
      child: ExcludeSemantics(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.neutral100,
            border: Border.all(color: AppColors.borderNeutralLight),
            borderRadius: borderRadius,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 80),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.space16,
                vertical: AppDimensions.space8,
              ),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  l10n.myDataEmploymentDemandTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.leadingMedium.copyWith(color: AppColors.textDisabled),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
