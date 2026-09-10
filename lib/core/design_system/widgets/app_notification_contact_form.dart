import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_icons.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_page_layout.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_typography.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_alert.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_button.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_description_text.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_input_case.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_navigation.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_phone_input_case.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: appPagePadding(
              context,
              top: AppDimensions.space24,
              bottom: AppDimensions.space24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  header: true,
                  child: Text(
                    l10n.appNotificationContactFormTitle,
                    style: AppTypography.h2.copyWith(color: AppColors.textBase),
                  ),
                ),
                const SizedBox(height: AppDimensions.space24),
                Semantics(
                  label: l10n.appNotificationContactFormRequiredNoteSemantic,
                  child: ExcludeSemantics(
                    child: Text(
                      l10n.appNotificationContactFormRequiredNote,
                      style: AppTypography.smallRegular.copyWith(color: AppColors.textBase),
                    ),
                  ),
                ),
                if (formError != null) ...[
                  const SizedBox(height: AppDimensions.space12),
                  AppAlertBanner(
                    message: formError!,
                    title: l10n.a11yAlertError,
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
                        label: l10n.gestionNotificacionesAltaPhoneLabel,
                        controller: phoneController,
                        errorText: phoneError,
                        onChanged: (_) => onClearError(),
                      ),
                      if (phoneError == null) ...[
                        const SizedBox(height: AppDimensions.space8),
                        AppDescriptionText(
                          text: l10n.gestionNotificacionesAltaPhoneHelper,
                        ),
                      ],
                      const SizedBox(height: AppDimensions.space24),
                      AppInputCase(
                        label: l10n.gestionNotificacionesAltaEmailLabel,
                        hint: l10n.gestionNotificacionesAltaEmailHint,
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
                        AppDescriptionText(
                          text: l10n.gestionNotificacionesAltaEmailHelper,
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
          secondaryLabel: l10n.a11yCancel,
          secondaryLeadingIcon: AppIcons.cancel,
          secondaryHierarchy: AppButtonHierarchy.tertiary,
          onSecondary: saving ? null : onLeave,
          primaryLabel: l10n.appNotificationContactFormSaveButton,
          primaryLeadingIcon: AppIcons.check,
          isPrimaryLoading: saving,
          onPrimary: saving ? null : onSave,
        ),
      ],
    );
  }
}
