import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_icons.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_alert.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_button.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_description_text.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_input_case.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_navigation.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_phone_input_case.dart';

class AppNotificationContactForm extends StatelessWidget {
  const AppNotificationContactForm({
    required this.formError,
    required this.phoneError,
    required this.emailError,
    required this.saving,
    required this.phoneController,
    required this.emailController,
    required this.onClearError,
    required this.onLeave,
    required this.onSave,
    super.key,
  });

  final String? formError;
  final String? phoneError;
  final String? emailError;
  final bool saving;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final VoidCallback onClearError;
  final VoidCallback onLeave;
  final VoidCallback onSave;

  @override
  Widget build(final BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.space16,
              AppDimensions.space24,
              AppDimensions.space16,
              AppDimensions.space24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  header: true,
                  child: Text(
                    'Datos de contacto para notificaciones electrónicas',
                    style: AppTypography.h2.copyWith(color: AppColors.textBase),
                  ),
                ),
                const SizedBox(height: AppDimensions.space24),
                Semantics(
                  label: 'Obligatorio: rellena al menos uno de los medios de contacto',
                  child: ExcludeSemantics(
                    child: Text(
                      '* Obligatorio rellenar al menos uno de los medios de contacto',
                      style: AppTypography.smallRegular.copyWith(color: AppColors.textBase),
                    ),
                  ),
                ),
                if (formError != null) ...[
                  const SizedBox(height: AppDimensions.space12),
                  AppAlertBanner(
                    message: formError!,
                    title: 'Error',
                    severity: AppAlertSeverity.error,
                    onDismiss: onClearError,
                  ),
                ],
                const SizedBox(height: AppDimensions.space24),
                AutofillGroup(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppPhoneInputCase(
                        label: 'Teléfono móvil',
                        controller: phoneController,
                        errorText: phoneError,
                        onChanged: (_) => onClearError(),
                      ),
                      if (phoneError == null) ...[
                        const SizedBox(height: AppDimensions.space8),
                        const AppDescriptionText(
                          text: 'Para recibir las notificaciones en mensaje SMS',
                        ),
                      ],
                      const SizedBox(height: AppDimensions.space24),
                      AppInputCase(
                        label: 'Correo electrónico',
                        hint: 'Ejemplo: mperez@correo.es',
                        controller: emailController,
                        state: emailError == null ? AppInputState.defaultState : AppInputState.error,
                        errorText: emailError,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        autofillHints: const [AutofillHints.email],
                        autocorrect: false,
                        prefixIcon: const Icon(
                          AppIcons.alternateEmail,
                          color: AppColors.textPrimary,
                        ),
                        onChanged: (_) => onClearError(),
                        onSubmitted: saving ? null : (_) => onSave(),
                      ),
                      if (emailError == null) ...[
                        const SizedBox(height: AppDimensions.space8),
                        const AppDescriptionText(
                          text: 'Para recibir las notificaciones en tu correo electrónico',
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        AppStickyBar(
          type: AppStickyBarType.dicotomy,
          secondaryLabel: 'Cancelar',
          secondaryLeadingIcon: AppIcons.cancel,
          secondaryHierarchy: AppButtonHierarchy.tertiary,
          onSecondary: saving ? null : onLeave,
          primaryLabel: 'Guarda cambios',
          primaryLeadingIcon: AppIcons.check,
          isPrimaryLoading: saving,
          onPrimary: saving ? null : onSave,
        ),
      ],
    );
  }
}
