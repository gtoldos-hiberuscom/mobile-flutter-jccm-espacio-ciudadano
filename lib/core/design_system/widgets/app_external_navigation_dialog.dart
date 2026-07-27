import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_icons.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_shadows.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_button.dart';

/// Blocking confirmation shown before content opens outside the application.
///
/// Figma: `Alerts/Dialog` node `44641:25380`.
class AppExternalNavigationDialog extends StatelessWidget {
  const AppExternalNavigationDialog({
    required this.onCancel,
    required this.onContinue,
    super.key,
  });

  final VoidCallback onCancel;
  final VoidCallback onContinue;

  static Future<bool> show(final BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      barrierColor: const Color(0xCC031B35),
      builder: (final dialogContext) => AppExternalNavigationDialog(
        onCancel: () => Navigator.of(dialogContext).pop(false),
        onContinue: () => Navigator.of(dialogContext).pop(true),
      ),
    );
    return confirmed ?? false;
  }

  @override
  Widget build(final BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space16,
        vertical: AppDimensions.space64,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space16,
          vertical: AppDimensions.space32,
        ),
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          border: Border.all(color: AppColors.borderBlueMutedLight),
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          boxShadow: AppShadows.overAll,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(AppDimensions.space8),
                decoration: BoxDecoration(
                  color: AppColors.backgroundBlueMutedLight,
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusRound,
                  ),
                ),
                child: const AppIcon(
                  AppIcons.openInNew,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.space8),
            Padding(
              padding: const EdgeInsets.only(
                top: AppDimensions.space4,
                bottom: AppDimensions.space8,
              ),
              child: Text(
                'Vas a salir de la aplicación',
                textAlign: TextAlign.center,
                style: AppTypography.h3.copyWith(color: AppColors.primary),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppDimensions.space4,
              ),
              child: Text(
                'El contenido se abrirá en una ventana de tu navegador',
                style: AppTypography.bodyRegular.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.space8),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.space16,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'Volver',
                      hierarchy: AppButtonHierarchy.tertiary,
                      onPressed: onCancel,
                      isExpanded: true,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.space16),
                  Expanded(
                    child: AppButton(
                      label: 'Continuar',
                      onPressed: onContinue,
                      isExpanded: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
