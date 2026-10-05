import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_icons.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_modal_layout.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_shadows.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_button.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_update_info.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Aviso de actualización. Mismo lienzo que `AppExternalNavigationDialog`
/// (Figma `Alerts/Dialog`), con «Ahora no» solo cuando se puede descartar.
///
/// No se abre con `showDialog`: lo pinta `AppUpdateGate` por encima del router.
class AppUpdateDialog extends StatelessWidget {
  const AppUpdateDialog({
    required this.info,
    required this.onUpdate,
    this.onLater,
    this.storeOpenFailed = false,
    super.key,
  });

  final AppUpdateInfo info;
  final VoidCallback onUpdate;

  /// `null` cuando la actualización es forzada: sin botón de descartar.
  final VoidCallback? onLater;

  final bool storeOpenFailed;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final version = info.latestVersion.toString();
    final title = info.isForced ? l10n.appUpdateRequiredTitle : l10n.appUpdateRecommendedTitle;
    final body = info.isForced ? l10n.appUpdateRequiredBody(version) : l10n.appUpdateRecommendedBody(version);
    final useVerticalActions = MediaQuery.textScalerOf(context).scale(1) > 1.5;
    final onLater = this.onLater;

    final updateButton = AppButton(
      label: l10n.appUpdateAction,
      onPressed: onUpdate,
      isExpanded: true,
    );
    final laterButton = onLater == null
        ? null
        : AppButton(
            label: l10n.appUpdateLater,
            hierarchy: AppButtonHierarchy.tertiary,
            onPressed: onLater,
            isExpanded: true,
          );

    return Semantics(
      container: true,
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      label: l10n.appUpdateA11yDialog,
      child: FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: Dialog(
          constraints: appModalDialogConstraints(context),
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: ExcludeSemantics(
                      child: Container(
                        padding: const EdgeInsets.all(AppDimensions.space8),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundBlueMutedLight,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
                        ),
                        child: const AppIcon(
                          AppIcons.download,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space8),
                  Semantics(
                    header: true,
                    headingLevel: 1,
                    sortKey: const OrdinalSortKey(1),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: AppDimensions.space4,
                        bottom: AppDimensions.space8,
                      ),
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: AppTypography.h3.copyWith(color: AppColors.primary),
                      ),
                    ),
                  ),
                  Semantics(
                    sortKey: const OrdinalSortKey(2),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
                      child: Text(
                        body,
                        style: AppTypography.bodyRegular.copyWith(color: AppColors.primary),
                      ),
                    ),
                  ),
                  if (storeOpenFailed)
                    Semantics(
                      liveRegion: true,
                      sortKey: const OrdinalSortKey(3),
                      child: Padding(
                        padding: const EdgeInsets.only(top: AppDimensions.space8),
                        child: Text(
                          l10n.appUpdateStoreUnavailable,
                          style: AppTypography.smallRegular.copyWith(color: AppColors.errorDark),
                        ),
                      ),
                    ),
                  const SizedBox(height: AppDimensions.space8),
                  Semantics(
                    sortKey: const OrdinalSortKey(4),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space16),
                      child: laterButton == null
                          ? updateButton
                          : useVerticalActions
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                laterButton,
                                const SizedBox(height: AppDimensions.space8),
                                updateButton,
                              ],
                            )
                          : Row(
                              children: [
                                Expanded(child: laterButton),
                                const SizedBox(width: AppDimensions.space16),
                                Expanded(child: updateButton),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
