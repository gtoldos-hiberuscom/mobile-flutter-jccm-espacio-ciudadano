import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_checkbox.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_tag.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

class AppCaptchaCheck extends StatelessWidget {
  const AppCaptchaCheck({
    required this.label,
    required this.badgeLabel,
    required this.value,
    required this.onChanged,
    super.key,
    this.errorText,
    this.semanticsLabel,
    this.announceError = true,
  }) : assert(label.length > 0, 'label must not be empty'),
       assert(badgeLabel.length > 0, 'badgeLabel must not be empty'),
       assert(errorText == null || errorText.length > 0, 'errorText must not be empty'),
       assert(semanticsLabel == null || semanticsLabel.length > 0, 'semanticsLabel must not be empty');

  final String label;
  final String badgeLabel;
  final bool value;
  final String? errorText;
  final ValueChanged<bool?> onChanged;
  final String? semanticsLabel;
  final bool announceError;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final effectiveLabel = semanticsLabel ?? l10n.a11yCaptcha(label, badgeLabel);
    final useVerticalLayout = MediaQuery.textScalerOf(context).scale(1) > 1.5;
    final checkbox = Semantics(
      container: true,
      label: [effectiveLabel, if (errorText != null) errorText].join(', '),
      checked: value,
      enabled: true,
      validationResult: errorText == null ? SemanticsValidationResult.none : SemanticsValidationResult.invalid,
      onTap: () => onChanged(!value),
      child: ExcludeSemantics(
        child: AppCheckbox(
          label: label,
          value: value,
          isError: errorText != null,
          errorText: errorText,
          contentPadding: EdgeInsets.zero,
          onChanged: onChanged,
        ),
      ),
    );
    final badge = ExcludeSemantics(
      child: AppTag(
        status: AppTagStatus.infoInactive,
        label: badgeLabel,
        showIcon: false,
      ),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        border: Border.all(
          color: errorText == null ? AppColors.borderBlueMutedLight : AppColors.error,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space12),
        child: Semantics(
          container: true,
          explicitChildNodes: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (errorText != null)
                Semantics(
                  container: true,
                  label: l10n.a11yFieldError(label, errorText!),
                  liveRegion: announceError,
                  child: const SizedBox(width: 1, height: 1),
                ),
              if (useVerticalLayout) ...[
                checkbox,
                const SizedBox(height: AppDimensions.space8),
                Align(alignment: AlignmentDirectional.centerEnd, child: badge),
              ] else
                Row(
                  children: [
                    Expanded(child: checkbox),
                    const SizedBox(width: AppDimensions.space12),
                    badge,
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
