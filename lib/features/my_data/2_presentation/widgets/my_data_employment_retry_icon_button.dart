import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

class MyDataEmploymentRetryIconButton extends StatelessWidget {
  const MyDataEmploymentRetryIconButton({
    required this.onPressed,
    super.key,
  });

  final VoidCallback onPressed;

  @override
  Widget build(final BuildContext context) {
    return Semantics(
      button: true,
      label: AppLocalizations.of(context).myDataEmploymentServiceUnavailableReload,
      child: ExcludeSemantics(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.backgroundWhite,
            border: Border.all(color: AppColors.primary, width: 2),
            borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
            boxShadow: AppShadows.low,
          ),
          child: AppFocusRing(
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
              child: const SizedBox(
                width: AppDimensions.minTouchTarget,
                height: AppDimensions.minTouchTarget,
                child: Center(
                  child: AppIcon(
                    AppIcons.autorenew,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
