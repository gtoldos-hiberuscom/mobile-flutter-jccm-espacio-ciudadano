import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_icons.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_modal_layout.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_shadows.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_button.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_checkbox.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Lo que el ciudadano decidió en el aviso de verificación de identidad.
@immutable
class AppIdentityVerificationChoice {
  const AppIdentityVerificationChoice({required this.accepted, required this.suppressFuture});

  /// Pulsó «Acceder a Cl@ve». `false` si volvió atrás.
  final bool accepted;

  /// Marcó «No volver a mostrar».
  ///
  /// Solo omite **este aviso**: el control de nivel sigue en pie y la próxima
  /// vez se va directo a Cl@ve en lugar de explicarlo primero.
  final bool suppressFuture;
}

/// Aviso bloqueante de que la consulta exige un nivel de seguridad mayor.
///
/// Figma: `Alerts/Dialog` node `45049:60881`. Mismo componente que el
/// diálogo de navegación externa, del que copia estructura y medidas: icono
/// circular, título, cuerpo y dos botones dicotómicos.
///
/// Es bloqueante a propósito —sin descarte por fuera ni por atrás—: la
/// descripción del componente en Figma dice que no se puede continuar sin
/// responder, y aquí además no hay nada que ver detrás hasta que se eleve.
///
/// Los botones van **apilados**, no en fila como en el diálogo de navegación
/// externa: «Acceder a Cl@ve» saca de la aplicación y conviene que no quede
/// pegado al de volver.
class AppIdentityVerificationDialog extends StatefulWidget {
  const AppIdentityVerificationDialog({
    required this.onBack,
    required this.onContinue,
    super.key,
    this.message,
  });

  /// Qué se cuenta bajo el título. Por defecto, el motivo del bloqueo; quien
  /// llama puede pasar el desenlace de un intento anterior.
  final String? message;

  final void Function({required bool suppressFuture}) onBack;
  final void Function({required bool suppressFuture}) onContinue;

  static Future<AppIdentityVerificationChoice?> show(
    final BuildContext context, {
    final String? message,
  }) {
    return showDialog<AppIdentityVerificationChoice>(
      context: context,
      requestFocus: true,
      barrierDismissible: false,
      barrierColor: const Color(0xCC031B35),
      builder: (final dialogContext) => AppIdentityVerificationDialog(
        message: message,
        onBack: ({required final suppressFuture}) => Navigator.of(dialogContext).pop(
          AppIdentityVerificationChoice(accepted: false, suppressFuture: suppressFuture),
        ),
        onContinue: ({required final suppressFuture}) => Navigator.of(dialogContext).pop(
          AppIdentityVerificationChoice(accepted: true, suppressFuture: suppressFuture),
        ),
      ),
    );
  }

  @override
  State<AppIdentityVerificationDialog> createState() => _AppIdentityVerificationDialogState();
}

class _AppIdentityVerificationDialogState extends State<AppIdentityVerificationDialog> {
  bool _suppressFuture = false;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = l10n.identityVerificationDialogTitle;

    return Semantics(
      container: true,
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      label: title,
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
                        child: const AppIcon(AppIcons.lock, color: AppColors.primary),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space8),
                  Semantics(
                    header: true,
                    headingLevel: 1,
                    sortKey: const OrdinalSortKey(1),
                    child: Padding(
                      padding: const EdgeInsets.only(top: AppDimensions.space4, bottom: AppDimensions.space8),
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
                        widget.message ?? l10n.identityVerificationDialogBody,
                        style: AppTypography.bodyRegular.copyWith(color: AppColors.primary),
                      ),
                    ),
                  ),
                  Semantics(
                    sortKey: const OrdinalSortKey(3),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppDimensions.space16),
                      child: AppCheckbox(
                        label: l10n.identityVerificationDialogDoNotShowAgain,
                        value: _suppressFuture,
                        onChanged: (final value) => setState(() => _suppressFuture = value ?? false),
                      ),
                    ),
                  ),
                  Semantics(
                    sortKey: const OrdinalSortKey(4),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AppButton(
                            label: l10n.identityVerificationDialogBack,
                            hierarchy: AppButtonHierarchy.tertiary,
                            isExpanded: true,
                            onPressed: () => widget.onBack(suppressFuture: _suppressFuture),
                          ),
                          const SizedBox(height: AppDimensions.space16),
                          AppButton(
                            label: l10n.identityVerificationDialogContinue,
                            trailingIcon: AppIcons.openInNew,
                            isExpanded: true,
                            onPressed: () => widget.onContinue(suppressFuture: _suppressFuture),
                          ),
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
